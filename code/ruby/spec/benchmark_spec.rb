require 'spec_helper'

describe Benchmark, :type => :class do

    describe '#ruby' do

        it 'finds benchmarks all patscan files in subdirectories of benchmark enviroment' do

            benchmark = Benchmark.new
            benchmark.ruby
        end
    end
end