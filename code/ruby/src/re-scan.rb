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

puts "#{Time.now.to_f}: Start."

arg1 = ARGV[0]
fasta_file = ''
pattern = ''

# This a regex file
if (arg1.match /^.+\.re$/).nil?
    pattern = arg1
else
    File.open(arg1, 'r') { |file| pattern = file.readlines.join '' }
end

puts "#{Time.now.to_f}: Opening #{ARGV[1]}."
File.open(ARGV[1], 'r') { |file| fasta_file = file.readlines.join ' ' }
puts "#{Time.now.to_f}: Finished loading fasta file into memory\n_"

begin
    regex = Regexp.new pattern

    matches = fasta_file.to_enum(:scan, regex).map { Regexp.last_match }

    puts '-'

    matches.each { |m|
        puts "\t:#{Time.now.to_f}: Found #{m.to_s} at #{m.begin 0}:#{m.end 0}."
    }

    puts "_\n#{Time.now.to_f}: Found #{matches.size} matches to #{arg1}."

rescue RegexpError => e
    # Regular expression is too big for the ruby engine.
    puts "#{Time.now.to_f}: Regular expression of length #{pattern.length}, is too big for the ruby regular expression engine."
end
