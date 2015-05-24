require 'spec_helper'

describe Benchmark, :type => :class do

    describe '#ruby' do

        it 'finds benchmarks all patscan files in subdirectories of benchmark enviroment' do

            benchmark = Benchmark.new 30, 120
            benchmark.ruby
        end
    end

    describe '#python' do

        it 'works with python' do

            benchmark = Benchmark.new 30, 120
            benchmark.python
        end
    end

    # describe '#re2' do
    #
    #     it 'works with re2' do
    #
    #         benchmark = Benchmark.new 30, 120
    #         benchmark.re2
    #     end
    # end
    #
    # describe '#scan-for-matches' do
    #
    #     it 'works with scan-for-matches' do
    #
    #         benchmark = Benchmark.new 30, 120
    #         benchmark.scan_for_matches
    #     end
    # end
end