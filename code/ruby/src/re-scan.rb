#!/usr/bin/env ruby

require_relative 'translater'
require_relative 'lexer'
require_relative 'parser'
require_relative 'leaf'
require_relative 'grammar/token'

##
# We expect argument 1 to be a re pattern, or a file which contains a re pattern.
# We expect argument 2 to be a FASTA or FASTQ file
# We output a string containing a regular expression.
##

if ARGV.length != 2
    puts 'Invalid number of arguments. At least 2 arguments were expected.'
    exit!
end

arg1 = ARGV[0]
fasta_file = ''
pattern = ''

# This a regex file
if (arg1.match /^.+\.re$/).nil?
    pattern = arg1
else
    File.open(arg1, 'r') { |file| pattern = file.readlines.join '' }
end

read_file_start = Time.now
File.open(ARGV[1], 'r') { |file| fasta_file = file.readlines.join ' ' }
read_file_end = Time.now

# <Memory time>
puts (read_file_end - read_file_start) * 1000.0

begin
    regex = Regexp.new pattern

    match_time_start = Time.now
    matches = fasta_file.to_enum(:scan, regex).map { Regexp.last_match }
    match_time_end = Time.now

    # <Match time>
    puts '_'
    puts (match_time_end - match_time_start) * 1000.0

    # <Total time>
    puts '#'
    puts (Time.now - read_file_start) * 1000.0

    # <Number of matches>
    puts '&'
    puts matches.size

    # <Matches>
    puts '-'
    matches.each { |m|
        puts "#{m.to_s} - #{m.begin 0}:#{m.end 0} - #{(Time.now.to_f - read_file_start) * 1000.0}"
    }

rescue RegexpError => e
    # Regular expression is too big for the ruby engine.
    # puts "#{Time.now.to_f}: Regular expression of length #{pattern.length}, is too big for the ruby regular expression engine."
end
