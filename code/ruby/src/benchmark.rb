class Benchmark

    # @param [Integer] runtime Seconds for each thread to run
    def initialize(compiletime, runtime)

        @runningtime = runtime
        @compiletime = compiletime

        @abs_env = "#{File.dirname(__FILE__)}/../../benchmark"

        # find all patscan files in the enviroment
        @patscan_files = Dir["#{@abs_env}/*.pat"].sort!

        # find all fasta files in the enviroment
        @fasta_files = Dir["#{@abs_env}/../genome/*.fa"].sort!
    end

    def start_threads(runtime, engine, is_scan_for_matches=false)

        # run all tests in pairs of 5 at a time
        @patscan_files.each_slice(4) { |slice|

            threads = []

            slice.each { |file|

                threads << Thread.new {

                    patscan_pattern = File.read(file).rstrip

                    # we must first generate the regex pattern.
                    # define the .re file location
                    re_file = file.sub /^(?<path>.+)\/(?<name>[^\/]+)\.pat$/, '\k<path>/\k<name>.re'

                    puts "Trying #{file}."
                    puts re_file

                    re_pattern = Translater.new(patscan_pattern).translate
                    re_pattern_length = re_pattern.length
                    re_pattern_clauses = re_pattern.split(/\|/).size

                    File.open(re_file, 'w') { |f| f.puts re_pattern }

                    # define output file for current input file
                    result_file = re_file.sub /^(?<path>.+)\/(?<name>[^\/]+)\.(pat|re)$/, '\k<name>-result.txt'
                    result_file = "#{@abs_env}/results/#{engine}/#{result_file}"

                    File.open(result_file, 'w') { |f|
                        f.puts "PATSCAN: #{patscan_pattern}"
                        f.puts "LENGTH OF RE: #{re_pattern_length}"
                        f.puts "CLAUSES IN RE: #{re_pattern_clauses}"
                    }

                    unless File.exist? re_file
                        puts "ERROR: No such file #{re_file} - compile failed or did not finish."
                        Thread.current.exit
                    end

                    if is_scan_for_matches
                        pid = spawn(
                            "python #{runtime} #{file} #{@fasta_files[0]}",
                            [:out] => [result_file, 'a']
                        )

                        puts "Started #{file} with command '#{runtime} #{file} #{@fasta_files[0]}'"

                        Process.waitpid pid
                    else
                        pid = spawn(
                            "#{runtime} #{re_file} #{@fasta_files[0]}",
                            [:out] => [result_file, 'a']
                        )

                        puts "Started #{file} with command '#{runtime} #{re_file} #{@fasta_files[0]}'"
                    end

                    Process.detach pid # do not collect termination information

                    # only run this thread for @runningtime seconds.
                    sleep @runningtime unless is_scan_for_matches

                    begin
                        Process.kill 'SIGKILL', pid unless is_scan_for_matches # sigkill
                    rescue Errno::ESRCH => e
                        # no such process it already finished, which is nice.
                    end

                    begin
                        File.delete re_file
                    rescue Errno::ENOENT => e
                        # file does not exist.
                    end
                }
            }

            # join all 4 threads before continuing
            threads.each { |t| t.join }
        }
    end

    def ruby
        start_threads("#{File.dirname(__FILE__)}/re-scan.rb", 'ruby')
    end

    def python
        start_threads('../python/main.py', 'python')
    end

    def python_regex
        start_threads('../python_regex/main.py', 'python_regex')
    end

    def re2
        start_threads('../c++/main', 're2')
    end

    def kmc

    end

    def scan_for_matches
        start_threads('../scan_for_matches/main.py', 'scan_for_matches', true)
    end

    def generate_patterns
        alphabet = %w[A T C G]

        number_of_error = 4
        length_of_pattern = 12

        # Sequences
        (length_of_pattern * 4).times { |l|
            pattern = (4 + l).times.map{alphabet[rand(4)]}.join ''
            File.open("#{@abs_env}/sequences_#{l + 1}.pat", 'w') { |f|
                f.write pattern
            }
        }

        # ranges
        sequence = 8.times.map{alphabet[rand(4)]}.join ''
        (length_of_pattern * 4).times { |r|
            pattern = "#{sequence} #{2 + (2*r)}...#{4 + (4*r)} #{sequence}"
            File.open("#{@abs_env}/ranges_#{r + 1}.pat", 'w') { |f|
                f.write pattern
            }
        }

        # mismatches
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            number_of_error.times { |m|
                File.open("#{@abs_env}/mismatches_#{l + 1}_#{m + 1}.pat", 'w') { |f|
                    f.write pattern + "[#{m + 1},0,0]"
                }
            }
        }

        # deletions
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            number_of_error.times { |d|
                File.open("#{@abs_env}/deletions_#{l + 1}_#{d + 1}.pat", 'w') { |f|
                    f.write pattern + "[0,#{d + 1},0]"
                }
            }
        }

        # insertions
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            number_of_error.times { |i|
                File.open("#{@abs_env}/insertions_#{l + 1}_#{i + 1}.pat", 'w') { |f|
                    f.write pattern + "[0,0,#{i + 1}]"
                }
            }
        }

        # combinations - all
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            2.times { |e|
                File.open("#{@abs_env}/all_#{l + 1}_#{e + 1}.pat", 'w') { |f|
                    f.write pattern + "[#{e + 1},#{e + 1},#{e + 1}]"
                }
            }
        }

        # combinations - mismatches + deletions
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            number_of_error.times { |e|
                File.open("#{@abs_env}/mismatches_deletions_#{l + 1}_#{e + 1}.pat", 'w') { |f|
                    f.write pattern + "[#{e + 1},#{e + 1},0]"
                }
            }
        }

        # combinations - mismatches + insertions
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            3.times { |e|
                File.open("#{@abs_env}/mismatches_insertions_#{l + 1}_#{e + 1}.pat", 'w') { |f|
                    f.write pattern + "[#{e + 1},0,#{e + 1}]"
                }
            }
        }

        # combinations - deletions + insertions
        length_of_pattern.times { |l|
            pattern = (5 + l).times.map{alphabet[rand(4)]}.join ''
            3.times { |e|
                File.open("#{@abs_env}/deletions_insertions_#{l + 1}_#{e + 1}.pat", 'w') { |f|
                    f.write pattern + "[0,#{e + 1},#{e + 1}]"
                }
            }
        }
    end
end
