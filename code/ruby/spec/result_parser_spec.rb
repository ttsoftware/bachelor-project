require 'spec_helper'

describe ResultParser, :type => :class do

    describe '#ruby_results' do

        it 'should write ruby results in a data file' do

            parser = ResultParser.new
            parser.ruby_results
        end
    end

    describe '#re2_results' do

        it 'should write re2 results in a data file' do

            parser = ResultParser.new
            parser.re2_results
        end
    end

    describe '#scan_for_matches_results' do

        it 'should write scan_for_matches results in a data file' do

            parser = ResultParser.new
            parser.scan_for_matches_results
        end
    end

    describe '#differences' do

        it 'should write the differences in a data file' do
            parser = ResultParser.new
            parser.differences
        end
    end
end