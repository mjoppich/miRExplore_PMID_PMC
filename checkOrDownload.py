import glob
import hashlib
import os, sys

def calculateMD5(filename):
    
    with open(filename, "rb") as f:
        file_hash = hashlib.md5()
        while chunk := f.read(8192):
            file_hash.update(chunk)
        return file_hash.hexdigest()

def getDownloadedMD5(filename):
    with open(filename+".md5") as fin:
        for line in fin:
            hash = line.strip().split(")= ")[1]
            return hash

import argparse


if __name__ == '__main__':


    parser = argparse.ArgumentParser(description='Check Medline XML files for md5 integrity')
    parser.add_argument('-x', '--xml-path', type=str, required=True, help="path to folder with XML.GZ files.")
    args = parser.parse_args()

    for filename in glob.glob("{}/*.gz".format(args.xml_path)):

        fileMD5 = calculateMD5(filename)
        downloadedMD5 = getDownloadedMD5(filename)

        if str(downloadedMD5) == "None":
            print("Skipping downloadedMD5", filename)
            continue

        while not fileMD5 == downloadedMD5:
            print(filename, fileMD5, downloadedMD5, fileMD5 == downloadedMD5)
            os.system("sleep 1")
            
            fileBaseName = os.path.basename(filename)

            os.remove(filename)

            wgetCMD = "wget -O {} ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/{}".format(filename, fileBaseName)
            print(wgetCMD)
            os.system(wgetCMD)

            fileMD5 = calculateMD5(filename)
            downloadedMD5 = getDownloadedMD5(filename)

            print(filename, fileMD5, downloadedMD5, fileMD5 == downloadedMD5)   