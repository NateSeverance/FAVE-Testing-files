# This script reads in a .plt measurement file and finds the corresponding
# automated measurements from a FAVE-extract .txt file.  The output is
# a spreadsheet that contains information about both sets of measurements
# for each matching word token.

import sys
from bs4 import UnicodeDammit
from unidecode import unidecode

pltFile = sys.argv[1]
txtFile = sys.argv[2]
outputFile = sys.argv[3]

plotnikCodes = {'1':'IH', '2':'EH', '3':'AE', '5':'AA', '6':'AH', '7':'UH', '11':'IY', '12':'IY', '21':'EY', '22':'EY', '39':'AE_BR', '41':'AY', '47':'AY', '61':'OY', '42':'AW', '62':'OW', '63':'OW', '72':'UW', '73':'UW', '82':'UW', '43':'AA', '53':'AO', '14':'IH', '24':'EH', '44':'AA', '54':'AO', '64':'AO', '74':'UH', '94':'ER'}

words = {}

# check whether the input Plotnik file is .plt or .pln
ext = pltFile.split('.')[-1]

lines = open(txtFile).readlines()
header = lines[0].rstrip('\n')
for line in lines[1:]:
  line = line.rstrip('\n')
  w = line.split('\t')[15]
  w = w.upper()
  if w in words:
    words[w].append(line)
  else:
    words[w] = [line]

header = header + '\t' + '\t'.join(['F1_man', 'F2_man', 'F3_man', 'plt_code', 'plt_stress', 'plt_word', 't_man']) + '\n'

fw = open(outputFile, 'w')
fw.write(header)

plt_lines = open(pltFile, 'rb').readlines()
skipped_lines = []
# skip the first two lines since they contain header information
for plt_line in plt_lines[2:]:
  print(plt_line)
  plt_line = UnicodeDammit(plt_line, ['utf-8', 'windows-1252']).unicode_markup
  plt_line = unidecode(plt_line)
  plt_line = plt_line.rstrip()
  plt_F1 = plt_line.split(',')[0]
  # a line beginning with '1' is the first line of the vowel means; this
  # signals the end of the vowel token measurements, so we can stop
  # processing the file
  if plt_F1 == '1':
    break

  plt_w_raw = plt_line.split(',')[5].split(' ')[0]
  plt_w = plt_w_raw.upper()
  plt_w =  plt_w.replace('(', '')
  plt_w = plt_w.replace(')', '')
  print(plt_w)
  if plt_w not in words:
    skipped_lines.append(plt_line)
    print("SKIPPING LINE -- WORD NOT FOUND")
    print(plt_line)
    print("")
    continue

  plt_t = float(plt_line.split(',')[5].split(' ')[-1])
  # an arbitrary large number
  min_diff = 1000
  min_diff_auto_line = ''
  for auto_line in words[plt_w]:
    t = float(auto_line.split('\t')[23])
    diff = abs(plt_t - t)
    if diff < min_diff:
      min_diff_auto_line = auto_line
      min_diff = diff

  if min_diff > 0.1:
    skipped_lines.append(plt_line)
    print("SKIPPING LINE -- WORD AND VOWEL FOUND, BUT MEASUREMENT POINT DIFFERENCE EXCEEDS THRESHOLD")
    print(plt_line)
    print(min_diff_auto_line)
    print("")
    continue
 
  plt_v = plt_line.split(',')[3].split('.')[0]
  plt_v = plotnikCodes[plt_v]
  v = min_diff_auto_line.split('\t')[12]
  if plt_v != v:
    skipped_lines.append(plt_line)
    print("SKIPPING LINE -- WORD FOUND, BUT VOWEL DOES NOT MATCH")
    print(plt_line)
    print(min_diff_auto_line)
    print("")
    continue
  plt_F2 = plt_line.split(',')[1]
  plt_F3 = plt_line.split(',')[2]
  plt_code = plt_line.split(',')[3]
  plt_stress = plt_line.split(',')[4]
  plt_values = [plt_F1, plt_F2, plt_F3, plt_code, plt_stress, plt_w_raw, str(plt_t)]
  output = min_diff_auto_line + '\t' + '\t'.join(plt_values) + '\n'
  fw.write(output)

fw.close()

n_skipped = len(skipped_lines)
print("SKIPPED %d LINES OVERALL FROM PLT INPUT FILE" % n_skipped)
