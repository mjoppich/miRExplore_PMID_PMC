
MAINDIR="/mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/"
DATADIR=$MAINDIR
RESULTSDIR=$MAINDIR/results.pmc.raw/
MIREXPLORE_PATH=/mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore/python/
EXTRACTSCRIPT=$MIREXPLORE_PATH/textmining/medlineXMLtoStructurePMC.py


XMLFILE=$1

python3 -O $EXTRACTSCRIPT --xml-path $XMLFILE --base "" --output /mnt/raidtmp/joppich/pubmed_pmc/pmc/europepmc/ --threads 1 --zipped