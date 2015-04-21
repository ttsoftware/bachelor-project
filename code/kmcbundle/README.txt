How to set up the KMC framework.
-------------

You need the Haskell platform to install and use the KMC software.  Download
it at https://www.haskell.org/platform/.

The directory structure of this bundle is
.
├── README.txt
├── regexps-syntax-master
└── repg-master

There are two Haskell projects included: regexps-syntax is a parser
for regular expression terms; repg is an implementation of regular
expression parsing and matching.

The commands below assume that the current working directory is the root
directory of the bundle.  If you follow the sequence of steps below you
will end up with a compiled binary in repg-master/dist/build/repg/repg
and a link called repg in repg-master

- cd repg-master
- cabal sandbox init
- cabal sandbox add-source ../regexps-syntax-master
- cabal install --only-dependencies
- cabal configure && cabal build
- ln -s dist/build/repg/repg repg


To run a small example:
- Generate a bit of test data:
  * cd test/data/ab_strings
  * ./gen_ab > abs.txt
  * cd ../../..
- Compile the flip_ab.has program:
  * ./repg compile bench/hased_src/flip_ab.has --out flip_ab
- Run it!
  * ./flip_ab < test/data/ab_strings/abs.txt > output.txt

