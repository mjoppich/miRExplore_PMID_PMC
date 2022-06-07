# Steps to reproduce

## Check File Integrity

When downloading the PubMed files from NCBI some files might turn out to be corrupt. This script will check the md5 hash included in the download and re-download files until md5sum of the downloaded file and the text file match.

    python3 checkOrDownload.py --xml-path /mnt/w/PubMed/

## Extract Sentences

miRExplore operates on finding words in sentences. Also, the timeline feature requires information on authors, publication date, etc. Such data are stored in separate, tab-separated files per XML document.

    export MIREXPLORE_PATH=/mnt/f/dev/git/miRExplore/python/
    python3 $MIREXPLORE_PATH/textmining/medlineXMLtoStructure.py --base pubmed22n --xml-path /mnt/w/PubMed/ --threads 14


## Prepare Text Mining

### Prepare miRNA synonyms

    wget -O obodir/aliases.txt.zip https://mirbase.org/ftp/CURRENT/aliases.txt.zip
    wget -O obodir/miRNA.xls.zip https://mirbase.org/ftp/CURRENT/miRNA.xls.zip

    unzip obodir/aliases.txt.zip
    unzip obodir/miRNA.xls.zip

    python3 $MIREXPLORE_PATH/synonymes/mirbase2syn.py --mirna-xls obodir/miRNA.xls --mirna-alias obodir/aliases.txt --syn synonyms/mirbase.hsa_mmu.syn

### Prepare gene synonyms

#### Downloading Mouse data

Mouse information on genes and synonyms can be found at MGI: http://www.informatics.jax.org/downloads/reports/index.html

We require the MGI Marker associations to Sequence (GenBank, RefSeq,Ensembl) information (tab-delimited) file:

    wget -O obodir/mouse_genes.rpt http://www.informatics.jax.org/downloads/reports/MRK_Sequence.rpt

    python3 $MIREXPLORE_PATH/synonymes/mgi2syn.py --rpt obodir/mouse_genes.rpt --syn synonyms/mgi.syn

This requires access to the nameConvert-repository.

#### Downloading Human data

You must create a custom export from https://www.genenames.org/download/custom/ . It must have the following columns: HGNC ID, Approved Symbol, Approved Name, Previous Symbols, Previous Name, Synonyms and Name Synonyms. It can be downloaded from https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_app_name&col=gd_status&col=gd_prev_sym&col=gd_aliases&col=gd_pub_chrom_map&col=gd_pub_acc_ids&col=gd_pub_refseq_ids&col=gd_name_aliases&col=gd_prev_name&status=Approved&status=Entry%20Withdrawn&hgnc_dbtag=on&order_by=gd_prev_sym&format=text&submit=submit

    wget -O obodir/hgnc.tsv "https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_app_name&col=gd_status&col=gd_prev_sym&col=gd_aliases&col=gd_pub_chrom_map&col=gd_pub_acc_ids&col=gd_pub_refseq_ids&col=gd_name_aliases&col=gd_prev_name&status=Approved&status=Entry%20Withdrawn&hgnc_dbtag=on&order_by=gd_prev_sym&format=text&submit=submit"

    python3 $MIREXPLORE_PATH/synonymes/hgnc2syn.py --tsv obodir/hgnc.tsv --syn synonyms/hgnc.syn

### Prepare disease ontology synonyms

The DOID can be downloaded from https://github.com/DiseaseOntology/HumanDiseaseOntology/tree/main/src/ontology .

    wget -O obodir/doid.obo https://raw.githubusercontent.com/DiseaseOntology/HumanDiseaseOntology/main/src/ontology/HumanDO.obo

    python3 $MIREXPLORE_PATH/synonymes/diseaseobo2syn.py --obo obodir/doid.obo --syn synonyms/disease.syn

### Prepare NCIT

The NCIT obo can be downloaded from https://obofoundry.org/ontology/ncit#:~:text=NCI%20Thesaurus%20%28NCIt%29is%20a%20reference%20terminology%20that%20includes,NCIt%20OBO%20Edition%20releases%20should%20be%20considered%20experimental. 

    wget -O obodir/ncit.obo http://purl.obolibrary.org/obo/ncit.obo

    python3 $MIREXPLORE_PATH/synonymes/ncit2syn.py --obo obodir/ncit.obo --syn synonyms/ncit.syn --ncit ./ncit_conversion_folder/


### Prepare GO

The GO obo can be downloaded from https://obofoundry.org/ontology/go.html .
Here we use, in order to avoid too many overlapping terms, the basic GO version.

    wget -O obodir/go.obo http://purl.obolibrary.org/obo/go/go-basic.obo

    python3 $MIREXPLORE_PATH/synonymes/gobo2syn.py --obo obodir/go.obo --syn synonyms/


### Prepare Model Anatomy

