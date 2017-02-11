# clearPlot <- function() {
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1100, 350), xlim=c(2600, 550))
# BrianL
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1000, 250), xlim=c(2600, 550))
# ChristieL
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1050, 350), xlim=c(2900, 700))
# JanetB
#  plot(0, 0, xlab="F2", ylab="F1", ylim=c(1200, 350), xlim=c(3000, 600))
#}

baseDir = '.'

args <- commandArgs(trailingOnly = TRUE)
speaker <- args[1]

mergedFile <- paste(baseDir, '/merged/', speaker, '_merged.txt', sep = '')
d <- read.delim(mergedFile)

outputFile <- paste(baseDir, '/results/', speaker, '_results.txt', sep = '')
fw = file(outputFile, open='w')

#pdfFile <- paste(baseDir, '/figures/', speaker, '.pdf', sep = '')
#pdf(pdfFile)
#clearPlot()
#points(d$F2, d$F1, col="red")
#points(d$F2_man, d$F1_man, col="blue")

#for(i in 1:nrow(d)) {
#  lines(c(d[i,55], d[i,19]), c(d[i,54], d[i,18]))
#}

#dev.off()

# print out the header row for the output file
cat('v', 'N', 'f1_man_mean', 'f1_auto_mean', 'f1_diff', 'f2_man_mean', 'f2_auto_mean', 'f2_diff', 'f1_man_sd', 'f1_auto_sd', 'f2_man_sd', 'f2_auto_sd', 'f1_rmse', 'f2_rmse', 'f1_diff_mean', 'f1_diff_sd', 'f2_diff_mean', 'f2_diff_sd', 'f1_abs_diff_mean', 'f1_abs_diff_sd', 'f2_abs_diff_mean', 'f2_abs_diff_sd', 'f1_p', 'f1_t', 'f2_p', 'f2_t', 'f1_p_paired', 'f1_t_paired', 'f2_p_paired', 'f2_t_paired', 'f1_r', 'f2_r', sep='\t', file = fw)
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

f1_r <- cor.test(d$F1, d$F1_man)$estimate
f2_r <- cor.test(d$F2, d$F2_man)$estimate

cat(v, N, f1_man_mean, f1_auto_mean, f1_diff, f2_man_mean, f2_auto_mean, f2_diff, f1_man_sd, f1_auto_sd, f2_man_sd, f2_auto_sd, f1_rmse, f2_rmse, f1_diff_mean, f1_diff_sd, f2_diff_mean, f2_diff_sd, f1_abs_diff_mean, f1_abs_diff_sd, f2_abs_diff_mean, f2_abs_diff_sd, f1_p, f1_t, f2_p, f2_t, f1_p_paired, f1_t_paired, f2_p_paired, f2_t_paired, f1_r, f2_r, sep='\t', file = fw)
cat('\n', file = fw)

# Create identical dataframe to calculate environment statistics.
# Operations will be performed on both dataframes the combined.
# -NATE
x <- d

# Ensure these columns are strings so that one may use regexs to relabel
# -NATE
x$vowel <- as.character(x$vowel)
x$plt_code <- as.character(x$plt_code)

# Get the indicies which correspond to the desired postvocalic environments.
# The number directly following the decimal point corresponds to the
# postvocalic phonological environment in the plotnik codes (here: R, L, and N)
# which mean "pre-rhotic," "pre-lateral," and "pre-nasal."
# Negative look ahead used for the "elsewhere" (here: E) condition.
# -NATE
indicies.R <- grep('\\.6', x$plt_code, perl = TRUE)
indicies.L <- grep('\\.5', x$plt_code, perl = TRUE)
indicies.N <- grep('\\.4', x$plt_code, perl = TRUE)
indicies.E <- grep('^((?!\\.6|\\.5|\\.4).)*$', x$plt_code, perl = TRUE)

# Relabel vowels according to desired environment
# -NATE
x$vowel[indicies.R] <- paste(x$vowel[indicies.R], "_R", sep = "")
x$vowel[indicies.L] <- paste(x$vowel[indicies.L], "_L", sep = "")
x$vowel[indicies.N] <- paste(x$vowel[indicies.N], "_N", sep = "")
x$vowel[indicies.E] <- paste(x$vowel[indicies.E], "_E", sep = "")

