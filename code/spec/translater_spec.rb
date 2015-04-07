require 'spec_helper'

describe Translater, :type => :class do

    before :each do

        @translater = Translater.new 'GGGTGCAAGCGTTAAT[2,1,1]'
    end

    describe '#translate' do

        it 'returns a valid regular expression' do

            regex_pattern = @translater.translate

            match = (Regexp.new regex_pattern).match('AAGTGCAAGCGTTAAT')

            expect(match).to be_an_instance_of MatchData
        end
    end
end