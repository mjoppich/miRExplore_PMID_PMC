#!/usr/bin/sh

MIREXPLORE_PATH=/mnt/f/dev/git/miRExplore/python/
MIREXPLORE_PATH=/mnt/raidtmp/joppich/pubmed_pmc/pmc/miRExplore/python/
bash doTextmine.sh "/usr/bin/python3 $MIREXPLORE_PATH/textmining/textmineDocument.py --threads 30" "/mnt/raidtmp/joppich/pubmed_pmc/pmc/europepmc/" "./results.pmc.raw/" "./"


#bash doTextmine.sh "/usr/bin/python3 $MIREXPLORE_PATH/textmining/textmineDocument.py --threads 12" "/mnt/w/PubMed/pubmed22n" "./results.pubmed.raw/" "./"