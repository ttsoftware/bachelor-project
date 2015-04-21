class Translater

    def initialize(pattern)

        @value = pattern

        lexer = Lexer.new pattern
        parser = Parser.new lexer.tokenize
        @tokens = parser.parse
        @var_table = Hash.new
    end

    # @return [String]
    def translate

        expression = ''

        @tokens.each { |token|
            case token.type
                when T::ASSIGNMENT
                    expression << translate_assignment(token)
                when T::VARIABLE
                    expression << translate_variable(token)
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

        return expression
    end

    def reverse_complement(sequence)
        reversed = []
        sequence.split(//).each { |c|
            case c
                when 'A'
                    reversed << 'T'
                when 'T'
                    reversed << 'A'
                when 'C'
                    reversed << 'G'
                when 'G'
                    reversed << 'C'
                when 'Y'
                    reversed << 'R'
                when 'R'
                    reversed << 'Y'
                when 'K'
                    reversed << 'M'
                when 'M'
                    reversed << 'K'
                when 'B'
                    reversed << 'V'
                when 'V'
                    reversed << 'B'
                when 'D'
                    reversed << 'H'
                when 'H'
                    reversed << 'D'
                else
                    reversed << c
            end
        }
        return reversed.join
    end

    # Translates the assigned value, saves it in var_table, and returns it
    #
    # @param [Token] token
    # @return [String]
    def translate_assignment(token)
        case token.assigned.type
            when T::SEQUENCE
                regex = translate_sequence token.assigned
                @var_table[token.value['variable_name']] = regex
                return regex

            when T::SEQUENCE_COMBINATION
                regex = translate_combination token.assigned
                @var_table[token.value['variable_name']] = regex
                return regex

            when T::RANGE
                raise 'Not implemented'
        end
    end

    def translate_variable(token)
        unless @var_table[token.value['variable_name']].nil?
            if token.value['negation'] == '~'
                return reverse_complement @var_table[token.value['variable_name']]
            elsif token.value['mismatches'] != nil
                # The variable usage has mismatches on it
                parser = Parser.new ['']
                return translate_combination Token.new(T::VARIABLE, parser.get_combination("#{@var_table[token.value['variable_name']]}[#{token.value['mismatches']},#{token.value['insertions']},#{token.value['deletions']}]"))
            else
                return @var_table[token.value['variable_name']]
            end
        end
        raise 'Variable not yet assigned'
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
                insertion_combinations << Leaf.new("[^N]{#{i+1}}#{sequence}", mismatches=0, insertions=i+1, deletions=0)
                insertion_combinations << Leaf.new("#{sequence}[^N]{#{i+1}}", mismatches=0, insertions=i+1, deletions=0)
            }

            return [Leaf.new(sequence, mismatches=0, insertions=0, deletions=0),
                    Leaf.new("[^#{sequence}N]", mismatches=1, insertions=0, deletions=0),
                    Leaf.new('', mismatches=0, insertions=0, deletions=1)] + insertion_combinations
        end

        combined = []

        # Hash table containing all unique combinations in this recursion step
        unique_combinations = Hash.new

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

                # If one of the combination exists in the {unique} table, it will be skipped
                # This is possible due to the fact that {Hash.has_key} has O(1) time complexity.

                unless unique_combinations.has_key? (left_leaf.value + right_leaf.value)

                    # Otherwise we add it to the table
                    unique_combinations[left_leaf.value + right_leaf.value] = true

                    combined << Leaf.new(left_leaf.value + right_leaf.value,
                                         mismatches=left_leaf.mismatches + right_leaf.mismatches,
                                         insertions=left_leaf.insertions + right_leaf.insertions,
                                         deletions=left_leaf.deletions + right_leaf.deletions)
                end
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