require_relative 'spec_helper'

describe Benchmark, :type => :class do

    describe '#generate_patterns' do
        it 'generates the patterns' do
            benchmark = Benchmark.new 15, 60
            benchmark.generate_patterns
        end
    end

    describe '#ruby' do

        it 'finds benchmarks all patscan files in subdirectories of benchmark enviroment' do

            benchmark = Benchmark.new 30, 60
            benchmark.ruby
        end
    end

    describe '#python' do

        it 'works with python' do

            benchmark = Benchmark.new 30, 60
            benchmark.python
        end
    end

    describe '#re2' do

        it 'works with re2' do

            benchmark = Benchmark.new 30, 60
            benchmark.re2
        end
    end

    describe '#scan-for-matches' do

        it 'works with scan-for-matches' do
            benchmark = Benchmark.new 30, 60
            benchmark.scan_for_matches
        end
    end
end