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

        # we initialize with sequence, because we do not necessarily have any mismatches, insertions or deletions
        expression = [sequence]
        #expression += permutate '', sequence, mismatches

        leafs = divide sequence

        expression += (conquer leafs, mismatches)

        pp sequence.length
        pp expression.length

        return '(' + expression.join(')|(') + ')'
    end

    # returns each leaf as itself and itself mismatched
    # @param [String] parameters
    # @return [Array]
    def divide(parameters)
        return (parameters.split //).map { |c| [Leaf.new(c, 0), Leaf.new("[^#{c}]", 1)] }
    end

    def conquer(leafs, mismatches)

        n = leafs.length

        combinations = []
        leafs.each_with_index { |l, i|

            l.each { |x|
                leafs[i+1].each { |c|
                    if (x.mismatches + c.mismatches) < mismatches
                        combinations << [Leaf.new(x.value + c.value,
                                                 x.mismatches + c.mismatches)]
                    end
                } if i+1 < leafs.length
            }
        }

        pp combinations

        #return conquer combinations, mismatches
    end

    # @param [String] exps Tail string
    # @param [String] parameters Parameters to choose from
    # @param [Integer] mismatches Mismatches left in current recursion step
    def permutate(exps, parameters, mismatches)

        return [exps + parameters] if mismatches == 0
        return [exps] if parameters == ''

        return permutate(
            exps + parameters[0],
            parameters[1..-1],
            mismatches
        ) + permutate(
            exps + "[^#{parameters[0]}]",
            parameters[1..-1],
            mismatches-1
        )
    end
    
    def translate_range(token)
        from = token.value['from']
        to = token.value['to']

        return '.{' + from + ',' + to + '}'
    end
end