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
    puts 'Invalid number of arguments. Exactly 2 arguments were expected.'
    exit!
end

arg1 = ARGV[0]
fasta_file = ARGV[1]
patscan_pattern = ''

# This a pattern file
unless (arg1.match /.+\.pat/).nil?
    File.open(arg1, 'r') { |file| patscan_pattern = file.readlines.join ' ' }
else
    patscan_pattern = arg1
end

puts Translater.new(patscan_pattern).translate