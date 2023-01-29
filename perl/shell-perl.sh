#! /usr/bin/env bash
#'@author Håkon Hægland, Ján Sárenik.
#'@linkout https://stackoverflow.com/a/22840242
#'@description This is a shell script that makes a perl interactive perl console.
echo "This is Interactive Perl shell started on $(date)"
rlwrap -A -pgreen -S"perl> " perl -wnE'say eval()//$@'

