#!/usr/bin/perl -w
# Shannon Entropy Calculator
# Written by an Korf, Mark Yandell & Joseph Bedell et al (page 57)
# You enter a value, then exit using Ctr + D.
# To do: -refactor this in python, R and write another inplementation in perl.
my %Count;
# stores the counts of each symbol
my $total = 0; # total symbols counted
while (<>) { # the <>  is made to consider lines of input.
    # read lines of input
    foreach my $char (split(//, $_)) { # split the line into characters
        $Count{$char}++;
        # add one to this character count
        $total++;
        # add one to total counts
        print $char;
    }
}
my $H = 0; #H is the entropy
    foreach my $char (keys %Count) { #iterate through characters
    my $p = $Count{$char}/$total; #prob of characters
    $H += $p * log($p); #p * log(p)
}
$H = -$H/log(2);##negate sum, convert base e to base 2
print "H = $H bits\n";

