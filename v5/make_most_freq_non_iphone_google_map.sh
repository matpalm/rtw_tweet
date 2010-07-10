#!/usr/bin/env bash
set -x

cat bb_2010_06 | ./lat_longs.rb | ./non_iphone_searches.rb > bb_2010_06.non_iphone_searchs
sort bb_2010_06.non_iphone_searchs | uniq -c | sort -nr > bb_2010_06.non_iphone_searchs.freq
head -n500 bb_2010_06.non_iphone_searchs.freq | ./google_map_wip_script.rb > top.500.html


