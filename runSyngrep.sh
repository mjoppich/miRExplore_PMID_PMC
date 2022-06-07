echo "Usage: runSyngrep [output] [infiles] [excludes] [synfiles]"

OUTPUT=$1
INFILE=$2
EXCL=$3

echo $OUTPUT
echo $INFILE
echo $EXCL

shift
shift
shift

SYNFILES=$@
echo $SYNFILES

SYNGREP_EXCLUDE="-e /mnt/d/dev/progs/allwords.out"

#cat /mnt/f/dev/data/pmid_jun2020/excludes/allwords.out /mnt/f/dev/data/pmid_jun2020/excludes/manual_curated.syn /mnt/f/dev/data/pmid_jun2020/excludes/exclude_words.common.syn | grep -v "^#" |  sed -e "s/^[ \t']*//" | sort | uniq > /mnt/f/dev/data/pmid_jun2020/excludes/all_excludes.syn

SYNGREP_EXCLUDE="-e /mnt/f/dev/data/pmid_jun2020/excludes/all_excludes.syn"

if [ ! -z "$EXCL" ]; then
SYNGREP_EXCLUDE=""
fi

#SYNGREP="./progs/syngrep"
SYNGREP="/usr/bin/python3 /mnt/f/dev/git/miRExplore/python/textmining/textmineDocument.py"
Context_SyngrepCall="$SYNGREP -np 14 -s $SYNFILES"
SYNGREP_EXTRAS="-nocells -tl 5 -prunelevel none "
#-extra '()[]' -tuple /home/proj/biosoft/SFB1123/Athero_Bioinfo.tuple

SYNGREPCALL="$Context_SyngrepCall -i "$INFILE*.sent" -o $OUTPUT $SYNGREP_EXTRAS $SYNGREP_EXCLUDE"
echo $SYNGREPCALL
/usr/bin/time --verbose $SYNGREPCALL  || exit -1

#rm $OUTPUT/*.contextes
