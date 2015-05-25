require 'spec_helper'

describe Visualizer, :type => :class do

    describe '#visualize' do

        it 'should visualize json data' do

            visualizer = Visualizer.new
            visualizer.visualize :mismatches
            visualizer.visualize :deletions
            visualizer.visualize :insertions
            visualizer.visualize :combinations
            visualizer.visualize :ranges
            visualizer.visualize :sequences
        end
    end
end
