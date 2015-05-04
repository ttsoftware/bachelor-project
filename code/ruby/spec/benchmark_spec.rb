require 'spec_helper'

describe Benchmark, :type => :class do

    describe '#files' do

        it 'finds all patscan files in subdirectories of benchmark enviroment' do

            @benchmark = Benchmark.new

            @benchmark.files
        end
    end
end