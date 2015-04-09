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

            regex_pattern = Translater.new('AGTCT[2,2,2]').translate

            pp regex_pattern


            # Known errors:
            err1 = regex_pattern.match('NAGTCT')
            err2 = regex_pattern.match('AGTCTN')
            err3 = regex_pattern.match('AGNTCT')

            expect(err1).to be_an_instance_of MatchData
            expect(err2).to be_an_instance_of MatchData
            expect(err3).to be_an_instance_of MatchData

            match_m = regex_pattern.match('ANNCT')
            match_i = regex_pattern.match('AGNTCNT')
            match_d = regex_pattern.match('ACT')
            match_mi = regex_pattern.match('NANNCNT')
            match_md = regex_pattern.match('NNT')
            match_mid = regex_pattern.match('NNNNT')
            match_wrong = regex_pattern.match('NN')

            expect(match_m).to be_an_instance_of MatchData
            expect(match_i).to be_an_instance_of MatchData
            expect(match_d).to be_an_instance_of MatchData
            expect(match_mi).to be_an_instance_of MatchData
            expect(match_md).to be_an_instance_of MatchData
            expect(match_mid).to be_an_instance_of MatchData
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