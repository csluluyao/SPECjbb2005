#!/usr/bin/perl

use IO::Handle;

my $input_file = $ARGV[0];
my $path = $ARGV[1] . '/' if $ARGV[1];

my ($input_file_prefix, $input_file_postfix) = split ('\.', $input_file);
#my $file_prefix = "SPECjbb.";
my $file_prefix = $input_file_prefix . '_';
my $file_postfix = ".raw";

open FILE, $input_file or die "$input_file: $!\n";

while (<FILE>) {
    ($id, @prop) = split ('\.', $_);
    $prop = join ('.', @prop);
    next unless $id;
    if (int ($id)) {
        $text[$id] .= "$prop";
    }
    else {
        $text[0] .= "$prop";
    }
}

for ($i=1; $i<=$#text; $i++) {
    $ii = '0' . $i if $i < 100;
    $ii = '00' . $i if $i < 10;

    my $file_name = $path . $file_prefix . $ii . $file_postfix;
    my $fh = IO::Handle->new();
    open $fh, ">$file_name";
    print $fh $text[$i];
    print $fh $text[0];
    close $fh;
}
