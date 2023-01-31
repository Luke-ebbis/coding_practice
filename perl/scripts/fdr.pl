#! /usr/bin/env perl
#'@title script to set a false discovery rate for a list of p values.
#'@author Sibbe Bakker
#'@usage ./fib.pl <d> <p values>
#' prints the q value to be used.
# ./fdr.pl 5 0.2 0.3 0.1 0.001 0.05 0.2 0.003 0.05 0.001 0.8 0.95 0.006

use strict;
use warnings;
use feature q(say);

sub check_p_values {
    #'@title Checking whether a list of P values is below 1 and above 0.
    #'@param @array An array of values.
    #'@return Nothing, if the values are wrong, this function will halt the
    #' programme.
    #'@description This is a function that checks whether values are within an
    # allowed range. If the value is outside of that range, the programme will
    # stop calculation and give an error.

    my @values = @_;
    my $error = 1;

    foreach(@values){
        $_ > 0 or die "$_ is equal or less than 0";
        $_ <= 1 or die "$_ is greater than 1";
    }
}


sub is_numeric {
    #'@Title checking whether an array contains only numeric values.

    my (@array) = @_;
    foreach(@array){
        grep( /^-*[0-9]\d*(\.\d+)?$/, $_ ) or die "$_ is not numeric.";
    }
}

sub rank {
    #'@Ranking algorithm
    #'@param @array; numbers to be ranked.
    #' This ranking algorithm comes from 
    # https://www.geeksforgeeks.org/rank-elements-array/.
    # TODO Make check to determine if all numbers are numeric. Note I do not
    # yet know how that works.
    #@dependencies is_numeric()

    my (@array) = @_;
    is_numeric(@array);

    my $number = @array;

    my @ranks = (0 .. $number);
    print "Determining the rank of $number items.";
    
    my @T = map[ ( $array[$_] ), int( $_ ) ], 0 .. $#array;
    # printing the array:
    say "the T array:";
    foreach(@ranks){
        print join "\t", @{ $T[ $_ ] }, "\n";
    }
}

sub calculate_false_discovery_rate {
    #'@description The false discovery rate is calculated using 
    #' f(j) = (d/m)×j, where j is the rank of a p value. A value is below the
    #' FDR if it is below the function f(j).
    
    my ($d, @p_values) = @_;
    
    # Reporting the input
    my $p_list = join(",", @p_values);
    say "input:\nd = $d \np = $p_list";
    
    check_p_values(@p_values);
    
}

sub main {
    #' The main procedure.
    
    # Argument handling.
    die 
        "usage: $0 <d> <p values>
        Calculating the Benjamin-Hochberg q value for a given FDR\n

         d \t\t The desired false discovery rate.  
         p values \t The obtained p values separated by spaces. Maximum
         \t \t value allowed is 1.\n"
     unless @ARGV >= 2;
    my ($d_input, @p_values_input) = @ARGV;

     rank(@p_values_input);

    #Calculate the FDR
    # my $false_discovery_rate = calculate_false_discovery_rate($d_input, 
    #     @p_values_input);
    # say STDOUT $false_discovery_rate;
}

unless (caller) {
    # Execute the main function is this is the code being run
    main()
}#! /usr/bin/env perl

