
MAINDIR="/mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/"

SENTDIR="/mnt/input/public/EuroupePMC/oa/"
ALLFILES=`ls -d $SENTDIR/*.xml.gz`
RUNTYPE="ES"

mkdir -p $MAINDIR/gridlogs_extract/

for FILE in PMC8530001_PMC8540000.xml.gz PMC7910001_PMC7920000.xml.gz PMC7820001_PMC7830000.xml.gz PMC8620001_PMC8630000.xml.gz PMC9020001_PMC9030000.xml.gz # $ALLFILES
do

FILE="/mnt/input/public/EuroupePMC/oa/$FILE"

echo $FILE

FILENAME=$FILE
FNAME=$(basename $FILENAME)
FBNAME=${FNAME%.*}

qsub -b y -l vf=7168M -o "$MAINDIR/gridlogs_extract/jobname.$RUNTYPE.$FBNAME.o" -e "$MAINDIR/gridlogs_extract/jobname.$RUNTYPE.$FBNAME.e" -N "${RUNTYPE}${FBNAME}" bash $MAINDIR/grid_extract_script.sh $FILE

done


