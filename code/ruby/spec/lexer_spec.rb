require 'spec_helper'

describe Lexer, :type => :class do

    before :each do
        @lexer = Lexer.new "ATCG"
    end

    describe '#tokenize' do

        it 'returns a list of string tokens' do

            tokens = @lexer.tokenize

            expect(tokens).to be_an_instance_of Array
            expect(tokens.length).to eq 1
            expect(tokens[0]).to be_an_instance_of String
        end
    end
end