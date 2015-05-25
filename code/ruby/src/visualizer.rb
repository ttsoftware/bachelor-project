class Visualizer

    # @param [Hash] data
    def initialize(data)
        @data = data
    end

    def gnuplot(commands)
        IO.popen('gnuplot', 'w') { |io| io.puts commands }
    end

    def visualize
        commands = '
            set terminal svg
            # white background
            set object 1 rect from screen 0, 0, 0 to screen 1, 1, 0 behind
            set object 1 rect fc  rgb "white"  fillstyle solid 1.0
            # file name
            set output "penis.svg"
            # data
            set style line 1 lc rgb "#FF6060" lt 1 lw 2 pt 7 ps 0.5   # --- red
            set style line 2 lc rgb "#6060FF" lt 1 lw 2 pt 7 ps 0.5   # --- blue
            set style line 3 lc rgb "#60FF60" lt 1 lw 2 pt 7 ps 0.5   # --- green


            set xr [0:10]
            set yr [0:100]
            plot "../patscan-patterns/benchmark/results/result_data/re2_deletions.data" with linespoints ls 1 title "RE2", \
                 "../patscan-patterns/benchmark/results/result_data/ruby_deletions.data" with linespoints ls 2 title "Ruby", \
                 "../patscan-patterns/benchmark/results/result_data/scan_for_matches_deletions.data" with linespoints ls 3 title "scan-for-matches"
        '

        gnuplot(commands)
    end
end