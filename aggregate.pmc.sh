


MAINDIR="./"
DATADIR=$MAINDIR
RESULTSDIR=$MAINDIR/results.pmc.raw/
SENTDIR=/mnt/w/PubMedCentral/

MIREXPLORE_PATH=/mnt/f/dev/git/miRExplore/python/
ENTENTSCRIPT=$MIREXPLORE_PATH/relation_extraction/createEntEntRelation.py
OUTPREFIX=$MAINDIR"/aggregated_pmc/"

mkdir -p $OUTPREFIX

OPTIONS="--mine-path /mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/ --threads 4"

cd $MAINDIR

CMD="python3 -O $ENTENTSCRIPT --sentid-no-text --sent-no-byte --datadir $DATADIR --sentdir $SENTDIR --resultdir $RESULTSDIR -f1 mirna -f2 mgi  -ft1 mirna -ft2 gene --same-sentence $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX"mirna_gene.mmu.pmid" 2> $OUTPREFIX"mirna_gene.mmu.err" || exit -1

CMD="python3 -O $ENTENTSCRIPT --sentid-no-text --sent-no-byte --datadir $DATADIR --sentdir $SENTDIR --resultdir $RESULTSDIR -f1 mirna -f2 hgnc -ft1 mirna -ft2 gene --same-sentence $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX"mirna_gene.hsa.pmid" 2> $OUTPREFIX"mirna_gene.hsa.err" || exit -1

cat $OUTPREFIX/mirna_gene.mmu.pmid $OUTPREFIX/mirna_gene.hsa.pmid | cut -f 7 | sort | uniq > $OUTPREFIX/relevant_pmids.list
echo "Found Documents"
wc -l $OUTPREFIX/relevant_pmids.list

CONTEXTSCRIPT=$MIREXPLORE_PATH/relation_extraction/createContextInfo.py

CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/disease/ --obo $MAINDIR/obodir/doid.obo $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX/disease.pmid || exit -1

CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/cellline/ --obo $MAINDIR/obodir/cell_ontology.obo $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX/celllines.pmid || exit -1

CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/go/ --obo $MAINDIR/obodir/go.obo $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX/go.pmid || exit -1

CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/model_anatomy/ --obo $MAINDIR/obodir/model_anatomy.obo $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX/model_anatomy.pmid || exit -1

CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/org/ --obo $MAINDIR/obodir/organism.obo $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX/organism.pmid || exit -1

CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/ncit/ --obo $MAINDIR/obodir/ncit.obo $OPTIONS"
echo $CMD
$CMD > $OUTPREFIX/ncit.pmid || exit -1