require 'json'

class ResultParser

    def initialize
        @enviroment = '../*/benchmark/results'
        @abs_env = "#{File.dirname(__FILE__)}/../../patscan-patterns/benchmark/results/"

        @ruby_files = Dir["#{@enviroment}/ruby/*.txt"].sort!
        @re2_files = Dir["#{@enviroment}/re2/*.txt"].sort!
        @python_files = Dir["#{@enviroment}/python/*.txt"].sort!
        @scan_for_matches_files = Dir["#{@enviroment}/scan_for_matches/*.txt"].sort!
        @kmc_files = Dir["#{@enviroment}/kmc/*.txt"].sort!

    end

    def parse(files)

        results = {}

        files.each { |file|

            content = ''
            File.open(file, 'r') { |f| content = f.readlines.join '' }

            patscan_match = //.match content
            memory_time_match = /~(\n.*040777)?\n(?<memory_time>[\d\.]+)/.match content
            match_time_match = /[^_]*_[^\d]*(?<match_time>[\d\.]+)/.match content
            total_time_match = /[^#]*#[^\d]*(?<total_time>[\d\.]+)/.match content
            match_count_match = /[^&]*&[^\d]*(?<match_count>[\d\.]+)/.match content

            matches = nil
            #matches = /(?m)[^\d]*-\n(?<matches>[^#_&~]+)?/.match content

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

            results[file] = {
                :memory_time => memory_time,
                :matches => matches_list,
                :match_time => match_time,
                :total_time => total_time,
                :match_count => match_count
            }
        }

        data = {
            :patscan_sequence_length => results.values.map { |r| r[] },
            :patscan_pattern_length => [],
            :re_pattern_length => [],
            :patscan_mismatches => [],
            :patscan_insertions => [],
            :patscan_deletions => [],
            :search_time => results.values.map { |r| r[:match_time] },
            :memory_time => results.values.map { |r| r[:memory_time] },
            :total_time => [],
            :match_count => []
        }

        puts data

        return results
    end

    def ruby_results

        parse @ruby_files

        #File.open("#{@abs_env}/ruby.json", 'w') { |f| f.puts parse(@ruby_files).to_json }
    end

    def python_results
        File.open("#{@abs_env}/python.json", 'w') { |f| f.puts parse(@python_files).to_json }
    end

    def re2_results
        File.open("#{@abs_env}/re2.json", 'w') { |f| f.puts parse(@re2_files).to_json }
    end

    def scan_for_matches_results
        File.open("#{@abs_env}/scan_for_matches.json", 'w') { |f| f.puts parse(@scan_for_matches_files).to_json }
    end

    def kmc_results
        parse @kmc_files
    end
end