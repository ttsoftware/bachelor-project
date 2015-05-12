require 'spec_helper'

describe Benchmark, :type => :class do

    describe '#ruby' do

        it 'finds benchmarks all patscan files in subdirectories of benchmark enviroment' do

            benchmark = Benchmark.new 20
            benchmark.ruby
        end
    end

    describe '#re2' do

        it 'works with re2' do

            benchmark = Benchmark.new 10
            benchmark.re2
        end
    end
end