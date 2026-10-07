#!/usr/bin/perl
# ⚠️ VERALTET: Verwenden Sie stattdessen: python3 WordlistGenerator.py
# Dieses Perl-Skript wird zu Referenzzwecken beibehalten.

use strict;
use warnings;

my $start = 1000000000000;
my $end = 9999000000000000;

my $count = 0;

# Größenschätzung (informativ)
my $diff = $end - $start;
printf "Generiere ~%d Passwörter (nach Filterung: ~%d)...\n", $diff, int($diff * 0.37);

while ($start < $end) {
    my $num = sprintf("%016d", $start);

    # Filter: Keine 3+ aufeinanderfolgende identischen Ziffern
    if ($num !~ /(\d)\1{2,}/) {
        print "$num\n";
        $count++;
    }

    $start++;
}

