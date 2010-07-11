#!/usr/bin/env bash
set -x

INPUT=bb_2010_06
TOP_N=500

cat $INPUT | ./lat_longs.rb | ./non_iphone_searches.rb > $INPUT.non_iphone_searchs
sort $INPUT.non_iphone_searchs | uniq -c | sort -nr > $INPUT.non_iphone_searchs.freq
head -n$TOP_N $INPUT.non_iphone_searchs.freq | tabify_uniq_out.rb | ./google_map_with_freq.rb > top.$TOP_N.html


