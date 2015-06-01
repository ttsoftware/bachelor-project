require 'spec_helper'

describe Visualizer, :type => :class do

    describe '#visualize' do

        it 'should visualize json data' do

            visualizer = Visualizer.new

            visualizer.visualize_four :mismatches
            visualizer.visualize_four :deletions
            visualizer.visualize_four :insertions
            visualizer.visualize_four :mismatches_deletions
            visualizer.visualize_four :mismatches_insertions
            visualizer.visualize_four :deletions_insertions
            visualizer.visualize_four :insertions
            visualizer.visualize_two :combinations
            visualizer.visualize_one :ranges
            visualizer.visualize_one :sequences
            visualizer.visualize_one :match_count
            visualizer.visualize_one :match_count_speed
        end
    end
end
