require 'spec_helper'

describe ResultParser, :type => :class do

    describe '#ruby_results' do

        it 'should return ruby results in a Hash' do

            parser = ResultParser.new
            results = parser.ruby_results

            pp results
        end
    end
end