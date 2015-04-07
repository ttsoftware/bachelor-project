
class Parser

    def initialize(tokens)
        @tokens = tokens
        @parsed_tokens = []
    end

    def parse

        # we need the variable table in order to correctly differentiate between sequences and variable usages
        @variable_table = create_var_table

        @tokens.each { |token_string|

            assignment_match = get_assignment token_string
            unless assignment_match.nil?
                @parsed_tokens << Token.new(T::ASSIGNMENT, assignment_match)
                next
            end

            variable_match = get_variable token_string
            unless variable_match.nil?
                # check if this is in fact a variable
                if @variable_table.has_key? variable_match['variable_name']
                    @parsed_tokens << Token.new(T::VARIABLE, variable_match)
                    next
                end
            end

            sequence_match = get_sequence token_string
            unless sequence_match.nil?
                @parsed_tokens << Token.new(T::SEQUENCE, sequence_match)
                next
            end

            sequence_permutation_match = get_permutation token_string
            unless sequence_permutation_match.nil?
                @parsed_tokens << Token.new(T::SEQUENCE_PERMUTATION, sequence_permutation_match)
                next
            end

            range_match = get_range token_string
            unless range_match.nil?
                @parsed_tokens << Token.new(T::RANGE, range_match)
            end
        }

        return @parsed_tokens
    end

    # Find and store all variable assignments
    # @return [Hash]
    def create_var_table

        var_table = Hash.new
        @tokens.each { |token_string|
            matchObj = get_assignment token_string
            unless matchObj.nil?
                var_table[matchObj['variable_name']] = matchObj['variable_value']
            end
        }

        return var_table
    end

    # Discover variable assignment
    #
    # @param [String] token_string
    # @return [MatchData]
    def get_assignment(token_string)
        return /^(?<variable_name>[^=]+)=(?<variable_value>[^=]+)$/.match token_string
    end

    # Discover variable usage
    #
    # @param [String] token_string
    # @return [MatchData]
    def get_variable(token_string)
        return /^(?<negation>~)?(?<variable_name>[^=]+)$/.match token_string
    end

    # Discover a sequence
    #
    # @param [String] token_string
    # @return [MatchData]
    def get_sequence(token_string)
        return /^(?<sequence>\w+)$/.match token_string
    end

    # Discover sequence with mismatch, insertion, deletion permutations
    #
    # @param [String] token_string
    # @return [MatchData]
    def get_permutation(token_string)
        return /^(?<sequence>\w+)\[(?<mismatches>\d+),(?<insertions>\d+),(?<deletions>\d+)\]$/.match token_string
    end

    # Discover ... delimiter
    #
    # @param [String] token_string
    # @return [MatchData]
    def get_range(token_string)
        return /^(?<from>\d+)\.{3}(?<to>\d+)$/.match token_string
    end
end