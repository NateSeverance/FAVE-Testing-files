# Conducts speaker-level z-score normalization for the manual and automated formants contained in the merged spreadsheet for the speaker.

import sys
import math

def meanstdv(x):
  n, mean, std = len(x), 0, 0
  for a in x:
    mean = mean + a
  mean = mean / float(n)
  for a in x:
    std = std + (a - mean)**2
  std = math.sqrt(std / float(n-1))
  return mean, std

# This input file contains manual formant measurements from the Plotnik .plt file for the speaker and automated formants extracted by FAVE.  It was produced by merge-manual-auto.py
formantsFile = sys.argv[1]

f1_auto_list = []
f2_auto_list = []
f1_man_list = []
f2_man_list = []

lines = [line.rstrip('\n') for line in open(formantsFile, 'rU').readlines()[1:]]
for line in lines:
  f1_auto = float(line.split('\t')[17])
  f2_auto = float(line.split('\t')[18])
  f1_man = float(line.split('\t')[53])
  f2_man = float(line.split('\t')[54])
  if f1_auto == 0.0:
    continue
  f1_auto_list.append(f1_auto)
  f2_auto_list.append(f2_auto)
  f1_man_list.append(f1_man)
  f2_man_list.append(f2_man)

lines = [line.rstrip('\n') for line in open(formantsFile, 'rU').readlines()]
header = lines[0] + '\t' + '\t'.join(['F1_auto_z', 'F2_auto_z', 'F1_man_z', 'F2_man_z'])
print(header)
for line in lines[1:]:

  f1_auto = float(line.split('\t')[17])
  f2_auto = float(line.split('\t')[18])
  f1_man = float(line.split('\t')[53])
  f2_man = float(line.split('\t')[54])

  m, sd = meanstdv(f1_auto_list)
  f1_auto_z = round((f1_auto - m) / sd, 3)

  m, sd = meanstdv(f2_auto_list)
  f2_auto_z = round((f2_auto - m) / sd, 3)

  m, sd = meanstdv(f1_man_list)
  f1_man_z = round((f1_man - m) / sd, 3)

  m, sd = meanstdv(f2_man_list)
  f2_man_z = round((f2_man - m) / sd, 3)

  line = line + '\t' + '\t'.join([str(f1_auto_z), str(f2_auto_z), str(f1_man_z), str(f2_man_z)])
  print(line)
