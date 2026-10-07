#!/usr/bin/perl
=head1 NAME

WordlistGenerator.perl - WPA2-FritzBox Passwort-Wortlisten-Generator

=head1 DESCRIPTION

Generiert 16-stellige numerische Passwörter für WPA2-Brute-Force-Angriffe
auf FritzBox und ähnliche Router. Filtert Passwörter mit 3+ aufeinanderfolgenden
identischen Ziffern (die FritzBox verwendet diese nicht).

=head1 USAGE

    perl WordlistGenerator.perl
    perl WordlistGenerator.perl > wordlist.txt
    perl WordlistGenerator.perl --resume

=head1 PERFORMANCE

Laufzeit: ~1-2 Stunden (je nach CPU)
Output: ~3,7 Milliarden Passwörter (~60 GB unkomprimiert)

=cut

use strict;
use warnings;
use Getopt::Long;

# Konstanten
my $START       = 1000000000000;
my $END         = 9999000000000000;
my $CHUNK_SIZE  = 100000;
my $OUTPUT_DIR  = 'wlist';
my $BUFFER_SIZE = 10000;

# Globale Variablen
my $resume_mode = 0;
my $start_num   = $START;
my $count       = 0;
my @buffer      = ();
my $current_file = '';
my $file_handle;

# Parse command-line options
GetOptions(
    'resume|r' => \$resume_mode,
    'help|h'   => sub { print_help(); exit 0; },
) or die "Fehler: Ungültige Optionen\n";

# Initialisierung
setup_output_dir();
if ($resume_mode) {
    $start_num = get_resume_point();
}

# Main Loop
generate_passwords($start_num, $END);

# Cleanup
flush_buffer();
close_file() if defined $file_handle && fileno($file_handle);

print STDERR "\n✓ Fertig! $count Passwörter generiert.\n" if $count > 0;
exit 0;

# ============================================================================
# SUBROUTINES
# ============================================================================

sub setup_output_dir {
    # Setup output directory wenn nicht im Pipe-Modus
    return if -t STDOUT();

    mkdir $OUTPUT_DIR unless -d $OUTPUT_DIR;
}

sub get_resume_point {
    # Findet die letzte Zahl aus den existierenden Dateien
    return $START unless -d $OUTPUT_DIR;

    my @files = glob("$OUTPUT_DIR/fritz*.txt");
    return $START unless @files;

    # Sortiere numerisch: fritz0.txt, fritz1.txt, ..., fritz99999.txt
    @files = sort {
        my ($a_num) = $a =~ /fritz(\d+)\.txt/;
        my ($b_num) = $b =~ /fritz(\d+)\.txt/;
        ($b_num || 0) <=> ($a_num || 0);
    } @files;

    my $last_file = $files[0];

    # Lese die letzte Zahl aus der letzten Datei
    if (open my $fh, '<', $last_file) {
        my $last_line;
        while (<$fh>) {
            chomp;
            next unless /^\d{16}$/;
            $last_line = $_;
        }
        close $fh;

        return $last_line if defined $last_line;
    }

    return $START;
}

sub generate_passwords {
    # Hauptloop: Generiert gefilterte 16-stellige Passwörter
    my ($start, $end) = @_;

    print STDERR "Starte bei: $start\n";
    printf STDERR "Größenschätzung: ~%.0f Millionen Passwörter (nach Filter)\n",
        (($END - $START) / 1_000_000) * 0.37;

    my $regex = qr/(\d)\1{2,}/;

    for (my $i = $start; $i < $end; $i++) {
        my $num = sprintf("%016d", $i);

        unless ($num =~ $regex) {
            add_to_buffer($num);
            $count++;

            if ($count % 100000 == 0) {
                printf STDERR "[%d] %s\n", $count, $num;
            }
        }
    }
}

sub add_to_buffer {
    # Puffert Passwort und schreibt bei Überschuss
    my ($password) = @_;

    push @buffer, $password;

    if (@buffer >= $BUFFER_SIZE) {
        flush_buffer();
    }
}

sub flush_buffer {
    # Schreibt gepufferte Passwörter in Datei oder STDOUT
    return unless @buffer;

    if (-t STDOUT()) {
        # Pipe-Modus: Schreibe zu STDOUT
        foreach my $pwd (@buffer) {
            print "$pwd\n";
        }
    } else {
        # Datei-Modus: Splitten und schreiben
        foreach my $pwd (@buffer) {
            my $chunk_id = int($pwd / $CHUNK_SIZE);
            my $filename = "$OUTPUT_DIR/fritz$chunk_id.txt";

            if ($filename ne $current_file) {
                close_file() if defined $file_handle;
                open_file($filename);
                $current_file = $filename;
            }

            print $file_handle "$pwd\n" or warn "Schreibfehler: $!\n";
        }
    }

    @buffer = ();
}

sub open_file {
    # Öffnet Datei im Append-Modus
    my ($filename) = @_;

    open $file_handle, '>>', $filename
        or die "Fehler beim Öffnen von $filename: $!\n";
}

sub close_file {
    # Schließt aktuelle Datei
    return unless defined $file_handle && fileno($file_handle);
    close $file_handle or warn "Fehler beim Schließen: $!\n";
}

sub print_help {
    # Zeigt Hilfe an
    print <<'EOF';
WPA2-FritzBox Passwort-Wortlisten-Generator (Perl)

USAGE:
    perl WordlistGenerator.perl [OPTIONS]

OPTIONS:
    --resume, -r    Resume: Findet letzte Zahl und setzt fort
    --help, -h      Zeigt diese Hilfe

EXAMPLES:
    # Generiere Standard-Wortliste in wlist/
    perl WordlistGenerator.perl

    # Resume nach Unterbrechung
    perl WordlistGenerator.perl --resume

    # Pipe zu STDOUT (nur Nummern)
    perl WordlistGenerator.perl | head -100

PERFORMANCE:
    Laufzeit: ~1-2 Stunden
    Output:   ~3,7 Mrd Passwörter (~60 GB)
    Filter:   Keine 3+ aufeinanderfolgenden Ziffern

FILTER-BEISPIELE:
    ✅ GÜLTIG:   1234567890123456, 0101010101010101
    ❌ UNGÜLTIG: 0000000000000000, 1111111111111111, 1234000123456789

EOF
}

__END__
