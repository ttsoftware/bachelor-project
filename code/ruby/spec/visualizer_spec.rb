require 'spec_helper'

describe Visualizer, :type => :class do

    describe '#visualize' do

        it 'should visualize json data' do

            visualizer = Visualizer.new
            visualizer.visualize
        end
    end
end
