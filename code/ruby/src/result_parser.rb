class ResultParser

    def initialize
        @enviroment = '../*/benchmark/results'

        @ruby_files = Dir["#{@enviroment}/ruby/*.txt"].sort!
        @re2_files = Dir["#{@enviroment}/re2/*.txt"].sort!
        @python_files = Dir["#{@enviroment}/python/*.txt"].sort!
        @kmc_files = Dir["#{@enviroment}/kmc/*.txt"].sort!

    end

    def parse

        results = []

        @ruby_files.each { |f|
            content = f.readlines

        }
    end

    def ruby_results

    end
end