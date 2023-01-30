#! /usr/bin/env perl
#'@title script to set a false discovery rate for a list of p values.
#'@author Sibbe Bakker
#'@usage ./fib.pl <d> <p values>
#' prints the q value to be used.

use strict;
use warnings;
use feature q(say);

sub main {
    #' The main procedure.
    
    # Argument handling.
    die 
        "usage: $0 <d> <p values>
        Calculating the Benjamin-Hochberg q value for a given FDR\n

         d \t\t The desired false discovery rate.  
         p values \t The obtained p values separated by spaces. \n"
     unless @ARGV >= 2;
    my ($d, @p_values) = @ARGV;

    # Reporting the input
    my $p_list = join(",", @p_values);
    say "input:\nd = $d \np = $p_list";

    #Calculating the number of rabbits.
}

unless (caller) {
    # Execute the main function is this is the code being run
    main()
}#! /usr/bin/env perl

