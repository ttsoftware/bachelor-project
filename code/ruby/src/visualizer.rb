class Visualizer

    def initialize

        @env = '../benchmark/parsed_results/'
        
        @mode = {
            :mismatches => {
                :re2 => "#{@env}re2_mismatches_",
                :ruby => "#{@env}ruby_mismatches_",
                :scan => "#{@env}scan_for_matches_mismatches_",
                :xlabel => 'RE clauses',
                :ylabel => 'Match time [ms]',
                :title => 'Mismatches',
                :log => 'set logscale x 2'
            },
            :deletions => {
                :re2 => "#{@env}re2_deletions_",
                :ruby => "#{@env}ruby_deletions_",
                :scan => "#{@env}scan_for_matches_deletions_",
                :xlabel => 'RE clauses',
                :ylabel => 'Match time [ms]',
                :title => 'Deletions',
                :log => 'set logscale x 2'
            },
            :insertions => {
                :re2 => "#{@env}re2_insertions_",
                :ruby => "#{@env}ruby_insertions_",
                :scan => "#{@env}scan_for_matches_insertions_",
                :xlabel => 'RE clauses',
                :ylabel => 'Match time [ms]',
                :title => 'Insertions',
                :log => 'set logscale x 2'
            },
            :combinations => {
                :re2 => "#{@env}re2_combinations_",
                :ruby => "#{@env}ruby_combinations_",
                :scan => "#{@env}scan_for_matches_combinations_",
                :xlabel => 'RE clauses',
                :ylabel => 'Match time [ms]',
                :title => 'Combinations',
                :log => 'set logscale x 2'
            },
            :ranges => {
                :re2 => "#{@env}re2_range.data",
                :ruby => "#{@env}ruby_range.data",
                :scan => "#{@env}scan_for_matches_range.data",
                :xlabel => 'Size of range',
                :ylabel => 'Match time [ms]',
                :title => 'Ranges',
                :log => ''
            },
            :sequences => {
                :re2 => "#{@env}re2_sequences.data",
                :ruby => "#{@env}ruby_sequences.data",
                :scan => "#{@env}scan_for_matches_sequences.data",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Sequences',
                :log => ''
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
            set output '../../tex/rapport/graphs/re_cases_#{mode}.png'

            # axes label
            set xlabel '#{@mode[mode][:xlabel]}'
            set ylabel '#{@mode[mode][:ylabel]}'

            # title
            set title '#{@mode[mode][:title]}'

            #{@mode[mode][:log]}

            # data
            set style line 1 lc rgb '#FF6060' lt 1 lw 2 pt 7 ps 0.5   # --- red
            set style line 2 lc rgb '#6060FF' lt 1 lw 2 pt 7 ps 0.5   # --- blue
            set style line 3 lc rgb '#60FF60' lt 1 lw 2 pt 7 ps 0.5   # --- green

            # Start multiplot (2x2 layout)
            set multiplot layout 2,2 rowsfirst
            plot '#{@mode[mode][:re2]}1.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}1.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}1.data' with linespoints ls 3 title 'scan_for_matches'

            plot '#{@mode[mode][:re2]}2.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}2.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}2.data' with linespoints ls 3 title 'scan_for_matches'

            plot '#{@mode[mode][:re2]}3.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}3.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}3.data' with linespoints ls 3 title 'scan_for_matches'

            plot '#{@mode[mode][:re2]}4.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}4.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}4.data' with linespoints ls 3 title 'scan_for_matches'
            unset multiplot
        "

        gnuplot(commands)
    end
end