set -x 
export HADOOP_STREAMING_JAR=$HADOOP_HOME/contrib/streaming/hadoop-*-streaming.jar
export BUCKET_SIZE=0.005

rm -rf lat_lons
# cant see to get pipes working in mapper defn, but using a temp script file works
echo "ruby extract_locations.rb | ruby extract_lat_longs_from_locations.rb" >> script
hadoop jar $HADOOP_STREAMING_JAR -mapper 'sh script' -reducer /bin/cat -input json_stream -output lat_lons

rm -rf x_y_points
hadoop jar $HADOOP_STREAMING_JAR -mapper ./lat_long_to_merc_and_bucket.rb -reducer /bin/cat -input lat_lons -output x_y_points -cmdenv BUCKET_SIZE=$BUCKET_SIZE

rm min_max freqs
pig -x local -f freqs.pig

./heat_map.rb min_max freqs $BUCKET_SIZE test.jpg
eog test.jpg
