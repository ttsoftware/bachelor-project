class Benchmark

    def initialize

        @enviroment = '../*/benchmark'
        @output = ''
    end

    # for all patscan files in the directory
    def files
        Dir["#{@enviroment}/**/*.pat"].each { |f|
            pp f
        }
    end

    def ruby
        system('./re-scan.rb ')
    end

    def python

    end

    def re2

    end
end