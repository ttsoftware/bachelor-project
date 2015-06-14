# bachelor-project

To run the code go to code/ruby and execute 'src/patex.rb'.
This will run a simple command line tool, that can translate patscan patterns into
regular expressions.


--------- BENCHMARKING ---------

To run benchmarking on all of the .pat files under code/benchmark
and generate result files for each implementation (ruby, re2, python, python regex, scan-for-matches).

The test suite will run in ~6 hours, and the result files will accumulate about 12.5 GB of disk space


Each of the seperate implementations can also be run seperately under:

Ruby: 'code/ruby/src/re-scan.rb \<file.re\> \<file.fa\>'

Python: 'code/python/main.py \<file.re\> \<file.fa\>'

Python Regex: 'code/python_regex/main.py \<file.re\> \<file.fa\>'

RE2: 'code/c++/main \<file.re\> \<file.fa\>'

scan-for-matches: 'code/scan_for_matches/main.py \<file.pat\> \<file.fa\>'


--------- REQUIREMENTS ---------

Scan-for-matches requires that you have 'scan_for_matches' installed and available in your $PATH

RE2 requires that you have libre2 installed. Our modified version can be found at https://github.com/ttsoftware/re2

Ruby requires ruby 2.2.

Python requires python 2.7

Python regex requires the regex library https://pypi.python.org/pypi/regex
