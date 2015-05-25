require 'spec_helper'

describe ResultParser, :type => :class do

    describe '#ruby_results' do

        it 'should return ruby results in a json file' do

            parser = ResultParser.new
            parser.ruby_results
        end
    end

    describe '#re2_results' do

        it 'should return re2 results in a json file' do

            parser = ResultParser.new
            parser.re2_results
        end
    end

    describe '#scan_for_matches_results' do

        it 'should write scan_for_matches results in a json file' do

            parser = ResultParser.new
            parser.scan_for_matches_results
        end
    end
end