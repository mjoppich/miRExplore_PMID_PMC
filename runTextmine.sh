#!/usr/bin/sh

MIREXPLORE_PATH=/mnt/f/dev/git/miRExplore/python/
bash doTextmine.sh "/usr/bin/python3 $MIREXPLORE_PATH/textmining/textmineDocument.py" "./pmc/" "./results.pmc.raw/" "./"

#bash doTextmine.sh "./pmid/pubmed20n" "./results.pmid.raw/" "./"
