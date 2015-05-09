#!/usr/bin/env ruby

require_relative 'translater'
require_relative 'lexer'
require_relative 'parser'
require_relative 'leaf'
require_relative 'grammar/token'

##
# We expect argument 1 to be a pat-scan pattern, or a file which contains a pat-scan pattern.
# We expect argument 2 to be a FASTA or FASTQ file
# We output a string containing a regular expression.
##

if ARGV.length != 2
    puts 'Invalid number of arguments. At least 2 arguments were expected.'
    exit!
end

arg1 = ARGV[0]
fasta_file = ''
patscan_pattern = ''

# This a pattern file
unless (arg1.match /.+\.pat/).nil?
    File.open(arg1, 'r') { |file| patscan_pattern = (file.readlines.join ' ').rstrip! }
else
    patscan_pattern = arg1
end

puts "Trying #{patscan_pattern} in #{arg1}."

puts "Opening #{ARGV[1]}."
File.open(ARGV[1], 'r') { |file| fasta_file = file.readlines.join ' ' }
puts 'Finished loading fasta file into memory'

pattern = Translater.new(patscan_pattern).translate

begin
    regex = Regexp.new pattern

    matches = fasta_file.to_enum(:scan, regex).map { Regexp.last_match }

    puts "Found #{matches.size} matches to #{patscan_pattern} in #{arg1}."

    matches.each { |m|
        puts "\t:Found #{m.to_s} at #{m.begin 0}:#{m.end 0}"
    }
rescue RegexpError => e
    # Regular expression is too big for the ruby engine.
    puts "Regular expression of length #{pattern.length} created from #{patscan_pattern}, is too big for the ruby regular expression engine."
end