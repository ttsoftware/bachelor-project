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
            File.open(file, 'r') { |f| content = f.readlines }

            results[file] = { :matches => [] }

            content.each { |l|
                line = l.rstrip
                choice = 'nothing'

                tildes = 0
                underscores = 0
                if line == '~'
                    choice = '~'
                    tildes += 1
                    if tildes == 2
                        choice = 'nothing'
                    end
                elsif line == '-'
                    choice = '-'
                elsif line == '_'
                    choice = '_'
                end

                case choice
                    when '~'
                        results[file]['memory_time'] = line
                    when '-'
                        results[file]['matches'] << line
                    when '_'
                        underscores += 1
                        if underscores == 1
                            results[file]['match_time'] = line
                        elsif underscores == 2
                            results[file]['total_time'] = line
                        elsif underscores == 3
                            results[file]['match_count'] = line
                        end
                end
            }

            #match = /~[^\d]*(?<memory_time>[\d\.]+)[^\d]*-(?<matches>[^-]+)?[^-]*-[^_]*_[^\d]*(?<match_time>[\d\.]+)?[^\d]*(?<total_time>[\d\.]+)?[^\d]*(?<match_count>[\d\.]+)?/.match content

            # results[file] = {
            #     :memory_time => match['memory_time'],
            #     :matches => match['matches'].split(/\n\s?/),
            #     :match_time => match['match_time'],
            #     :total_time => match['total_time'],
            #     :match_count => match['match_count']
            # }
        }

        return results
    end

    def ruby_results
        parse @ruby_files
    end

    def python_results

    end
end