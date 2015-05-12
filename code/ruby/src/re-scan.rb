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
pattern = ''

# This a regex file
if (arg1.match /^.+\.re$/).nil?
    pattern = arg1
else
    File.open(arg1, 'r') { |file| pattern = file.readlines.join '' }
end

puts "Opening #{ARGV[1]}."
File.open(ARGV[1], 'r') { |file| fasta_file = file.readlines.join ' ' }
puts 'Finished loading fasta file into memory'

begin
    regex = Regexp.new pattern

    matches = fasta_file.to_enum(:scan, regex).map { Regexp.last_match }

    puts "Found #{matches.size} matches to #{arg1}."

    matches.each { |m|
        puts "\t:Found #{m.to_s} at #{m.begin 0}:#{m.end 0}"
    }
rescue RegexpError => e
    # Regular expression is too big for the ruby engine.
    puts "Regular expression of length #{pattern.length}, is too big for the ruby regular expression engine."
end