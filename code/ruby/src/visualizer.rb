class Visualizer

    def initialize

        @env = '../benchmark/parsed_results/'
        
        @mode = {
            :mismatches => {
                :re2 => "#{@env}re2_mismatches_",
                :ruby => "#{@env}ruby_mismatches_",
                :scan => "#{@env}scan_for_matches_mismatches_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Mismatches',
                :log => 'set logscale y 2'
            },
            :deletions => {
                :re2 => "#{@env}re2_deletions_",
                :ruby => "#{@env}ruby_deletions_",
                :scan => "#{@env}scan_for_matches_deletions_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Deletions',
                :log => 'set logscale y 2'
            },
            :insertions => {
                :re2 => "#{@env}re2_insertions_",
                :ruby => "#{@env}ruby_insertions_",
                :scan => "#{@env}scan_for_matches_insertions_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Insertions',
                :log => 'set logscale y 2'
            },
            :mismatches_deletions => {
                :re2 => "#{@env}re2_mismatch_deletion_",
                :ruby => "#{@env}ruby_mismatch_deletion_",
                :scan => "#{@env}scan_for_matches_mismatch_deletion_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Mismatches & Deletions',
                :log => 'set logscale y 2'
            },
            :mismatches_insertions => {
                :re2 => "#{@env}re2_mismatch_insertion_",
                :ruby => "#{@env}ruby_mismatch_insertion_",
                :scan => "#{@env}scan_for_matches_mismatch_insertion_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Mismatches & Insertions',
                :log => 'set logscale y 2'
            },
            :deletions_insertions => {
                :re2 => "#{@env}re2_deletion_insertion_",
                :ruby => "#{@env}ruby_deletion_insertion_",
                :scan => "#{@env}scan_for_matches_deletion_insertion_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Deletions & Insertions',
                :log => 'set logscale y 2'
            },
            :combinations => {
                :re2 => "#{@env}re2_combinations_",
                :ruby => "#{@env}ruby_combinations_",
                :scan => "#{@env}scan_for_matches_combinations_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Combinations',
                :log => 'set logscale y 2'
            },
            :ranges => {
                :re2 => "#{@env}re2_range.data",
                :ruby => "#{@env}ruby_range.data",
                :scan => "#{@env}scan_for_matches_range.data",
                :xlabel => 'Size of range',
                :ylabel => 'Match time [ms]',
                :title => 'Ranges',
                :log => 'set logscale y 2'
            },
            :sequences => {
                :re2 => "#{@env}re2_sequences.data",
                :ruby => "#{@env}ruby_sequences.data",
                :scan => "#{@env}scan_for_matches_sequences.data",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms]',
                :title => 'Sequences',
                :log => 'set logscale y 2'
            },
            :differences => {
                :re2 => "#{@env}re2_differences.data",
                :ruby => "#{@env}ruby_differences.data",
                :xlabel => 'Files',
                :ylabel => 'Difference in match count',
                :title => 'Differences',
                :log => ''
            }
        }
    end

    def gnuplot(commands)
        IO.popen('gnuplot', 'w') { |io| io.puts commands }
    end

    def visualize_four(mode)
        commands = "
            set terminal pngcairo size 800,600

            # file name
            set output '../../tex/rapport/graphs/#{mode}.png'

            #{@mode[mode][:log]}

            # data
            set style line 1 lc rgb '#6060FF' lt 1 lw 2 pt 4 ps 0.7   # --- blue
            set style line 2 lc rgb '#FF6060' lt 1 lw 2 pt 12 ps 0.7   # --- red
            set style line 3 lc rgb '#60FF60' lt 1 lw 2 pt 6 ps 0.7   # --- green

            set tmargin 4
            set key at screen 0.6,1

            # Start multiplot (2x2 layout)
            set multiplot layout 2,2 rowsfirst

            # title
            set title '1 #{@mode[mode][:title]}'

            # y axis label
            set ylabel '#{@mode[mode][:ylabel]}'

            plot '#{@mode[mode][:re2]}1.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}1.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}1.data' with linespoints ls 3 title 'SFM'

            # title
            set title '2 #{@mode[mode][:title]}'
            unset ylabel
            unset key

            plot '#{@mode[mode][:re2]}2.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}2.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}2.data' with linespoints ls 3 title 'SFM'

            # title
            set title '3 #{@mode[mode][:title]}'

            # x axis label
            set xlabel '#{@mode[mode][:xlabel]}'
            set ylabel '#{@mode[mode][:ylabel]}'

            plot '#{@mode[mode][:re2]}3.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}3.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}3.data' with linespoints ls 3 title 'SFM'

            # title
            set title '4 #{@mode[mode][:title]}'
            unset ylabel

            plot '#{@mode[mode][:re2]}4.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}4.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}4.data' with linespoints ls 3 title 'SFM'
            unset multiplot
        "

        gnuplot(commands)
    end

    def visualize_two(mode)
        commands = "
            set terminal pngcairo size 800,300

            # file name
            set output '../../tex/rapport/graphs/#{mode}.png'

            #{@mode[mode][:log]}

            # data
            set style line 1 lc rgb '#6060FF' lt 1 lw 2 pt 4 ps 0.7   # --- blue
            set style line 2 lc rgb '#FF6060' lt 1 lw 2 pt 12 ps 0.7   # --- red
            set style line 3 lc rgb '#60FF60' lt 1 lw 2 pt 6 ps 0.7   # --- green

            set tmargin 4
            set key at screen 0.6,1

            # Start multiplot (2x2 layout)
            set multiplot layout 1,2 rowsfirst

            # title
            set title '1 #{@mode[mode][:title]}'

            # axes label
            set ylabel '#{@mode[mode][:ylabel]}'
            set xlabel '#{@mode[mode][:xlabel]}'

            plot '#{@mode[mode][:re2]}1.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}1.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}1.data' with linespoints ls 3 title 'SFM'

            # title
            set title '2 #{@mode[mode][:title]}'
            unset ylabel
            unset key

            plot '#{@mode[mode][:re2]}2.data' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}2.data' with linespoints ls 2 title 'Ruby', \
                 '#{@mode[mode][:scan]}2.data' with linespoints ls 3 title 'SFM'
            unset multiplot
        "

        gnuplot(commands)
    end

    def visualize_one(mode)
        commands = "
            set terminal pngcairo size 800,600

            # file name
            set output '../../tex/rapport/graphs/#{mode}.png'

            #{@mode[mode][:log]}

            # data
            set style line 1 lc rgb '#6060FF' lt 1 lw 2 pt 4 ps 0.7   # --- blue
            set style line 2 lc rgb '#FF6060' lt 1 lw 2 pt 12 ps 0.7   # --- red
            set style line 3 lc rgb '#60FF60' lt 1 lw 2 pt 6 ps 0.7   # --- green

            set tmargin 4
            set key at screen 1,0.975

            # title
            set title '#{@mode[mode][:title]}'

            # axes label
            set ylabel '#{@mode[mode][:ylabel]}'
            set xlabel '#{@mode[mode][:xlabel]}'

            plot '#{@mode[mode][:re2]}' with linespoints ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}' with linespoints ls 2 title 'Ruby'
        "

        gnuplot(commands)
    end
end