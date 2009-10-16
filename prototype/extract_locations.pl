#!/usr/bin/env perl
while(<>) {
 next unless /"location"/;
 next if /"location":null/;
 next if /"location":""/;
 /"location":"(.*?)"/;
 print "$1\n";
}
