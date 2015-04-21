

.
|-- Amplicon
|-- Genome
`-- Shotgun

3 directories

Amplicon/ contains a bunch of FASTA files with amplicon data from different experiments.

Genome/ contains the sequence of Human Genome Chromosome 21.

Shotgun/ contains shotgun sequences from the genome of Deboramycis Hansenii (a type of yeast).



Examples for practical use of scan_for_matches
----------------------------------------------

scan_for_matches docs:

  http://blog.theseed.org/servers/2010/07/scan-for-matches.html

Locate all stem loops in a bunch of sequences:

  scan_for_matches stemloops.pat -c < Amplicon/p3_clean_C-94-Ileum_S36.fna

Locate all PCR primer products in a bunch of sequences:

  scan_for_matches pcr_product.pat < Amplicon/p3_clean_C-Bead-Mock_S130.fna

Locate all putative snoRNAs in Human Chromosome 21:

  scan_for_matches snoRNA.pat -c < Genome/chr21.fa


A real-life big set of sequences that needs clustering can be found at:
http://www.arb-silva.de/fileadmin/silva_databases/release_119/Exports/SILVA_119_SSURef_tax_silva.fasta.gz

