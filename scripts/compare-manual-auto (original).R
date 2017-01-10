clearPlot <- function() {
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1100, 350), xlim=c(2600, 550))
# BrianL
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1000, 250), xlim=c(2600, 550))
# ChristieL
  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1050, 350), xlim=c(2900, 700))
# JanetB
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1200, 350), xlim=c(3000, 600))
}

baseDir = '.'

args <- commandArgs(trailingOnly = TRUE)
speaker <- args[1]

mergedFile <- paste(baseDir, '/merged/', speaker, '_merged.txt', sep = '')
d <- read.delim(mergedFile)

outputFile <- paste(baseDir, '/results/', speaker, '_results.txt', sep = '')
fw = file(outputFile, open='w')

pdfFile <- paste(baseDir, '/figures/', speaker, '.pdf', sep = '')
pdf(pdfFile)
clearPlot()
points(d$F2, d$F1, col="red")
points(d$F2_man, d$F1_man, col="blue")

for(i in 1:nrow(d)) {
  lines(c(d[i,55], d[i,19]), c(d[i,54], d[i,18]))
}

dev.off()

# print out the header row for the output file
cat('v', 'N', 'f1_man_mean', 'f1_auto_mean', 'f1_diff', 'f2_man_mean', 'f2_auto_mean', 'f2_diff', 'f1_man_sd', 'f1_auto_sd', 'f2_man_sd', 'f2_auto_sd', 'f1_rmse', 'f2_rmse', 'f1_diff_mean', 'f1_diff_sd', 'f2_diff_mean', 'f2_diff_sd', 'f1_abs_diff_mean', 'f1_abs_diff_sd', 'f2_abs_diff_mean', 'f2_abs_diff_sd', 'f1_p', 'f_t', 'f2_p', 'f2_t', 'f1_p_paired', 'f1_t_paired', 'f2_p_paired', 'f2_t_paired', sep='\t', file = fw)
cat('\n', file = fw)

# calculate the stats for all vowels together
v <- 'all'
N <- nrow(d)

f1_man_mean <- mean(d$F1_man)
f1_auto_mean <- mean(d$F1)
f2_man_mean <- mean(d$F2_man)
f2_auto_mean <- mean(d$F2)

f1_diff <- abs(f1_man_mean - f1_auto_mean)
f2_diff <- abs(f2_man_mean - f2_auto_mean)

f1_man_sd <- sd(d$F1_man)
f1_auto_sd <- sd(d$F1)
f2_man_sd <- sd(d$F2_man)
f2_auto_sd <- sd(d$F2)

f1_rmse <- sqrt(sum((d$F1_man - d$F1)^2) / nrow(d))
f2_rmse <- sqrt(sum((d$F2_man - d$F2)^2) / nrow(d))

f1_diff_mean <- mean(d$F1_man - d$F1)
f1_diff_sd <- sd(d$F1_man - d$F1)
f2_diff_mean <- mean(d$F2_man - d$F2)
f2_diff_sd <- sd(d$F2_man - d$F2)

f1_abs_diff_mean <- mean(abs(d$F1_man - d$F1))
f1_abs_diff_sd <- sd(abs(d$F1_man - d$F1))
f2_abs_diff_mean <- mean(abs(d$F2_man - d$F2))
f2_abs_diff_sd <- sd(abs(d$F2_man - d$F2))

f1_p <- 'NA'
f1_t <- 'NA'
f2_p <- 'NA'
f2_t <- 'NA'

f1_p_paired <- 'NA'
f1_t_paired <- 'NA'
f2_p_paired <- 'NA'
f2_t_paired <- 'NA'

cat(v, N, f1_man_mean, f1_auto_mean, f1_diff, f2_man_mean, f2_auto_mean, f2_diff, f1_man_sd, f1_auto_sd, f2_man_sd, f2_auto_sd, f1_rmse, f2_rmse, f1_diff_mean, f1_diff_sd, f2_diff_mean, f2_diff_sd, f1_abs_diff_mean, f1_abs_diff_sd, f2_abs_diff_mean, f2_abs_diff_sd, f1_p, f1_t, f2_p, f2_t, f1_p_paired, f1_t_paired, f2_p_paired, f2_t_paired, sep='\t', file = fw)
cat('\n', file = fw)

# calculate the stats for each vowel category

for (v in unique(d$vowel)) {

  d_sub <- subset(d, vowel == v)
  N <- nrow(d_sub)

  f1_man_mean <- mean(d_sub$F1_man)
  f1_auto_mean <- mean(d_sub$F1)
  f2_man_mean <- mean(d_sub$F2_man)
  f2_auto_mean <- mean(d_sub$F2)

  f1_diff <- abs(f1_man_mean - f1_auto_mean)
  f2_diff <- abs(f2_man_mean - f2_auto_mean)

  f1_man_sd <- sd(d_sub$F1_man)
  f1_auto_sd <- sd(d_sub$F1)
  f2_man_sd <- sd(d_sub$F2_man)
  f2_auto_sd <- sd(d_sub$F2)

  f1_rmse <- sqrt(sum((d_sub$F1_man - d_sub$F1)^2) / nrow(d_sub))
  f2_rmse <- sqrt(sum((d_sub$F2_man - d_sub$F2)^2) / nrow(d_sub))

  f1_diff_mean <- mean(d_sub$F1_man - d_sub$F1)
  f1_diff_sd <- sd(d_sub$F1_man - d_sub$F1)
  f2_diff_mean <- mean(d_sub$F2_man - d_sub$F2)
  f2_diff_sd <- sd(d_sub$F2_man - d_sub$F2)

  f1_abs_diff_mean <- mean(abs(d_sub$F1_man - d_sub$F1))
  f1_abs_diff_sd <- sd(abs(d_sub$F1_man - d_sub$F1))
  f2_abs_diff_mean <- mean(abs(d_sub$F2_man - d_sub$F2))
  f2_abs_diff_sd <- sd(abs(d_sub$F2_man - d_sub$F2))

  if (N >= 5) {
   t_result <- t.test(d_sub$F1_man, d_sub$F1)
   f1_p <- t_result$p.value
   f1_t <- t_result$statistic

   t_result <- t.test(d_sub$F2_man, d_sub$F2)
   f2_p <- t_result$p.value
   f2_t <- t_result$statistic

   t_result <- t.test(d_sub$F1_man, d_sub$F1, paired=T)
   f1_p_paired <- t_result$p.value
   f1_t_paired <- t_result$statistic

   t_result <- t.test(d_sub$F2_man, d_sub$F2, paired=T)
   f2_p_paired <- t_result$p.value
   f2_t_paired <- t_result$statistic
  } else {
    f1_p <- 'NA'
    f1_t <- 'NA'
    f2_p <- 'NA'
    f2_t <- 'NA'

    f1_p_paired <- 'NA'
    f1_t_paired <- 'NA'
    f2_p_paired <- 'NA'
    f2_t_paired <- 'NA'
  }

  cat(v, N, f1_man_mean, f1_auto_mean, f1_diff, f2_man_mean, f2_auto_mean, f2_diff, f1_man_sd, f1_auto_sd, f2_man_sd, f2_auto_sd, f1_rmse, f2_rmse, f1_diff_mean, f1_diff_sd, f2_diff_mean, f2_diff_sd, f1_abs_diff_mean, f1_abs_diff_sd, f2_abs_diff_mean, f2_abs_diff_sd, f1_p, f1_t, f2_p, f2_t, f1_p_paired, f1_t_paired, f2_p_paired, f2_t_paired, sep='\t', file = fw)
  cat('\n', file = fw)
}
