class Benchmark

    def initialize

        @enviroment = '../*/benchmark'

        # find all patscan files in the enviroment
        @patscan_files = Dir["#{@enviroment}/**/*.pat"].sort!

        # find all fasta files in the enviroment
        @fasta_files = Dir["#{@enviroment}/../../genome/*.fa"].sort!
    end

    def ruby

        threads = []

        # run all tests
        @patscan_files[0..5].each { |file|
            threads << Thread.new {
                #system "#{File.dirname(__FILE__)}/re-scan.rb",  "#{file}", "#{@fasta_files[0]}"

                pid = spawn("#{File.dirname(__FILE__)}/re-scan.rb #{file} #{@fasta_files[0]}")
            }

            puts "Started #{file}."
        }

        threads.each { |t|
            t.join 5
            t.exit
        }
    end

    def python

    end

    def re2

    end

    def kmc

    end
end