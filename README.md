# bachelor-project
To run the code go to code/ruby and execute 'src/run-benchmark.rb'.

This will run the benchmark on all of the .pat files under code/patscan-patterns/benchmark
and generate result files for each implementation (ruby, re2, python, scan-for-matches).

The test suite will run in ~2 hours.

Each of the seperate implementations can also be run seperately under:

Python: 'code/python/main.py \<file.re\> \<file.fa\>'

Ruby: 'code/ruby/re-scan.rb \<file.re\> \<file.fa\>'

RE2: 'code/c++/main \<file.re\> \<file.fa\>'

scan-for-matches: 'code/scan_for_matches/main.py \<file.pat\> \<file.fa\>'

Scan-for-matches requires that you have 'scan_for_matches' installed and available in your $PATH.

RE2 requires that you ahve libre2 installed. Our modified version can be found at https://github.com/ttsoftware/re2

Ruby requires ruby 2.2.

Python requires python 2.7.
