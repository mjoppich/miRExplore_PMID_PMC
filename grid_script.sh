


MAINDIR="/mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/"
DATADIR=$MAINDIR
RESULTSDIR=$MAINDIR/results.pmc.raw/
SENTDIR=/mnt/raidtmp/joppich/pubmed_pmc/pmc/europepmc/

MIREXPLORE_PATH=/mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore/python/
ENTENTSCRIPT=$MIREXPLORE_PATH/relation_extraction/createEntEntRelation.py

OPTIONS=""
#OPTIONS="--mine-path /mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/ --threads 8"
#OPTIONS="--mine-path /mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/ --threads 4"
OPTIONS="--threads 1 --nlp $DATADIR/en_core_sci_lg-0.2.4/en_core_sci_lg/en_core_sci_lg-0.2.4/ --nlpent $DATADIR/en_ner_bionlp13cg_md-0.2.4/en_ner_bionlp13cg_md/en_ner_bionlp13cg_md-0.2.4/"

cd $MAINDIR

FILENAME=$1
FNAME=$(basename $FILENAME)
FBNAME=${FNAME%.*}

RELTYPE=$2

OUTPREFIX=$MAINDIR"/aggregated_pmc/$FBNAME/"
mkdir -p $OUTPREFIX

echo $OUTPREFIX
echo $FBNAME
echo $RELTYPE

CMD="python3 -O $ENTENTSCRIPT --single-file $FILENAME --sentid-no-text --sent-no-byte --datadir $DATADIR --sentdir $SENTDIR --resultdir $RESULTSDIR -f1 mirna -f2 mgi  -ft1 mirna -ft2 gene --same-sentence $OPTIONS"
echo $CMD
stdbuf -oL $CMD > $OUTPREFIX"mirna_gene.$2.pmid" 2> $OUTPREFIX"mirna_gene.$2.err" || exit -1
