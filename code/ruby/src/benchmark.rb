class Benchmark

    # @param [Integer] runtime Seconds for each thread to run
    def initialize(runtime)

        @runningtime = runtime

        @abs_env = "#{File.dirname(__FILE__)}/../../patscan-patterns/benchmark"
        @enviroment = '../*/benchmark'

        # find all patscan files in the enviroment
        @patscan_files = Dir["#{@enviroment}/**/*.pat"].sort!

        # find all fasta files in the enviroment
        @fasta_files = Dir["#{@enviroment}/../../genome/*.fa"].sort!
    end

    def start_threads(runtime, engine)

        # run all tests in pairs of 5 at a time
        @patscan_files.each_slice(4) { |slice|

            threads = []

            slice.each { |file|

                if engine != 'ruby'
                    # we must first generate the regex pattern.

                    # define the .re file location
                    re_file = file.sub /^(?<path>.+)\/(?<name>[^\/]+)\.pat$/, '\k<path>/\k<name>.re'

                    puts "Trying #{file}."

                    patscan_pattern = ''
                    File.open(file, 'r') { |f| patscan_pattern = (f.readlines.join ' ').rstrip! }

                    pattern = Translater.new(patscan_pattern).translate
                    File.open(re_file, 'w') { |f|
                        f.write pattern
                    }

                    file = re_file
                end

                # define output file for current input file
                result_file = file.sub /^(?<path>.+)\/(?<name>[^\/]+)\.(pat|re)$/, '\k<name>-result.txt'

                threads << Thread.new {

                    pid = spawn(
                        "#{runtime} #{file} #{@fasta_files[0]}",
                        :out => ["#{@abs_env}/results/#{engine}/#{result_file}", 'w']
                    )

                    # only run this thread for @runtime seconds.
                    sleep @runningtime

                    begin
                        Process.kill('SIGKILL', pid)
                    rescue Errno::ESRCH => e
                        # no such process it already finished, which is nice.
                    end
                }

                puts "Started #{file} with command '#{runtime} #{file} #{@fasta_files[0]}'"

                File.delete file
            }

            threads.each { |t| t.join }
        }
    end

    def ruby
        start_threads("#{File.dirname(__FILE__)}/re-scan.rb", 'ruby')
    end

    def python

    end

    def re2
        start_threads('../c++/main', 're2')
    end

    def kmc

    end
end