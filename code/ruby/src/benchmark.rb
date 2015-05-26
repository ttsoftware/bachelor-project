class Benchmark

    # @param [Integer] runtime Seconds for each thread to run
    def initialize(compiletime, runtime)

        @runningtime = runtime
        @compiletime = compiletime

        @abs_env = "#{File.dirname(__FILE__)}/../../patscan-patterns/benchmark"
        @enviroment = '../*/benchmark'

        # find all patscan files in the enviroment
        @patscan_files = Dir["#{@enviroment}/**/*.pat"].sort!

        # find all fasta files in the enviroment
        @fasta_files = Dir["#{@enviroment}/../../genome/*.fa"].sort!
    end

    def start_threads(runtime, engine, is_scan_for_matches=false)

        # run all tests in pairs of 5 at a time
        @patscan_files.each_slice(4) { |slice|

            threads = []

            slice.each { |file|

                threads << Thread.new {

                    patscan_pattern = ''
                    File.open(file, 'r') { |f| patscan_pattern = (f.readlines.join ' ').rstrip! }

                    # we must first generate the regex pattern.
                    # define the .re file location
                    re_file = file.sub /^(?<path>.+)\/(?<name>[^\/]+)\.pat$/, '\k<path>/\k<name>.re'

                    puts "Trying #{file}."

                    t = Thread.new {

                        pattern = Translater.new(patscan_pattern).translate
                        File.open(re_file, 'w') { |f|
                            f.write pattern
                        }
                    }

                    sleep @compiletime

                    Thread.kill t # only allow compile time of @compiletime seconds
                    t.join

                    # define output file for current input file
                    result_file = re_file.sub /^(?<path>.+)\/(?<name>[^\/]+)\.(pat|re)$/, '\k<name>-result.txt'
                    result_file = "#{@abs_env}/results/#{engine}/#{result_file}"


                    File.open(result_file, 'w') { |f|
                        f.puts patscan_pattern

                        re_pattern = ''
                        File.open(re_file, 'r') { |r| re_pattern = r.readline }

                        f.puts "%\n#{re_pattern.length}"
                        f.puts "£\n#{re_pattern.split(/\|/).size}\n~"
                    }

                    if not File.exist? re_file
                        puts "ERROR: No such file #{re_file} - compile failed or did not finish."
                        next
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

    def re2
        start_threads('../c++/main', 're2')
    end

    def kmc

    end

    def scan_for_matches
        start_threads('../scan_for_matches/main.py', 'scan_for_matches', true)
    end
end