require 'spec_helper'

describe Translater, :type => :class do

    before :each do

        @translater = Translater.new 'AG[2,1,1]'
    end

    describe '#translate' do

        it 'returns a valid regular expression' do

            regex_pattern = @translater.translate

            pp regex_pattern

            match = regex_pattern.match('AA')

            expect(match).to be_an_instance_of MatchData
        end
    end
end