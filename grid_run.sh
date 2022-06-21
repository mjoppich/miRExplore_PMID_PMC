
MAINDIR="/mnt/raidinput2/tmp/joppich/pubmed_pmc/pmc/miRExplore_PMID_PMC/"

RUNTYPE="mgi"
ALLFILES=`ls -d $MAINDIR/results.pmc.raw/$RUNTYPE/*`

for FILE in $ALLFILES
do
echo $FILE

FILENAME=$FILE
FNAME=$(basename $FILENAME)
FBNAME=${FNAME%.*}

qsub -b y -l vf=7168M -o "$MAINDIR/gridlogs/jobname.$RUNTYPE.$FBNAME.o" -e "$MAINDIR/gridlogs/jobname.$RUNTYPE.$FBNAME.e" -N "$RUNTYPE $FBNAME" bash $MAINDIR/grid_script.sh $FILE $RUNTYPE

done




RUNTYPE="hgnc"
ALLFILES=`ls -d $MAINDIR/results.pmc.raw/$RUNTYPE/*`

for FILE in $ALLFILES
do
echo $FILE

FILENAME=$FILE
FNAME=$(basename $FILENAME)
FBNAME=${FNAME%.*}

qsub -b y -l vf=7168M -o "$MAINDIR/gridlogs/jobname.$RUNTYPE.$FBNAME.o" -e "$MAINDIR/gridlogs/jobname.$RUNTYPE.$FBNAME.e" -N "$RUNTYPE $FBNAME" bash $MAINDIR/grid_script.sh $FILE $RUNTYPE

done
