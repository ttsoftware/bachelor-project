class Translater

    def initialize(pattern)

        @value = pattern

        lexer = Lexer.new pattern
        parser = Parser.new lexer.tokenize
        @tokens = parser.parse
    end

    # @return [String]
    def translate

        expression = ''

        @tokens.each { |token|
            case token.type
                when T::ASSIGNMENT
                    raise 'not implemented'
                when T::VARIABLE
                    raise 'not implemented'
                when T::SEQUENCE
                    expression << translate_sequence(token)
                when T::SEQUENCE_COMBINATION
                    expression << translate_combination(token)
                when T::RANGE
                    expression << translate_range(token)
                else
                    raise 'Invalid token.'
            end
        }

        return Regexp.new expression
    end

    # Takes the sequence from the token and returns it
    #
    # @param [Token] token
    # @return [String]
    def translate_sequence(token)
        return token.value['sequence']
    end

    # Calls find_combinations to find all possible combinations of
    # the sequence, for the given numbers of mismatches, insertions,
    # and deletions, given in the token.
    #
    # @param [Token] token
    # @return [String]
    def translate_combination(token)

        # Extracts the sequence from the token
        sequence = token.value['sequence']

        # Extracts the number of possible mismatches, insertions, and deletions from the token
        mismatches = token.value['mismatches'].to_i
        insertions = token.value['insertions'].to_i
        deletions = token.value['deletions'].to_i

        # Finds all possible combinations, and appends each of them to combination_list
        combination_list = []
        find_combinations(sequence, mismatches, insertions, deletions).each { |x|
            combination_list << '(' + x.value + ')'
        }

        # Joins all combinations with a pipe between each combination, and returns the string
        return '(' + combination_list.join('|') + ')'
    end

    # Finds all possible combinations of mismatches, insertions, and deletions in
    # the given sequence.
    #
    # @param [String] sequence
    # @param [Int] m_max
    # @param [Int] i_max
    # @param [Int] d_max
    #
    # @return [String list]
    def find_combinations(sequence, m_max, i_max, d_max)
        if sequence.length > 1
            # If the length of the sequence is more than 1, it is dividable

            left_tree = find_combinations(sequence[0..(sequence.length/2).floor-1], m_max, i_max, d_max)
            right_tree = find_combinations(sequence[(sequence.length/2).floor..-1], m_max, i_max, d_max)
        else
            # If it is not dividable, create each combination of mismatches, insertions, and deletions
            # for that particular character, and return.

            insertion_combinations = []
            i_max.times { |i|
                insertion_combinations << Leaf.new(".{#{i+1}}#{sequence}", mismatches=0, insertions=i+1, deletions=0)
                insertion_combinations << Leaf.new("#{sequence}.{#{i+1}}", mismatches=0, insertions=i+1, deletions=0)
            }

            return [Leaf.new(sequence, mismatches=0, insertions=0, deletions=0),
                    Leaf.new("[^#{sequence}]", mismatches=1, insertions=0, deletions=0),
                    Leaf.new('', mismatches=0, insertions=0, deletions=1)] + insertion_combinations
        end

        combined = []

        # Combines each leaf from the left tree with each leaf in the right tree,
        # thus creating all possible combinations of each tree.

        left_tree.each{ |left_leaf|
            right_tree.each{ |right_leaf|

                # If a combination would lead to a violation of the given maximum number of
                # mismatches, insertions, or deletions, the iteration will be skipped.

                if (left_leaf.mismatches + right_leaf.mismatches) > m_max \
                    or (left_leaf.insertions + right_leaf.insertions) > i_max \
                    or (left_leaf.deletions + right_leaf.deletions) > d_max

                    next
                end

                combined << Leaf.new(left_leaf.value + right_leaf.value,
                                     mismatches=left_leaf.mismatches + right_leaf.mismatches,
                                     insertions=left_leaf.insertions + right_leaf.insertions,
                                     deletions=left_leaf.deletions + right_leaf.deletions)
            }
        }

        return combined
    end

    def translate_range(token)
        from = token.value['from']
        to = token.value['to']

        return '.{' + from + ',' + to + '}'
    end
end