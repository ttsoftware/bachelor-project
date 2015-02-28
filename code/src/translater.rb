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
                    raise 'not implemented'
                when T::SEQUENCE_PERMUTATION
                    expression << translate_permutation(token)
                when T::DELIMITER
                    raise 'not implemented'
                else
                    raise 'Invalid token type.'
            end
        }

        return expression
    end

    # @param [Token] token
    # @return [String]
    def translate_permutation(token)

        sequence = token.value['sequence']

        mismatches = token.value['mismatches'].to_i
        insertions = token.value['insertions'].to_i
        deletions = token.value['deletions'].to_i

        # split all chars
        chars = sequence.split //

        # we initialize with sequence, because we do not necessarily have any mismatches, insertions or deletions
        expression = [sequence]

        mismatches.times { |m|

            # todo wat
        }

        return expression.join '|'
    end
end