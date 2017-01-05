# The directory where FAVE-extract is located
FAAVDIR=/Users/NateSeverance/Desktop/FAVE-extract-Toolkit/

# The directory where Aaron's data is stored
BASE=/Users/NateSeverance/Desktop/FAVE-final-results

cd $FAAVDIR

# Modify this to analyze different speakers
#filenames="JanetB AlexS BrianL"
filenames=AlexS

for f in $filenames
do
  echo "EXTRACTING FORMANTS FOR $f"

  # these are the file names of the two input files 
  audioFile=$BASE/audio/$f.wav
  alignmentFile=$BASE/alignment/$f.TextGrid

  # this is the file that the formant measurements will be stored in
  formantFile=$BASE/formants/$f.txt

  # use Python v. 2.7, since FAAV isn't compatible with Python v. 3 yet
  python2 bin/extractFormants.py --config config.txt $audioFile $alignmentFile $formantFile

done
