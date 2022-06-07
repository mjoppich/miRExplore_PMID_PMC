#!/usr/bin/sh

echo "Usage: textmine [infile sent dir] [output base] <synbase folder>"
echo "Input: prefix for sentences file(s)"
echo "Output: path where to store results. results are stored in ouput + <output>/results/<synname>"
echo "Synbase Folder: if not specified equals output base"

if [ "$#" -lt 2 ]; then
    echo "Illegal number of parameters $#"
		exit -1
fi
if [ "$#" -gt 3 ]; then
    echo "Illegal number of parameters $#"
		exit -1
fi

if [ "$#" -eq 2 ]; then
	SENTENCESPREFIX="$1"
	BASEFOLDER=$2
	SYNBASEFOLDER=$2
else
	SENTENCESPREFIX="$1"
	BASEFOLDER=$2
	SYNBASEFOLDER=$3
fi

SCRIPTPATH=$(dirname "$0")

mkdir -p $BASEFOLDER

#/home/users/joppich/progs/anaconda3/bin/python3 /home/users/joppich/python/NERtoolkit/scripts/convertJatsToText.py -i $BASEFOLDER/XML-files/AllXMLs/*.xml --no-references -o $BASEFOLDER/XML-files/AllXMLs/mod_allxml.sent --ignore-sections "Author Contributions" "Acknowledgement" "Conflict of Interest"
#/home/users/joppich/progs/anaconda3/bin/python3 /home/users/joppich/python/NERtoolkit/scripts/convertJatsToText.py -i $BASEFOLDER/XML-files/PDF_Random_PMC/*.xml --no-references -o $BASEFOLDER/XML-files/PDF_Random_PMC/mod_pmc.sent --ignore-sections "Author Contributions" "Acknowledgement" "Conflict of Interest"

RUNMIRNA="TRUE"
RUNHGNC="TRUE"
RUNMGI="TRUE"
RUNORG="TRUE"
RUNDISEASE="TRUE"
RUNCELLLINES="TRUE"
RUNGO="TRUE"
RUNNCIT="TRUE"
RUNRELATIONS="TRUE"
RUNMODELANATOMY="FALSE"

echo "Searching sentences: $SENTENCESPREFIX"
echo "Textmine results   : $BASEFOLDER"
echo "Synonym base folder: $SYNBASEFOLDER"

mkdir -p $BASEFOLDER

ALLFOLDERS=()

FOLDER=$BASEFOLDER/model_anatomy
ALLFOLDERS+=("$FOLDER")
if [ "$RUNMODELANATOMY" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "" $SYNBASEFOLDER/synonyms/model_anatomy.syn || exit -1
fi

FOLDER=$BASEFOLDER/ncit
ALLFOLDERS+=("$FOLDER")
if [ "$RUNNCIT" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "" $SYNBASEFOLDER/synonyms/ncit.syn || exit -1
fi

FOLDER=$BASEFOLDER/mirna
ALLFOLDERS+=("$FOLDER")
if [ "$RUNMIRNA" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "" $SYNBASEFOLDER/synonyms/mirbase.hsa_mmu.syn || exit -1
fi

FOLDER=$BASEFOLDER/hgnc
ALLFOLDERS+=("$FOLDER")
if [ "$RUNHGNC" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "" $SYNBASEFOLDER/synonyms/hgnc.syn || exit -1
fi

FOLDER=$BASEFOLDER/mgi
ALLFOLDERS+=("$FOLDER")
if [ "$RUNMGI" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "" $SYNBASEFOLDER/synonyms/mgi.syn || exit -1
fi

FOLDER=$BASEFOLDER/disease
ALLFOLDERS+=("$FOLDER")
if [ "$RUNDISEASE" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "TRUE" $SYNBASEFOLDER/synonyms/disease.syn ""|| exit -1
fi

FOLDER=$BASEFOLDER/cellline
ALLFOLDERS+=("$FOLDER")
if [ "$RUNCELLLINES" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "TRUE" $SYNBASEFOLDER/synonyms/cell_ontology.syn || exit -1
fi

FOLDER=$BASEFOLDER/go
ALLFOLDERS+=("$FOLDER")
if [ "$RUNGO" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "" $SYNBASEFOLDER/synonyms/go.*.syn || exit -1
fi

FOLDER=$BASEFOLDER/relations
ALLFOLDERS+=("$FOLDER")
if [ "$RUNRELATIONS" = "TRUE" ]; then
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "TRUE" $SYNBASEFOLDER/synonyms/allrels.syn || exit -1
fi

if [ "$RUNORG" = "TRUE" ]; then
	FOLDER=$BASEFOLDER/org
	ALLFOLDERS+=("$FOLDER")
	rm -rf $FOLDER
	mkdir -p $FOLDER
	$SCRIPTPATH/runSyngrep.sh $FOLDER $SENTENCESPREFIX "TRUE" $SYNBASEFOLDER/synonyms/organism.syn || exit -1
fi
