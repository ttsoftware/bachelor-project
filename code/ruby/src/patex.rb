#!/usr/bin/env ruby

require_relative 'parser'
require_relative 'lexer'
require_relative 'translater'
require_relative 'leaf'
require_relative 'benchmark'
require_relative 'result_parser'
require_relative 'visualizer'
require_relative 'grammar/token'

if ARGV.include?('--help')
    puts 'Patex [<Patscan pattern>] [-i <File path>] [-o <File path>]

-i <File name>   - Reads the patscan pattern from a file
                 | Input file must follow the -i flag
-o <File name>   - Saves the Regular Expression to a file
                 | Output file must follow the -o flag'
    exit!
end

if ARGV.length == 1
    translater = Translater.new ARGV[0]
    puts translater.translate
    exit!
end

if ARGV.include?('-i') and not ARGV.include?('-o') and ARGV.length == 2
    translater = Translater.new File.read(ARGV[1]).rstrip
    puts translater.translate
    exit!

elsif not ARGV.include?('-i') and ARGV.include?('-o') and ARGV.length == 3
    o = ARGV.index '-o'
    translater = Translater.new ARGV[o == 0 ? 2 : 0]
    File.open(ARGV[o+1], 'w') { |f| f.puts(translater.translate) }
    exit!

elsif ARGV.include?('-i') and ARGV.include? ('-o') and ARGV.length == 4
    i = ARGV.index '-i'
    o = ARGV.index '-o'
    translater = Translater.new File.read(ARGV[i+1]).rstrip
    File.open(ARGV[o+1], 'w') { |f| f.puts(translater.translate) }
    exit!
end

puts 'That is not a valid Patex command. For help, use flag --help'