require 'spec_helper'

describe Translater, :type => :class do

    describe '#translate' do
        it 'returns a valid regular expression of a sequence' do

            regex_pattern = Regexp.new '^' + Translater.new('AGGATTCA').translate + '$'

            match_right = regex_pattern.match('AGGATTCA')
            match_wrong = regex_pattern.match('AGGNTTCA')

            expect(match_right).to be_an_instance_of MatchData
            expect(match_wrong). to be nil
        end

        it 'returns a valid regular expression with deletions' do
            regex_pattern = Regexp.new Translater.new('AGTCT[0,2,0]').translate

            match_0 = regex_pattern.match('AGTCT')
            match_1 = regex_pattern.match('AGTC')
            match_2 = regex_pattern.match('AGT')
            match_3 = regex_pattern.match('GT') # should not match

            expect(match_0).to be_an_instance_of MatchData
            expect(match_1).to be_an_instance_of MatchData
            expect(match_2).to be_an_instance_of MatchData
            expect(match_3).to be nil
        end

        it 'returns a valid regular expression with insertions' do
            pattern = Translater.new('AGTCT[0,0,2]').translate
            regex_pattern = Regexp.new pattern

            match_0 = regex_pattern.match('AGTCT')
            match_1 = regex_pattern.match('AGTMCT')
            match_2 = regex_pattern.match('MAGTMCT')
            match_3 = regex_pattern.match('AMGTMMCT') # should not match

            expect(match_0).to be_an_instance_of MatchData
            expect(match_1).to be_an_instance_of MatchData
            expect(match_2).to be_an_instance_of MatchData
            expect(match_3).to be nil
        end

        it 'returns a valid regular expression with mismatches' do
            regex_pattern = Regexp.new Translater.new('AGTCT[2,0,0]').translate

            match_0 = regex_pattern.match('AGTCT')
            match_1 = regex_pattern.match('MGTCT')
            match_2 = regex_pattern.match('MGTMT')
            match_3 = regex_pattern.match('MMTMT')
            match_4 = regex_pattern.match('MMMCT') # should not match

            expect(match_0).to be_an_instance_of MatchData
            expect(match_1).to be_an_instance_of MatchData
            expect(match_2).to be_an_instance_of MatchData
            expect(match_3).to be nil
            expect(match_4).to be nil
        end

        it 'returns a valid regular expression with all three' do
            regex_pattern = Regexp.new '^' + Translater.new('AGTCT[2,2,2]').translate + '$'

            match_0 = regex_pattern.match('AGTCT')
            match_1 = regex_pattern.match('MGTMC')
            match_2 = regex_pattern.match('CMMCA')
            match_3 = regex_pattern.match('MMMAGTCT') # should not match
            match_4 = regex_pattern.match('MMCCCCT') # should not match
            match_5 = regex_pattern.match('MM') # should not match

            expect(match_0).to be_an_instance_of MatchData
            expect(match_1).to be_an_instance_of MatchData
            expect(match_2).to be_an_instance_of MatchData
            expect(match_3).to be nil
            expect(match_4).to be nil
            expect(match_5).to be nil
        end

        it 'supports chained tokens' do
            regex_pattern = Regexp.new Translater.new('AAAGT[2,0,0] 2...4 TNTGCC[1,1,0]').translate

            match_0 = regex_pattern.match('AGTGTNNNNANTGC') # 2 mismatches, 4 random, 1 mismatch & 1 deletion.

            expect(match_0).to be_an_instance_of MatchData
        end

        it 'returns a valid regular expression of a range' do
            regex_pattern = Regexp.new Translater.new('4...8').translate

            match_right = regex_pattern.match('NNNNNNN')
            match_wrong = regex_pattern.match('NNN')

            expect(match_right).to be_an_instance_of MatchData
            expect(match_wrong).to be nil
        end

        it 'returns a valid regular expression of a variable assignment and usage' do
            regex_pattern = Regexp.new Translater.new('p1=ATC[1,0,0] ~p1').translate

            match_right = regex_pattern.match('AMCTMG')
            match_wrong = regex_pattern.match('ATCAMC')

            expect(match_right).to be_an_instance_of MatchData
            expect(match_wrong).to be nil
        end

        it 'matches the same as scan_for_matches' do
            regex_pattern = Regexp.new Translater.new('AGCGTGGGGAGCAAAC[2,0,1]').translate

            expect(regex_pattern.match('TGCTGTAGGGAGCAAAC')).to be_an_instance_of MatchData
            expect(regex_pattern.match('AGCCGTGGGGAGCCTAC')).to be_an_instance_of MatchData
            expect(regex_pattern.match('AGACCTGGGGAGGAAAC')).to be_an_instance_of MatchData
            expect(regex_pattern.match('CGCAGTGGGGAGCAGAC')).to be_an_instance_of MatchData
            expect(regex_pattern.match('AGCCTGGGGAGCAGATC')).to be_an_instance_of MatchData
        end
    end
end