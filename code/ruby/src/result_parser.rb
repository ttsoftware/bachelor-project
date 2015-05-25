require 'json'

class ResultParser

    def initialize
        @enviroment = '../*/benchmark/results'
        @abs_env = "#{File.dirname(__FILE__)}/../../patscan-patterns/benchmark/results/result_data/"

        @ruby_files = Dir["#{@enviroment}/ruby/*.txt"].sort!
        @re2_files = Dir["#{@enviroment}/re2/*.txt"].sort!
        @python_files = Dir["#{@enviroment}/python/*.txt"].sort!
        @scan_for_matches_files = Dir["#{@enviroment}/scan_for_matches/*.txt"].sort!
        @kmc_files = Dir["#{@enviroment}/kmc/*.txt"].sort!

    end

    def parse(files)

        results = {}

        files.each { |file|

            content = ''
            File.open(file, 'r') { |f| content = f.readlines.join '' }

            patscan_match = /^(Trying )?(?<patscan>.+?)(\.)?\n/.match content

            re_length_match = /%[^\d]*(?<re_length>[\d\.]+)/.match content
            re_cases_match = /£[^\d]*(?<re_cases>[\d\.]+)/.match content
            memory_time_match = /~[^\d]*(?<memory_time>[\d\.]+)/.match content
            match_time_match = /[^_]*_[^\d]*(?<match_time>[\d\.]+)/.match content
            total_time_match = /[^#]*#[^\d]*(?<total_time>[\d\.]+)/.match content
            match_count_match = /[^&]*&[^\d]*(?<match_count>[\d\.]+)/.match content

            matches = nil
            #matches = /(?m)[^\d]*-\n(?<matches>[^#_&~]+)?/.match content

            re_length = 0
            unless re_length_match.nil?
                re_length = re_length_match['re_length']
            end

            re_cases = 0
            unless re_cases_match.nil?
                re_cases = re_cases_match['re_cases']
            end

            memory_time = 0
            unless memory_time_match.nil?
                memory_time = memory_time_match['memory_time']
            end

            match_time = 0
            unless match_time_match.nil?
                match_time = match_time_match['match_time']
            end

            total_time = 0
            unless total_time_match.nil?
                total_time = total_time_match['total_time']
            end

            match_count = 0
            unless match_count_match.nil?
                match_count = match_count_match['match_count']
            end

            matches_list = []
            unless matches.nil? or matches['matches'].nil?
                matches_list = matches['matches'].split(/\n\s?/).map { |m| m.split /(?: - )/ }
            end

            combinations = /\[(?<mismatches>\d),(?<deletions>\d),(?<insertions>\d)\]/.match patscan_match['patscan']
            combinations = {'mismatches' => 0, 'deletions' => 0, 'insertions' => 0} if combinations.nil?

            if /\.{3}/.match(patscan_match['patscan']).nil?
                is_range = false
            else
                is_range = true
            end

            results[file] = {
                :patscan_pattern => patscan_match['patscan'],
                :patscan_sequence => patscan_match['patscan'].split(/\[/)[0],
                :patscan_mismatches => combinations['mismatches'].to_i,
                :patscan_insertions => combinations['insertions'].to_i,
                :patscan_deletions => combinations['deletions'].to_i,
                :re_length => re_length.to_i,
                :re_cases => re_cases.to_i,
                :memory_time => memory_time.to_f,
                :matches => matches_list,
                :match_time => match_time.to_f,
                :total_time => total_time.to_f,
                :match_count => match_count.to_i,
                :is_range => is_range
            }
        }

        return results
    end

    def write_data_file(results, runtime)

        mismatches_data = []
        insertions_data = []
        deletions_data = []

        combinations_data = []
        range_data = []
        sequences_data = []

        results.values.each { |r|
            if r[:patscan_deletions] != 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] == 0
                deletions_data << r
            end

            if r[:patscan_deletions] == 0 and r[:patscan_mismatches] != 0 and r[:patscan_insertions] == 0
                mismatches_data << r
            end

            if r[:patscan_deletions] == 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] != 0
                insertions_data << r
            end

            # combinations
            if (r[:patscan_deletions] != 0 and r[:patscan_mismatches] != 0) \
                or (r[:patscan_deletions] != 0 and r[:patscan_insertions] != 0) \
                or (r[:mismatches_data] != 0 and r[:patscan_insertions] != 0)

                combinations_data << r
            end

            # ranges
            range_data << r if r[:is_range]

            # sequences
            if r[:patscan_deletions] == 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] == 0
                sequences_data << r
            end
        }

        File.open("#{@abs_env}/#{runtime}_mismatches.data", 'w') { |f|
            mismatches_data.sort_by! { |r| r[:re_length] }
            mismatches_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_deletions.data", 'w') { |f|
            deletions_data.sort_by! { |r| r[:re_length] }
            deletions_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_insertions.data", 'w') { |f|
            insertions_data.sort_by! { |r| r[:re_length] }
            insertions_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_combinations.data", 'w') { |f|
            combinations_data.sort_by! { |r| r[:re_length] }
            combinations_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_range.data", 'w') { |f|
            range_data.sort_by! { |r| r[:re_length] }
            range_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_sequences.data", 'w') { |f|
            sequences_data.sort_by! { |r| r[:re_length] }
            sequences_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }
    end

    def ruby_results

        results = parse @ruby_files
        write_data_file results, 'ruby'
    end

    def python_results

        results = parse @python_files
        write_data_file results, 'python'
    end

    def re2_results

        results = parse @re2_files
        write_data_file results, 're2'
    end

    def scan_for_matches_results
        results = parse @scan_for_matches_files
        write_data_file results, 'scan_for_matches'
    end

    def kmc_results
        results = parse @kmc_files
        write_data_file results, 'kmc'
    end
end