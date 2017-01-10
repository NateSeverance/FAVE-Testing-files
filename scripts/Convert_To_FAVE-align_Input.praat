###############################################################
## This Praat script exports orthographic transcriptions in Praat                      	##
## to a format suitable as input to the FAVE-align forced aligner                      	##
## (http://fave.ling.upenn.edu/FAAValign.html).                                              	##
## The transcription will be converted to a 5-column tab-delimited .txt file     	##
## as outlined in the instructions on the FAVE web site.                                    	##
## 																		##
## To run this program, select the TextGrid containing the transcriptions,		##
## open this script, and select "Run" > "Run".								##
##																		##
## This script was written by Ingrid Rosenfelder, 							##
## last modified October 31, 2011											##
###############################################################

## get TextGrid name
info$ = Info
filename$ = extractLine$(info$, "Object name: ")
outfile$ = filename$ + ".txt"
## ask the user before overwriting exiting file
if fileReadable(outfile$)
	pause 'filename$'.txt already exists.  Overwrite?
	deleteFile(outfile$)
endif

## extract transcription info and write to file
n_tiers = Get number of tiers
for tier from 1 to n_tiers
	tiername$ = Get tier name... 'tier'
	n_intervals = Get number of intervals... 'tier'
	for interval from 1 to 'n_intervals'
		start = Get start point...  'tier' 'interval'
		end = Get end point... 'tier' 'interval'
		label$ =  Get label of interval... 'tier' 'interval'
		if label$ <> ""
			fileappend 'outfile$' 'tiername$''tab$''tiername$''tab$''start''tab$''end''tab$''label$''newline$'
		endif
	endfor
endfor

echo Written transcription in FAVE-align input format to file 'outfile$'.
