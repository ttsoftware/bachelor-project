class Lexer

    def initialize(pattern)
        @pattern = pattern
    end

    # Returns a list of tokens each containing the smallest possible sub-pattern
    # @return [Array]
    def tokenize
        return @pattern.split /\s+/
    end
end