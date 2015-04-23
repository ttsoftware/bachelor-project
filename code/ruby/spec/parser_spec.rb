require 'spec_helper'

describe Parser, :type => :class do

    before :each do
        @lexer = Lexer.new 'p1=0...1 AC p1 AT[0,1,2]'
        @parser = Parser.new @lexer.tokenize
    end

    describe '#parse' do

        it 'returns an array of parsed tokens' do

            tokens = @parser.parse

            expect(tokens.length).to eq 4
        end
    end

    describe '#get_assignment' do

        it 'returns a match object' do

            match_obj = @parser.get_assignment 'p1=0...1'

            expect(match_obj).to_not eq nil
            expect(match_obj['variable_name']).to eq 'p1'
            expect(match_obj['variable_value']).to eq '0...1'
        end
    end

    describe '#get_variable' do

        it 'returns a match object' do
            match_obj = @parser.get_variable '~p1'

            expect(match_obj).to_not eq nil
            expect(match_obj['negation']).to eq '~'
            expect(match_obj['variable_name']).to eq 'p1'
            expect(match_obj['mismatches']).to eq nil
        end

        it 'finds variable names' do

            match_obj = @parser.get_variable 'p1[1,0,0]'

            expect(match_obj).to_not eq nil
            expect(match_obj['negation']).to eq nil
            expect(match_obj['variable_name']).to eq 'p1'
            expect(match_obj['mismatches']).to eq '1'
            expect(match_obj['insertions']).to eq '0'
            expect(match_obj['deletions']).to eq '0'
        end
    end

    describe '#get_sequence' do

        it 'returns a match object' do
            match_obj = @parser.get_sequence 'AACCCTTG'
            
            expect(match_obj).to_not eq nil
            expect(match_obj['sequence']).to eq 'AACCCTTG'
        end
    end

    describe '#get_permutation' do

        it 'returns a match object' do
            match_obj = @parser.get_combination 'A[0,1,2]'
            
            expect(match_obj).to_not eq nil
            expect(match_obj['sequence']).to eq 'A'
            expect(match_obj['mismatches']).to eq '0'
            expect(match_obj['insertions']).to eq '1'
            expect(match_obj['deletions']).to eq '2'
        end
    end

    describe '#get_delimiter' do

        it 'returns a match object' do
            match_obj = @parser.get_range '0...1'

            expect(match_obj).to_not eq nil
            expect(match_obj['from']).to eq '0'
            expect(match_obj['to']).to eq '1'
        end
    end
end