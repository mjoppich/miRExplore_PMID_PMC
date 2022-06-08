#!/usr/bin/sh

MIREXPLORE_PATH=/mnt/raidtmp/joppich/pubmed_pmc/pmc/miRExplore/python/
bash doTextmine.sh "/usr/bin/python3 $MIREXPLORE_PATH/textmining/textmineDocument.py --threads 32" "../oa_bulk/extracted_sentences/" "./results.pmc.raw/" "./"

#bash doTextmine.sh "./pmid/pubmed20n" "./results.pmid.raw/" "./"