The, integrated cross-species ontology covering anatomical structures in animals, uberon ontology is available from https://obofoundry.org/ontology/uberon.html . The basic edition excludes external ontologies and most relations.

    wget -O obodir/model_anatomy.obo http://purl.obolibrary.org/obo/uberon/basic.obo

    python3 $MIREXPLORE_PATH/synonymes/modelanatomy2syn.py --obo obodir/model_anatomy.obo --syn synonyms/model_anatomy.syn

### Prepare Cell Ontology

    wget -O obodir/cell_ontology.obo http://purl.obolibrary.org/obo/cl/cl-basic.obo

    python3 $MIREXPLORE_PATH/synonymes/cells2syn.py --obo obodir/cell_ontology.obo --syn synonyms/cell_ontology.syn

## Performing text mining

    bash doTextmine.sh "../PubMed/" "./results.pubmed.raw/" "./"


### Check for highly mentioned

    python3 $MIREXPLORE_PATH/synonymes/identifyHighlyMentionedSynonyms.py --index ./results.pubmed.raw/ncit/pubmed22n001*


## Perform interaction mining

We save the following information in a bash script:

    MAINDIR="./"
    DATADIR=$MAINDIR
    RESULTSDIR=$MAINDIR/results.pubmed.raw/
    SENTDIR=/mnt/w/PubMed/

    MIREXPLORE_PATH=/mnt/f/dev/git/miRExplore/python/
    ENTENTSCRIPT=$MIREXPLORE_PATH/relation_extraction/createEntEntRelation.py
    OUTPREFIX=$MAINDIR"/aggregated_pmid/"

    mkdir -p $OUTPREFIX

    cd $MAINDIR

    # RELATION EXTRACTION
    CMD="python3 -O $ENTENTSCRIPT --sentid-no-text --sent-no-byte --datadir $DATADIR --sentdir $SENTDIR --resultdir $RESULTSDIR -f1 mirna -f2 mgi  -ft1 mirna -ft2 gene --same-sentence"
    echo $CMD
    $CMD > $OUTPREFIX"mirna_gene.mmu.pmid" 2> $OUTPREFIX"mirna_gene.mmu.err" || exit -1

    CMD="python3 -O $ENTENTSCRIPT --sentid-no-text --sent-no-byte --datadir $DATADIR --sentdir $SENTDIR --resultdir $RESULTSDIR -f1 mirna -f2 hgnc -ft1 mirna -ft2 gene --same-sentence"
    echo $CMD
    $CMD > $OUTPREFIX"mirna_gene.hsa.pmid" 2> $OUTPREFIX"mirna_gene.hsa.err" || exit -1


    # SUBSET CONTEXT ONLY FOR RELEVANT ARTICLES
    cat $OUTPREFIX/mirna_gene.mmu.pmid $OUTPREFIX/mirna_gene.hsa.pmid | cut -f 7 | sort | uniq > $OUTPREFIX/relevant_pmids.list
    echo "Found Documents"
    wc -l $OUTPREFIX/relevant_pmids.list

    # CONTEXT EXTRACTION
    CONTEXTSCRIPT=$MIREXPLORE_PATH/relation_extraction/createContextInfo.py

    CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/disease/ --obo $MAINDIR/obodir/doid.obo"
    echo $CMD
    $CMD > $OUTPREFIX/disease.pmid || exit -1

    CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/cellline/ --obo $MAINDIR/obodir/cell_ontology.obo"
    echo $CMD
    $CMD > $OUTPREFIX/celllines.pmid || exit -1

    CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/go/ --obo $MAINDIR/obodir/go.obo"
    echo $CMD
    $CMD > $OUTPREFIX/go.pmid || exit -1

    CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/model_anatomy/ --obo $MAINDIR/obodir/model_anatomy.obo"
    echo $CMD
    $CMD > $OUTPREFIX/model_anatomy.pmid || exit -1

    CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/org/ --obo $MAINDIR/obodir/organism.obo"
    echo $CMD
    $CMD > $OUTPREFIX/organism.pmid || exit -1

    CMD="python3 -O $CONTEXTSCRIPT --sentid-no-text --accept-pmids $OUTPREFIX/relevant_pmids.list --datadir $MAINDIR --sentdir $SENTDIR --resultdir $RESULTSDIR/ncit/ --obo $MAINDIR/obodir/ncit.obo"
    echo $CMD
    $CMD > $OUTPREFIX/ncit.pmid || exit -1

and run it

    bash aggregate.pubmed.sh


## Using PMC

Adding PMC to miRExplore works very similar. Again we need run named-entity recognition

    bash doTextmine.sh "../PubMedCentral/" "./results.pmc.raw/" "./"

and perform then the same aggregation strategy (but with different directories):

    bash aggregate.pmc.sh