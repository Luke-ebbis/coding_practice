#!/usr/bin/env Rscript 
# Needleman-Wunch algorithm
# author --- Sibbe Bakker
## by YGC
## August 7, 2008
## guangchuangyu AT gmail.com

 X <-"AAGAAGAAGAAG"
 Y <-"GAGAAGAAAAAGAG"

 seq.x <- unlist(strsplit(X, ''))
 seq.y <- unlist(strsplit(Y, ''))

 seq.x <- c(0,seq.x)
 seq.y <- c(0,seq.y)

 match <- 5
 mismatch <- -2
 indel <- -6

 ## initial the score matrix
 score <- matrix(NA, length(seq.x), length(seq.y))
 score[,1] <- sapply(1:length(seq.x)-1, function(x) x * indel)
 score[1,] <- sapply(1:length(seq.y)-1, function(x) x * indel)

 ## The dynamic programming, global alignment recursion
 for (i in 2:length(seq.x)) {
     for (j in 2:length(seq.y)){
         # seq.x[i] , seq.y[j] are aligned
         if ( seq.x[i] == seq.y[j]) {
             score[i,j] <- score[i-1, j-1] + match
         } else {
             score[i,j] <- score[i-1, j-1] + mismatch
         }
         # seq.x[i] aligned to -
         sc <- score[i-1,j] + indel
         if (sc > score[i,j])
             score[i,j] = sc
         # seq.y[j] aligned to -
         sc <- score[i,j-1] + indel
         if (sc > score[i,j])
             score[i,j] = sc
     }
 }

 ## Traceback
 i <- length(seq.x)
 j <- length(seq.y)
 ax <- character()
 ay <- character()
 while (i > 1 && j >1){
     ## case 1: best was seq.x[i] aligned to seq.y[j]
     sc <- score[i-1,j-1]
     if (seq.x[i] == seq.y[j]) {
         sc <- sc + match
     } else {
         sc <- sc + mismatch
     }
     if (sc == score[i,j]) {
         ax <- c(seq.x[i], ax)
         ay <- c(seq.y[j], ay)
         i <- i -1
         j <- j-1
         next
     }
     ## case 2: best was seq.x[i] aligned to -
     if ((score[i-1,j] + indel) == score[i,j]) {
         ax <- c(seq.x[i], ax)
         ay <- c("-", ay)
         i <- i-1
         next
     }
     ## case 3: best was seq.y[j] aligned to -
     if ((score[i,j-1] + indel) == score[i,j]) {
         ax <- c("-", ax)
         ay <- c(seq.y[j], ay)
         j <- j-1
         next
     }
 }

 cat ("Sequence X: ", X,"\n")
 cat ("Sequence Y: ", Y,"\n")
 cat ("Scoring system: ", match, " for match; ", mismatch, " for mismatch; ", indel, " for gap", "\n\n")

 cat ("Dynamic programming matrix:\n")
 print (score)

 cat ("\nAlignment:\n")
 cat (paste(ax, collapse=''), "\n")
 cat (paste(ay, collapse=''),"\n\n")
 cat ("Optimum alignment score: ", score[length(score)],"\n")
