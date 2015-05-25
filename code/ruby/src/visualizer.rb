class Visualizer

    # @param [Hash] data
    def initialize(data)
        @data = data
    end

    def gnuplot(commands)
        IO.popen('gnuplot', 'w') { |io| io.puts commands }
    end

    def visualzie
        commands = '
            set terminal svg
            # white background
            set object 1 rect from screen 0, 0, 0 to screen 1, 1, 0 behind
            set object 1 rect fc  rgb "white"  fillstyle solid 1.0
            # file name
            set output "penis.svg"
            # data
        '

        gnuplot(commands)
    end
end