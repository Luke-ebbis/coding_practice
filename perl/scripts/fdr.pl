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
    #'@return boolean, 1 if the P values are below 1 and above 0, 0 if
    #' otherwise.
    my @values = @_;

    foreach(@values){
        $_ <= 0 or die "$_ is equal or less than 0";
        # try {
    # my $x = call_a_function();
    # $x < 100 or die "Too big";
    # send_output($x);
# }
# catch ($e) {
    # warn "Unable to output a value; $e";
# }
# print "Finished\n";
    }


}

sub calulate_false_discovery_rate {

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
    my ($d, @p_values) = @ARGV;

    # Reporting the input
    my $p_list = join(",", @p_values);
    say "input:\nd = $d \np = $p_list";
    
    check_p_values(@p_values);


    #Calculate the FDR
    my $false_discovery_rate = calculate_false_discovery_rate($d, @p_values);
    say STDOUT $false_discovery_rate;
}

unless (caller) {
    # Execute the main function is this is the code being run
    main()
}#! /usr/bin/env perl

