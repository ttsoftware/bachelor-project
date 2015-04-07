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
                when T::SEQUENCE_PERMUTATION
                    expression << translate_permutation(token)
                when T::RANGE
                    expression << translate_range(token)
                else
                    raise 'Invalid token type.'
            end
        }

        return Regexp.new expression
    end

    # @param [Token] token
    # @return [String]
    def translate_sequence(token)
        return token.value['sequence']
    end

    # @param [Token] token
    # @return [String]
    def translate_permutation(token)

        sequence = token.value['sequence']

        mismatches = token.value['mismatches'].to_i
        insertions = token.value['insertions'].to_i
        deletions = token.value['deletions'].to_i

        combination_list = []
        find_combinations(sequence, mismatches).each { |x|
            combination_list << '(' + x.value + ')'
        }

        return combination_list.join '|'
    end

    def find_combinations(sequence, m_max)
        if sequence.length > 1
            list1 = find_combinations(sequence[0..(sequence.length/2).floor-1], m_max)
            list2 = find_combinations(sequence[(sequence.length/2).floor..-1], m_max)
        else
            return [Leaf.new(sequence, 0), Leaf.new('[^' + sequence + ']', 1)]
        end

        new_list = []

        list1.each{ |x|
            list2.each{ |y|
                if (x.mismatches + y.mismatches) > m_max
                    next
                end
                new_list << Leaf.new(x.value + y.value, x.mismatches + y.mismatches)
            }
        }
        return new_list
    end
    
    def translate_range(token)
        from = token.value['from']
        to = token.value['to']

        return '.{' + from + ',' + to + '}'
    end
end