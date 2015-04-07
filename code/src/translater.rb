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

        mismatch_combinations = find_mismatches(mismatches, sequence)

        return mismatch_combinations.join '|'
    end

    def find_mismatches(mismatches, missing, chosen='')
        if mismatches == 0
            return ['(' + chosen + missing + ')']
        elsif missing == ''
            return ['(' + chosen + ')']
        else
            return find_mismatches(mismatches, missing[1..-1], chosen + missing[0]) + find_mismatches(mismatches-1, missing[1..-1], chosen + '[^' + missing[0] + ']')
        end
    end

    def translate_range(token)
        from = token.value['from']
        to = token.value['to']

        return '.{' + from + ',' + to + '}'
    end

end