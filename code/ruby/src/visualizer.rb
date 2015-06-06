class Visualizer

    def initialize

        @env = '../benchmark/parsed_results/'
        
        @mode = {
            :mismatches => {
                :re2 => "#{@env}re2_mismatches_",
                :ruby => "#{@env}ruby_mismatches_",
                :python => "#{@env}python_mismatches_",
                :python_regex => "#{@env}python_regex_mismatches_",
                :scan => "#{@env}scan_for_matches_mismatches_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Mismatches',
                :log => 'set logscale y 10'
            },
            :deletions => {
                :re2 => "#{@env}re2_deletions_",
                :ruby => "#{@env}ruby_deletions_",
                :python => "#{@env}python_deletions_",
                :python_regex => "#{@env}python_regex_deletions_",
                :scan => "#{@env}scan_for_matches_deletions_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Deletions',
                :log => 'set logscale y 10'
            },
            :insertions => {
                :re2 => "#{@env}re2_insertions_",
                :ruby => "#{@env}ruby_insertions_",
                :python => "#{@env}python_insertions_",
                :python_regex => "#{@env}python_regex_insertions_",
                :scan => "#{@env}scan_for_matches_insertions_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Insertions',
                :log => 'set logscale y 10'
            },
            :mismatches_deletions => {
                :re2 => "#{@env}re2_mismatch_deletion_",
                :ruby => "#{@env}ruby_mismatch_deletion_",
                :python => "#{@env}python_mismatch_deletion_",
                :python_regex => "#{@env}python_regex_mismatch_deletion_",
                :scan => "#{@env}scan_for_matches_mismatch_deletion_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Mismatches & Deletions',
                :log => 'set logscale y 10'
            },
            :mismatches_insertions => {
                :re2 => "#{@env}re2_mismatch_insertion_",
                :ruby => "#{@env}ruby_mismatch_insertion_",
                :python => "#{@env}python_mismatch_insertion_",
                :python_regex => "#{@env}python_regex_mismatch_insertion_",
                :scan => "#{@env}scan_for_matches_mismatch_insertion_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Mismatches & Insertions',
                :log => 'set logscale y 10'
            },
            :deletions_insertions => {
                :re2 => "#{@env}re2_deletion_insertion_",
                :ruby => "#{@env}ruby_deletion_insertion_",
                :python => "#{@env}python_deletion_insertion_",
                :python_regex => "#{@env}python_regex_deletion_insertion_",
                :scan => "#{@env}scan_for_matches_deletion_insertion_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Deletions & Insertions',
                :log => 'set logscale y 10'
            },
            :combinations => {
                :re2 => "#{@env}re2_combinations_",
                :ruby => "#{@env}ruby_combinations_",
                :python => "#{@env}python_combinations_",
                :python_regex => "#{@env}python_regex_combinations_",
                :scan => "#{@env}scan_for_matches_combinations_",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Combinations',
                :log => 'set logscale y 10'
            },
            :ranges => {
                :re2 => "#{@env}re2_range.data",
                :ruby => "#{@env}ruby_range.data",
                :python => "#{@env}python_range.data",
                :python_regex => "#{@env}python_regex_range.data",
                :scan => "#{@env}scan_for_matches_range.data",
                :xlabel => 'Size of range',
                :ylabel => 'Match time [ms] log10',
                :title => 'Ranges',
                :log => 'set logscale y 10'
            },
            :sequences => {
                :re2 => "#{@env}re2_sequences.data",
                :ruby => "#{@env}ruby_sequences.data",
                :python => "#{@env}python_sequences.data",
                :python_regex => "#{@env}python_regex_sequences.data",
                :scan => "#{@env}scan_for_matches_sequences.data",
                :xlabel => 'Sequence length',
                :ylabel => 'Match time [ms] log10',
                :title => 'Sequences',
                :log => 'set logscale y 10'
            },
            :match_count => {
                :re2 => "#{@env}re2_match_count.data",
                :ruby => "#{@env}ruby_match_count.data",
                :python => "#{@env}python_match_count.data",
                :python_regex => "#{@env}python_regex_match_count.data",
                :scan => "#{@env}scan_match_count.data",
                :xlabel => 'Files',
                :ylabel => 'Match count log10',
                :title => 'Match count',
                :log => 'set logscale y 10'
            },
            :match_count_speed => {
                :re2 => "#{@env}re2_match_count_speed.data",
                :ruby => "#{@env}ruby_match_count_speed.data",
                :python => "#{@env}python_match_count_speed.data",
                :python_regex => "#{@env}python_regex_match_count_speed.data",
                :scan => "#{@env}scan_match_count_speed.data",
                :xlabel => 'Match Count log10',
                :ylabel => 'Match Time',
                :title => 'Match Time / Match Count',
                :log => 'set logscale x 10'
            }
        }
    end

    def gnuplot(commands)
        IO.popen('gnuplot', 'w') { |io| io.puts commands }
    end

    def visualize_histogram(mode)

        commands = "
            set terminal pngcairo size 800,600
            set output '../../tex/rapport/graphs/#{mode}.png'

            #{@mode[mode][:log]}

            set datafile missing '-'

            set boxwidth 0.75 absolute
            set style fill solid 0.5 border 0
            set style data histograms

            total_box_width_relative=0.75
            gap_width_relative=0.5

            set boxwidth total_box_width_relative/1.5 relative

            plot '#{@mode[mode][:re2]}1.data' using 2:xtic(1) fs pattern 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}1.data' using 2:xtic(1) fs pattern 2 title 'Ruby', \
                 '#{@mode[mode][:python]}1.data' using 2:xtic(1) fs pattern 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}1.data' using 2:xtic(1) fs pattern 4 title 'PR', \
                 '#{@mode[mode][:scan]}1.data' using 2:xtic(1) fs pattern 5 title 'SFM'
        "

        gnuplot(commands)
    end

    def visualize_four(mode)
        commands = "
            set terminal pngcairo size 800,600

            # file name
            set output '../../tex/rapport/graphs/#{mode}.png'

            #{@mode[mode][:log]}

            # data
            set style line 1 lc rgb '#6060FF' lt 1 lw 2 pt 4 ps 0.8   # --- blue
            set style line 2 lc rgb '#FF6060' lt 1 lw 2 pt 12 ps 0.8   # --- red
            set style line 3 lc rgb '#000000' lt 1 lw 2 pt 2 ps 0.8   # --- black
            set style line 4 lc rgb '#FF60FF' lt 1 lw 2 pt 14 ps 0.8   # --- Purple
            set style line 5 lc rgb '#60FF60' lt 1 lw 2 pt 6 ps 0.8   # --- green

            set tmargin 6
            set key at screen 0.6,1

            # Start multiplot (2x2 layout)
            set multiplot layout 2,2 rowsfirst

            # title
            set title '1 #{@mode[mode][:title]}'

            # y axis label
            set ylabel '#{@mode[mode][:ylabel]}'

            plot '#{@mode[mode][:re2]}1.data' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}1.data' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}1.data' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}1.data' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}1.data' with points ls 5 title 'SFM'

            # title
            set title '2 #{@mode[mode][:title]}'
            unset ylabel
            unset key

            plot '#{@mode[mode][:re2]}2.data' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}2.data' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}2.data' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}2.data' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}2.data' with points ls 5 title 'SFM'

            # title
            set title '3 #{@mode[mode][:title]}'

            # x axis label
            set xlabel '#{@mode[mode][:xlabel]}'
            set ylabel '#{@mode[mode][:ylabel]}'

            plot '#{@mode[mode][:re2]}3.data' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}3.data' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}3.data' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}3.data' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}3.data' with points ls 5 title 'SFM'

            # title
            set title '4 #{@mode[mode][:title]}'
            unset ylabel

            plot '#{@mode[mode][:re2]}4.data' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}4.data' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}4.data' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}4.data' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}4.data' with points ls 5 title 'SFM'
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
            set style line 1 lc rgb '#6060FF' lt 1 lw 2 pt 4 ps 0.8   # --- blue
            set style line 2 lc rgb '#FF6060' lt 1 lw 2 pt 12 ps 0.8   # --- red
            set style line 3 lc rgb '#000000' lt 1 lw 2 pt 2 ps 0.8   # --- black
            set style line 4 lc rgb '#FF60FF' lt 1 lw 2 pt 14 ps 0.8   # --- Purple
            set style line 5 lc rgb '#60FF60' lt 1 lw 2 pt 6 ps 0.8   # --- green

            set tmargin 6
            set key at screen 0.6,1

            # Start multiplot (2x2 layout)
            set multiplot layout 1,2 rowsfirst

            # title
            set title '1 #{@mode[mode][:title]}'

            # axes label
            set ylabel '#{@mode[mode][:ylabel]}'
            set xlabel '#{@mode[mode][:xlabel]}'

            plot '#{@mode[mode][:re2]}1.data' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}1.data' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}1.data' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}1.data' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}1.data' with points ls 5 title 'SFM'

            # title
            set title '2 #{@mode[mode][:title]}'
            unset ylabel
            unset key

            plot '#{@mode[mode][:re2]}2.data' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}2.data' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}2.data' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}2.data' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}2.data' with points ls 5 title 'SFM'
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
            set style line 1 lc rgb '#6060FF' lt 1 lw 2 pt 4 ps 0.8   # --- blue
            set style line 2 lc rgb '#FF6060' lt 1 lw 2 pt 12 ps 0.8   # --- red
            set style line 3 lc rgb '#000000' lt 1 lw 2 pt 2 ps 0.8   # --- black
            set style line 4 lc rgb '#FF60FF' lt 1 lw 2 pt 14 ps 0.8   # --- Purple
            set style line 5 lc rgb '#60FF60' lt 1 lw 2 pt 6 ps 0.8   # --- green

            set tmargin 6
            set key at screen 1,0.975

            # title
            set title '#{@mode[mode][:title]}'

            # axes label
            set ylabel '#{@mode[mode][:ylabel]}'
            set xlabel '#{@mode[mode][:xlabel]}'

            plot '#{@mode[mode][:re2]}' with points ls 1 title 'RE2', \
                 '#{@mode[mode][:ruby]}' with points ls 2 title 'Ruby', \
                 '#{@mode[mode][:python]}' with points ls 3 title 'Python', \
                 '#{@mode[mode][:python_regex]}' with points ls 4 title 'PR', \
                 '#{@mode[mode][:scan]}' with points ls 5 title 'SFM'
        "

        gnuplot(commands)
    end
end