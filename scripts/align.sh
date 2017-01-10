# The directory where FAVE-align is located
FAAVDIR=/Users/NateSeverance/Desktop/FAVE-align-Toolkit

# The directory where Aaron's data is stored
BASE=/Users/NateSeverance/Desktop/FAVE-final-results

cd $FAAVDIR

# Modify this to analyze different speakers
#filenames="JanetB AlexS BrianL"
filenames="SusanS"
pronunciationsFile=/Users/NateSeverance/Desktop/FAVE-final-results/OOV-words-Utica.txt

for f in $filenames
do
  echo "ALIGNING $f"

  # these are the file names of the two input files 
  audioFile=$BASE/audio/$f.wav
  transFile=$BASE/transcription/$f.txt

  # this is the file name of the output file with the forced alignment result
  alignmentFile=$BASE/alignment/$f.TextGrid

  # use Python v. 2.7, since FAAV isn't compatible with Python v. 3 yet
  python2 FAAValign.py --import=$pronunciationsFile $audioFile $transFile $alignmentFile

done
