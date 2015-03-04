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

        return Regexp.new expression
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

        chars.each_index { |i|

            print chars[i] + ": \n"

            # combine with all chars after
            mismatches.times { |m|

                seq = chars.clone
                seq[i] = "[^#{seq[i]}]"
                char_exp = seq
                char_exp_final = []

                # combine with all chars after i
                m.times { |mm| # 0 times, 1 times, ..., m times

                    chars.each_with_index { |char, j|

                        next if j == i

                        # replace at index j
                        inner_seq = char_exp.clone
                        inner_seq[j] = "[^#{char}]"

                        # TODO: At this point we definetly need regression!

                        exp = inner_seq.join

                        print "\t #{m+1} mismatches #{char}: " + exp + "\n"
                        char_exp_final << exp unless char_exp_final.include? exp
                    }
                }

                # prevent too many duplicate clauses
                if char_exp_final.length > 0
                    final_string = '(' + char_exp_final.join(')|(') + ')'
                    expression << final_string unless expression.include? final_string
                end

                print "\t"
                pp char_exp_final
                print "\n"
            }
        }

        return '(' + expression.join(')|(') + ')'
    end
end