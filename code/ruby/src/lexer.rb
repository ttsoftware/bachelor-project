class Lexer

    def initialize(pattern)
        @value = pattern
    end

    # Returns a list of tokens each containing the smallest possible sub-pattern
    # @return [Array]
    def tokenize
        return @value.split /\s+/
    end
end