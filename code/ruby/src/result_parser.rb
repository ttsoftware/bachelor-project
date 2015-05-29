require 'json'

class ResultParser

    def initialize
        @environment = '../benchmark/results'
        @abs_env = "#{File.dirname(__FILE__)}/../../benchmark/parsed_results"

        @ruby_files = Dir["#{@environment}/ruby/*.txt"].sort!
        @re2_files = Dir["#{@environment}/re2/*.txt"].sort!
        @python_files = Dir["#{@environment}/python/*.txt"].sort!
        @scan_for_matches_files = Dir["#{@environment}/scan_for_matches/*.txt"].sort!
        @kmc_files = Dir["#{@environment}/kmc/*.txt"].sort!

    end

    def parse(files)

        results = {}

        files.each { |file|

            content = ''
            File.open(file, 'r') { |f| content = f.readlines.join '' }

            patscan_match = /^PATSCAN: (?<patscan>.+?)\n/.match content

            re_length_match = /LENGTH OF RE: (?<re_length>[\d\.]+\n)/.match content
            re_cases_match = /CLAUSES IN RE: (?<re_cases>[\d\.]+\n)/.match content
            memory_time_match = /DISK TIME: (?<memory_time>[\d\.]+\n)/.match content
            match_time_match = /MATCH TIME: (?<match_time>[\d\.]+\n)/.match content
            total_time_match = /TOTAL TIME: (?<total_time>[\d\.]+\n)/.match content
            match_count_match = /NUMBER OF MATCHES: (?<match_count>[\d\.]+\n)/.match content

            matches = nil
            #matches = /MATCHES:\n(?<matches>[^#_&~]+)?/.match content

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

            range = /(?<sequence>\w+\s)(?<start>\d+)\.{3}(?<end>\d+)/.match(patscan_match['patscan'])

            results[file] = {
                :patscan_pattern => patscan_match['patscan'],
                :patscan_sequence => patscan_match['patscan'].split(/\[/)[0],
                :patscan_mismatches => combinations['mismatches'].to_i,
                :patscan_insertions => combinations['insertions'].to_i,
                :patscan_deletions => combinations['deletions'].to_i,
                :re_length => re_length.to_i,
                :re_clauses => re_cases.to_i,
                :memory_time => memory_time.to_f,
                :matches => matches_list,
                :match_time => match_time.to_f,
                :total_time => total_time.to_f,
                :match_count => match_count.to_i,
                :range => range
            }
        }

        return results
    end

    def write_data_file(results, runtime)

        mismatches_data = []
        insertions_data = []
        deletions_data = []

        mismatch_deletion_data = []
        mismatch_insertion_data = []
        deletion_insertion_data = []

        combinations_data = []
        range_data = []
        sequences_data = []

        results.values.each { |r|
            if r[:match_time] == 0
                next
            elsif r[:patscan_deletions] != 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] == 0
                deletions_data << r
            elsif r[:patscan_deletions] == 0 and r[:patscan_mismatches] != 0 and r[:patscan_insertions] == 0
                mismatches_data << r
            elsif r[:patscan_deletions] == 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] != 0
                insertions_data << r
            elsif r[:patscan_deletions] != 0 and r[:patscan_mismatches] != 0 and r[:patscan_insertions] == 0
                mismatch_deletion_data << r
            elsif r[:patscan_deletions] != 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] != 0
                mismatch_insertion_data << r
            elsif r[:patscan_deletions] == 0 and r[:patscan_mismatches] != 0 and r[:patscan_insertions] != 0
                deletion_insertion_data << r
            elsif (r[:patscan_deletions] != 0 and r[:patscan_mismatches] != 0) and r[:patscan_insertions]
                # combinations
                combinations_data << r
            elsif r[:range]
                # ranges
                range_data << r
            elsif r[:patscan_deletions] == 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] == 0
                # sequences
                sequences_data << r
            end
        }

        File.open("#{@abs_env}/#{runtime}_mismatches.data", 'w') { |f|
            mismatches_data.sort_by! { |r| r[:re_clauses] }
            mismatches_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_deletions.data", 'w') { |f|
            deletions_data.sort_by! { |r| r[:re_clauses] }
            deletions_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_insertions.data", 'w') { |f|
            insertions_data.sort_by! { |r| r[:re_clauses] }
            insertions_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_mismatch_deletion.data", 'w') { |f|
            mismatch_deletion_data.sort_by! { |r| r[:re_clauses] }
            mismatch_deletion_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_mismatch_insertion.data", 'w') { |f|
            mismatch_insertion_data.sort_by! { |r| r[:re_clauses] }
            mismatch_insertion_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_deletion_insertion.data", 'w') { |f|
            deletion_insertion_data.sort_by! { |r| r[:re_clauses] }
            deletion_insertion_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_combinations.data", 'w') { |f|
            combinations_data.sort_by! { |r| r[:re_clauses] }
            combinations_data.each_with_index { |r, i| f.puts "#{r[:re_clauses]} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_range.data", 'w') { |f|
            range_data.sort_by! { |r| r[:range]['end'].to_i - r[:range]['start'].to_i }
            range_data.each_with_index { |r, i| f.puts "#{i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_sequences.data", 'w') { |f|
            sequences_data.sort_by! { |r| r[:re_length] }
            sequences_data.each_with_index { |r, i| f.puts "#{r[:re_length]} #{r[:match_time]}" }
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