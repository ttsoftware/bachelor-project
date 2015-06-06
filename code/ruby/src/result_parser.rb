require 'json'

class ResultParser

    def initialize
        @environment = '../benchmark/results'
        @abs_env = "#{File.dirname(__FILE__)}/../../benchmark/parsed_results"

        @ruby_files = Dir["#{@environment}/ruby/*.txt"].sort!
        @re2_files = Dir["#{@environment}/re2/*.txt"].sort!
        @python_files = Dir["#{@environment}/python/*.txt"].sort!
        @python_regex_files = Dir["#{@environment}/python_regex/*.txt"].sort!
        @scan_for_matches_files = Dir["#{@environment}/scan_for_matches/*.txt"].sort!
        @kmc_files = Dir["#{@environment}/kmc/*.txt"].sort!

    end

    def parse(files)

        results = {}

        files.each { |file|

            content = ''
            File.open(file, 'r') { |f| content = f.readlines.join '' }

            patscan_match = /^PATSCAN: (?<patscan>.+?)\n/.match content

            re_length_match = /LENGTH OF RE: (?<re_length>[\d\.]+)\n/.match content
            re_cases_match = /CLAUSES IN RE: (?<re_cases>[\d\.]+)\n/.match content
            memory_time_match = /DISK TIME: (?<memory_time>[\d\.]+)\n/.match content
            match_time_match = /MATCH TIME: (?<match_time>[\d\.]+)\n/.match content
            total_time_match = /TOTAL TIME: (?<total_time>[\d\.]+)\n/.match content
            match_count_match = /NUMBER OF MATCHES: (?<match_count>[\d\.]+)\n/.match content

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

            results[file.sub /^(?<path>.+)\/(?<name>[^\/]+\.txt)$/, '\k<name>'] = {
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
            elsif r[:patscan_deletions] == 0 and r[:patscan_mismatches] != 0 and r[:patscan_insertions] != 0
                mismatch_insertion_data << r
            elsif r[:patscan_deletions] != 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] != 0
                deletion_insertion_data << r
            elsif r[:patscan_deletions] != 0 and r[:patscan_mismatches] != 0 and r[:patscan_insertions] != 0
                combinations_data << r
            elsif r[:range]
                # ranges
                range_data << r
            elsif r[:patscan_deletions] == 0 and r[:patscan_mismatches] == 0 and r[:patscan_insertions] == 0
                # sequences
                sequences_data << r
            end
        }

        mismatches_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_mismatches_#{i + 1}.data", 'w') { |f|
                mismatches_data.each { |r|
                    if r[:patscan_mismatches] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        deletions_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_deletions_#{i + 1}.data", 'w') { |f|
                deletions_data.each { |r|
                    if r[:patscan_deletions] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        insertions_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_insertions_#{i + 1}.data", 'w') { |f|
                insertions_data.each { |r|
                    if r[:patscan_insertions] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        mismatch_deletion_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_mismatch_deletion_#{i + 1}.data", 'w') { |f|
                mismatch_deletion_data.each { |r|
                    if r[:patscan_mismatches] == i + 1 and r[:patscan_deletions] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        mismatch_insertion_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_mismatch_insertion_#{i + 1}.data", 'w') { |f|
                mismatch_insertion_data.each { |r|
                    if r[:patscan_mismatches] == i + 1 and r[:patscan_insertions] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        deletion_insertion_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_deletion_insertion_#{i + 1}.data", 'w') { |f|
                deletion_insertion_data.each { |r|
                    if r[:patscan_deletions] == i + 1 and r[:patscan_insertions] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        combinations_data.sort_by! { |r| r[:patscan_sequence].length }
        4.times { |i|
            File.open("#{@abs_env}/#{runtime}_combinations_#{i + 1}.data", 'w') { |f|
                combinations_data.each { |r|
                    if r[:patscan_mismatches] == i + 1 and r[:patscan_deletions] == i + 1 and r[:patscan_insertions] == i + 1
                        f.puts "#{r[:patscan_sequence].length} #{r[:match_time]}"
                    end
                }
            }
        }

        File.open("#{@abs_env}/#{runtime}_range.data", 'w') { |f|
            range_data.sort_by! { |r| r[:range]['end'].to_i - r[:range]['start'].to_i }
            range_data.each_with_index { |r, i| f.puts "#{r[:range]['end'].to_i - r[:range]['start'].to_i} #{r[:match_time]}" }
        }

        File.open("#{@abs_env}/#{runtime}_sequences.data", 'w') { |f|
            sequences_data.sort_by! { |r| r[:re_length] }
            sequences_data.each_with_index { |r, i| f.puts "#{r[:re_length]} #{r[:match_time]}" }
        }
    end

    def write_match_count(re2_results, ruby_results, python_results, python_regex_results, scan_results)
        re2 = []
        ruby = []
        python = []
        python_regex = []
        scan = []

        scan_results.sort_by { |k, v| v[:match_count] }.each { |key, value|

            re2 << re2_results[key][:match_count] unless re2_results[key][:match_count] == 0
            ruby << ruby_results[key][:match_count] unless ruby_results[key][:match_count] == 0
            python << python_results[key][:match_count] unless python_results[key][:match_count] == 0
            python_regex << python_regex_results[key][:match_count] unless python_regex_results[key][:match_count] == 0
            scan << scan_results[key][:match_count] unless scan_results[key][:match_count] == 0
        }

        File.open("#{@abs_env}/re2_match_count.data", 'w') { |f| re2.each_with_index { |value, i| f.puts "#{i} #{value}"} }
        File.open("#{@abs_env}/ruby_match_count.data", 'w') { |f| ruby.each_with_index { |value, i| f.puts "#{i} #{value}"} }
        File.open("#{@abs_env}/python_match_count.data", 'w') { |f| python.each_with_index { |value, i| f.puts "#{i} #{value}"} }
        File.open("#{@abs_env}/python_regex_match_count.data", 'w') { |f| python_regex.each_with_index { |value, i| f.puts "#{i} #{value}"} }
        File.open("#{@abs_env}/scan_match_count.data", 'w') { |f| scan.each_with_index { |value, i| f.puts "#{i} #{value}"} }
    end

    def write_match_count_speed(re2_results, ruby_results, python_results, python_regex_results, scan_results)
        re2 = []
        ruby = []
        python = []
        python_regex = []
        scan = []

        scan_results.keys.each { |key|
            re2 << re2_results[key] unless re2_results[key][:match_count] == 0
            ruby << ruby_results[key] unless ruby_results[key][:match_count] == 0
            python << python_results[key] unless python_results[key][:match_count] == 0
            python_regex << python_regex_results[key] unless python_regex_results[key][:match_count] == 0
            scan << scan_results[key] unless scan_results[key][:match_count] == 0
        }

        File.open("#{@abs_env}/re2_match_count_speed.data", 'w') { |f| re2.each_with_index { |value, i|
            f.puts "#{value[:match_count]} #{value[:match_time]}"}
        }
        File.open("#{@abs_env}/ruby_match_count_speed.data", 'w') { |f| ruby.each_with_index { |value, i|
            f.puts "#{value[:match_count]} #{value[:match_time]}"}
        }
        File.open("#{@abs_env}/python_match_count_speed.data", 'w') { |f| python.each_with_index { |value, i|
            f.puts "#{value[:match_count]} #{value[:match_time]}"}
        }
        File.open("#{@abs_env}/python_regex_match_count_speed.data", 'w') { |f| python_regex.each_with_index { |value, i|
            f.puts "#{value[:match_count]} #{value[:match_time]}"}
        }
        File.open("#{@abs_env}/scan_match_count_speed.data", 'w') { |f| scan.each_with_index { |value, i|
            f.puts "#{value[:match_count]} #{value[:match_time]}"}
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

    def python_regex_results
        results = parse @python_regex_files
        write_data_file results, 'python_regex'
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

    def match_count
        re2_results = parse @re2_files
        python_results = parse @python_files
        python_regex_results = parse @python_regex_files
        ruby_results = parse @ruby_files
        scan_results = parse @scan_for_matches_files

        write_match_count re2_results, ruby_results, python_results, python_regex_results, scan_results
        write_match_count_speed re2_results, ruby_results, python_results, python_regex_results, scan_results
    end
end