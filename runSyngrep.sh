echo "Usage: runSyngrep [TMEXEC] [output] [infiles] [excludes] [synfiles]"

TMEXEC="$1"
OUTPUT=$2
INFILE=$3
EXCL=$4

echo $TMEXEC
echo $OUTPUT
echo $INFILE
echo $EXCL

shift
shift
shift
shift

SYNFILES=$@
echo $SYNFILES

SYNGREP_EXCLUDE="-e excludes/all_excludes.syn"

if [ ! -z "$EXCL" ]; then
echo "REMOVING EXCLUDES"
SYNGREP_EXCLUDE=""
fi

#SYNGREP="./progs/syngrep"
SYNGREP=$TMEXEC
Context_SyngrepCall="$SYNGREP -s $SYNFILES"
SYNGREP_EXTRAS="-nocells -tl 5 -prunelevel none "
#-extra '()[]' -tuple /home/proj/biosoft/SFB1123/Athero_Bioinfo.tuple

SYNGREPCALL="$Context_SyngrepCall -i "$INFILE*.sent" -o $OUTPUT $SYNGREP_EXTRAS $SYNGREP_EXCLUDE"
echo $SYNGREPCALL
/usr/bin/time --verbose $SYNGREPCALL  || exit -1

#rm $OUTPUT/*.contextes
