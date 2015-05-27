#!/usr/bin/env ruby

require_relative 'parser'
require_relative 'lexer'
require_relative 'translater'
require_relative 'leaf'
require_relative 'benchmark'
require_relative 'result_parser'
require_relative 'visualizer'
require_relative 'grammar/token'

benchmark = Benchmark.new 30, 120
benchmark.ruby
benchmark.python
benchmark.re2
benchmark.scan_for_matches
