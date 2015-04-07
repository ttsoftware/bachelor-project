require 'spec_helper'

describe Translater, :type => :class do
    describe '#translate' do

        it 'returns a valid regular expression of a sequence' do


            regex_pattern = Translater.new('AGGATTCA').translate

            pp regex_pattern

            match_right = regex_pattern.match('AGGATTCA')
            match_wrong = regex_pattern.match('AGGNTTCA')

            expect(match_right).to be_an_instance_of MatchData
            expect(match_wrong). to be nil
        end

        it 'returns a valid regular expression with mismatches' do

            regex_pattern = Translater.new('AGTCTAGTCTAGTCTAGTCT[5,0,0]').translate

            pp regex_pattern

            match_right = regex_pattern.match('ANNNNNGTCTAGTCTAGTCT')
            match_wrong = regex_pattern.match('ANNNNNNNNNAGTCTAGTCT')

            expect(match_right).to be_an_instance_of MatchData
            expect(match_wrong).to be nil
        end

        it 'returns a valid regular expression of a range' do

            regex_pattern = Translater.new('4...8').translate

            pp regex_pattern

            match_right = regex_pattern.match('NNNNNNN')
            match_wrong = regex_pattern.match('NNN')

            expect(match_right).to be_an_instance_of MatchData
            expect(match_wrong).to be nil
        end
    end
end