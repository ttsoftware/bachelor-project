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

        mismatch_mat = Array.new

        # For every char as index
        chars.each_index { |c_i|

            # Construct indices for each allowed mismatch, all starting
            # at current char
            indices = Array.new(mismatches, c_i)

            # Initialize index to last index in indices
            index = indices.length - 1

            # While indices[1] isn't at the end
            while indices[1] < chars.length

                # If indices[index] reaches the end
                if indices[index] >= chars.length
                    # Decrement index
                    index -= 1 
                end

                # While indices[index] isn't at the end
                while indices[index] < chars.length

                    # Append row to matrix
                    mismatch_mat = append_row(mismatch_mat, indices, chars.length)

                    indices[index] += 1
                end

                # Update indices
                indices = update_indices(indices, index)
            end
        }

        pp mismatch_mat

        return expression.join '|'
    end

    def update_indices(indices, index)

        indices[index] += 1
        (indices.length - index - 1).times { |i|
            indices[index + i + 1] = indices[index + i]
        }
        return indices
    end

    def append_row(mat, indices, len)
        row = Array.new(len, 0)
        indices.each { |i|
            row[i] = 1
        }
        mat << row
        return mat
    end

end