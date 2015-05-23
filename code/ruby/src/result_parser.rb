class ResultParser

    def initialize
        @enviroment = '../*/benchmark/results'

        @ruby_files = Dir["#{@enviroment}/ruby/*.txt"].sort!
        @re2_files = Dir["#{@enviroment}/re2/*.txt"].sort!
        @python_files = Dir["#{@enviroment}/python/*.txt"].sort!
        @kmc_files = Dir["#{@enviroment}/kmc/*.txt"].sort!

    end

    def parse(files)

        results = {}

        files.each { |file|

            content = ''
            File.open(file, 'r') { |f| content = (f.readlines.join ' ') }

            match = /~[^\d]*(?<memory_time>[\d\.]+)[^\d]*-(?<matches>[^-]+)?[^-]*-[^_]*_[^\d]*(?<match_time>[\d\.]+)?[^\d]*(?<total_time>[\d\.]+)?[^\d]*(?<match_count>[\d\.]+)?/.match content

            results[file] = {
                :memory_time => match['memory_time'],
                :matches => match['matches'].split(/\n\s?/),
                :match_time => match['match_time'],
                :total_time => match['total_time'],
                :match_count => match['match_count']
            }
        }

        return results
    end

    def ruby_results

        return parse @ruby_files
    end

    def python_results

    end
end