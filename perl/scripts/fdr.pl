#! /usr/bin/env perl
#'@title script to set a false discovery rate for a list of p values.
#'@author Sibbe Bakker
#'@usage ./fib.pl <d> <p values>
#' prints the q value to be used.
# ./fdr.pl 0.05 0.008 0.009 0.165 0.205 0.396 0.450 0.641 0.781 0.900 0.993

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
    #@description This regular expression, lets real numbers pass that _are 
    # not_ written in scientific notation. Example 1 (pass) -1 (pass) 1.335
    # (pass) 7e3 (fail).

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
    my @T = map[ ( $array[$_] ), int( $_ ) ], 0 .. $#array;
    
    # sorting the array on the first element, value of @array
    my @T_sorted = sort { $a->[0] <=>  $b->[0] } @T;
    
    my ($rank, $n, $i) = (1, 1, 0);
    while( $i < $number ){
        my $j = $i;

        # ignore ties for now
        while( $j < $number-1 and $T_sorted[$j][0]==$T_sorted[$j+1][0] ){
            $j += 1;
        }
        
        $n = $j - $i + 1;

        # calculate the tie value
        if ($n > 0) {
            foreach( 0 .. $n-1 ){
                my $idx = $T_sorted[$i+$_][1];
                # Ties are handled by determining average.
                $ranks[$idx] = $rank + ($n-1)* 0.5;
            }
        }
        $rank += $n;
        $i += $n;
    }
    # This solves the bug 
    pop @ranks;
    return @ranks;
}

sub broken_rank {
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
    print "Determining the rank of $number items.\n";
    
    my @T = map[ ( $array[$_] ), int( $_ ) ], 0 .. $#array;

    
    # sorting the array on the first element, value of @array
    my @T_sorted = sort { $a->[0] <=>  $b->[0] } @T;
    
    # # printing the array:
    # foreach(0 .. $number){
    #     print join "\t", @{ $T_sorted[ $_ ] }, "\n";
    # }

    my ($rank, $n, $i) = (1, 1, 0);
    say "condition is $i < $number-1";
    while( $i < $number-1 ){
        my $j = $i;
        # for debug
        if ($i >= $number){say "ERROR at $i"};
        # for debug
        print  "$i th number: $T_sorted[$j][0] \t| ";

        # ignore ties for now
        while( $j < $number-1 and $T_sorted[$j][0]==$T_sorted[$j+1][0] ){
            $j += 1;

            print "$T_sorted[$j][0], ";
        }
        
        $n = $j - $i + 1;

        print "($n = $j + $i +1)\n";

        # calculate the tie value
        if ($n > 0) {
            foreach( 0 .. $n-1 ){
                my $idx = $T_sorted[$i+$_][1];
                # Ties are handled by determining average.
                $ranks[$idx] = $rank + ($n-1)* 0.5;
                say "handling $_ th tie value ($T_sorted[$_ +$i][0]): $ranks[$idx]";
            }
        }
        $rank += $n;
        $i += $n;
        print "\n final rank for $i th value: $ranks[$i] \n";
    }
    # pop @ranks;
    return @ranks;
}

sub calculate_false_discovery_rate {
    #@d, value indicating the desired FDR.
    #@param @array A list of p values. Between 0 and 1.
    #'@description The false discovery rate is calculated using 
    #' f(j) = (d/m)×j, where j is the rank of a p value. A value is below the
    #' FDR if it is below the function f(j).
    
    my ($d, @p_values) = @_;
    
    # Reporting the input
    my $p_list = join(",", @p_values);
    
    # type checking
    is_numeric($d);
    check_p_values(@p_values);

    # The number of hypothesis tests
    my $m = @p_values;
    my @ranks = rank(@p_values);

    # The delta/m value that is multiplied with each j.
    my $fdr_fct = $d / $m;

    my @fdr_values = @ranks;
    foreach my $p_rank (@fdr_values) { $p_rank = $p_rank * $fdr_fct; };

    return @fdr_values;
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
    
    # Calculating
    my @significant_p =  calculate_false_discovery_rate($d_input, 
        @p_values_input);
    
    # Giving output
    say STDOUT join(" ", @significant_p);
}

unless (caller) {
    # Execute the main function is this is the code being run
    main()
}#! /usr/bin/env perl

