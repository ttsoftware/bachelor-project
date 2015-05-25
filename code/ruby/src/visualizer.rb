class Visualizer

    def initialize

        @mode = {
            :mismatches => {
                :re2 => '../patscan-patterns/benchmark/results/result_data/re2_mismatches.data',
                :ruby => '../patscan-patterns/benchmark/results/result_data/ruby_mismatches.data',
                :scan => '../patscan-patterns/benchmark/results/result_data/scan_for_matches_mismatches.data',
                :xlabel => 'RE length',
                :ylabel => 'Match time [ms]',
                :title => 'Mismatches: RE length'
            },
            :deletions => {
                :re2 => '../patscan-patterns/benchmark/results/result_data/re2_deletions.data',
                :ruby => '../patscan-patterns/benchmark/results/result_data/ruby_deletions.data',
                :scan => '../patscan-patterns/benchmark/results/result_data/scan_for_matches_deletions.data',
                :xlabel => 'RE length',
                :ylabel => 'Match time [ms]',
                :title => 'Deletions: RE length'
            },
            :insertions => {
                :re2 => '../patscan-patterns/benchmark/results/result_data/re2_insertions.data',
                :ruby => '../patscan-patterns/benchmark/results/result_data/ruby_insertions.data',
                :scan => '../patscan-patterns/benchmark/results/result_data/scan_for_matches_insertions.data',
                :xlabel => 'RE length',
                :ylabel => 'Match time [ms]',
                :title => 'Insertions: RE length'
            },
            :combinations => {
                :re2 => '../patscan-patterns/benchmark/results/result_data/re2_combinations.data',
                :ruby => '../patscan-patterns/benchmark/results/result_data/ruby_combinations.data',
                :scan => '../patscan-patterns/benchmark/results/result_data/scan_for_matches_combinations.data',
                :xlabel => 'RE length',
                :ylabel => 'Match time [ms]',
                :title => 'Combinations: RE length'
            },
            :ranges => {
                :re2 => '../patscan-patterns/benchmark/results/result_data/re2_range.data',
                :ruby => '../patscan-patterns/benchmark/results/result_data/ruby_range.data',
                :scan => '../patscan-patterns/benchmark/results/result_data/scan_for_matches_range.data',
                :xlabel => 'RE length',
                :ylabel => 'Match time [ms]',
                :title => 'Ranges: RE length'
            },
            :sequences => {
                :re2 => '../patscan-patterns/benchmark/results/result_data/re2_sequences.data',
                :ruby => '../patscan-patterns/benchmark/results/result_data/ruby_sequences.data',
                :scan => '../patscan-patterns/benchmark/results/result_data/scan_for_matches_sequences.data',
                :xlabel => 'RE length',
                :ylabel => 'Match time [ms]',
                :title => 'Sequences: RE length'
            }
        }
    end

    def gnuplot(commands)
        IO.popen('gnuplot', 'w') { |io| io.puts commands }
    end

    def visualize(mode)
        commands = "
            set terminal pngcairo size 800,600

            # file name
            set output '../../tex/rapport/graphs/#{mode}.png'

            # axes label
            set xlabel '#{@mode[mode][:xlabel]}'
            set ylabel '#{@mode[mode][:ylabel]}'

            # title
            set title '#{@mode[mode][:title]}'

            # data
            set style line 1 lc rgb '#FF6060' lt 1 lw 2 pt 7 ps 0.5   # --- red
            set style line 2 lc rgb '#6060FF' lt 1 lw 2 pt 7 ps 0.5   # --- blue
            set style line 3 lc rgb '#60FF60' lt 1 lw 2 pt 7 ps 0.5   # --- green

            plot '#{@mode[mode][:re2]}' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}' with linespoints ls 3 title 'scan_for_matches'
        "

        gnuplot(commands)
    end
end