# Reconvert character columns back to factors.
# -NATE
as.factor(x$vowel)
as.factor(x$plt_code)

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

  f1_r <- cor.test(d_sub$F1, d_sub$F1_man)$estimate
  f2_r <- cor.test(d_sub$F2, d_sub$F2_man)$estimate

  cat(v, N, f1_man_mean, f1_auto_mean, f1_diff, f2_man_mean, f2_auto_mean, f2_diff, f1_man_sd, f1_auto_sd, f2_man_sd, f2_auto_sd, f1_rmse, f2_rmse, f1_diff_mean, f1_diff_sd, f2_diff_mean, f2_diff_sd, f1_abs_diff_mean, f1_abs_diff_sd, f2_abs_diff_mean, f2_abs_diff_sd, f1_p, f1_t, f2_p, f2_t, f1_p_paired, f1_t_paired, f2_p_paired, f2_t_paired, f1_r, f2_r, sep='\t', file = fw)
  cat('\n', file = fw)
}

# Identical operations are performed on the second version (environment conditions version) 
# of the dataframe and they are combined into one dataframe
# -NATE

for (v in unique(x$vowel)) {
  
  x_sub <- subset(x, vowel == v)
  N <- nrow(x_sub)
  
  f1_man_mean <- mean(x_sub$F1_man)
  f1_auto_mean <- mean(x_sub$F1)
  f2_man_mean <- mean(x_sub$F2_man)
  f2_auto_mean <- mean(x_sub$F2)
  
  f1_diff <- abs(f1_man_mean - f1_auto_mean)
  f2_diff <- abs(f2_man_mean - f2_auto_mean)
  
  f1_man_sd <- sd(x_sub$F1_man)
  f1_auto_sd <- sd(x_sub$F1)
  f2_man_sd <- sd(x_sub$F2_man)
  f2_auto_sd <- sd(x_sub$F2)
  
  f1_rmse <- sqrt(sum((x_sub$F1_man - x_sub$F1)^2) / nrow(x_sub))
  f2_rmse <- sqrt(sum((x_sub$F2_man - x_sub$F2)^2) / nrow(x_sub))
  
  f1_diff_mean <- mean(x_sub$F1_man - x_sub$F1)
  f1_diff_sd <- sd(x_sub$F1_man - x_sub$F1)
  f2_diff_mean <- mean(x_sub$F2_man - x_sub$F2)
  f2_diff_sd <- sd(x_sub$F2_man - x_sub$F2)
  
  f1_abs_diff_mean <- mean(abs(x_sub$F1_man - x_sub$F1))
  f1_abs_diff_sd <- sd(abs(x_sub$F1_man - x_sub$F1))
  f2_abs_diff_mean <- mean(abs(x_sub$F2_man - x_sub$F2))
  f2_abs_diff_sd <- sd(abs(x_sub$F2_man - x_sub$F2))
  
  if (N >= 5) {
    t_result <- t.test(x_sub$F1_man, x_sub$F1)
    f1_p <- t_result$p.value
    f1_t <- t_result$statistic
    
    t_result <- t.test(x_sub$F2_man, x_sub$F2)
    f2_p <- t_result$p.value
    f2_t <- t_result$statistic
    
    t_result <- t.test(x_sub$F1_man, x_sub$F1, paired=T)
    f1_p_paired <- t_result$p.value
    f1_t_paired <- t_result$statistic
    
    t_result <- t.test(x_sub$F2_man, x_sub$F2, paired=T)
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
  
  f1_r <- cor.test(x_sub$F1, x_sub$F1_man)$estimate
  f2_r <- cor.test(x_sub$F2, x_sub$F2_man)$estimate
  
  cat(v, N, f1_man_mean, f1_auto_mean, f1_diff, f2_man_mean, f2_auto_mean, f2_diff, f1_man_sd, f1_auto_sd, f2_man_sd, f2_auto_sd, f1_rmse, f2_rmse, f1_diff_mean, f1_diff_sd, f2_diff_mean, f2_diff_sd, f1_abs_diff_mean, f1_abs_diff_sd, f2_abs_diff_mean, f2_abs_diff_sd, f1_p, f1_t, f2_p, f2_t, f1_p_paired, f1_t_paired, f2_p_paired, f2_t_paired, f1_r, f2_r, sep='\t', file = fw)
  cat('\n', file = fw)
}

