class Translater

    def initialize(pattern)

        @pattern = pattern

        lexer = Lexer.new pattern
        parser = Parser.new lexer.tokenize

        @tokens = parser.parse
    end

    def translate

        pp @tokens

        
    end
end