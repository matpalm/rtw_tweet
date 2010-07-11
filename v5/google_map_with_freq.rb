#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

SCALE_FACTOR = 1e3

class Float
  def scaled
    (self.to_f * SCALE_FACTOR).ceil / SCALE_FACTOR
  end
end

def gLatLong(lat,long)
  "new GLatLng(#{lat},#{long})"
end

puts <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps API Sample</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAA1XbMiDxx_BTCY2_FkPh06RRaGTYH6UMl8mADNa0YKuWNNa8VNxQEerTAUcfkyrr6OwBovxn7TDAH5Q"></script>
    <script type="text/javascript">
    
    function poly(b) {  
      return new GPolygon([new GLatLng(b[0],b[1]),new GLatLng(b[0],b[3]),new GLatLng(b[2],b[3]),new GLatLng(b[2],b[1]),new GLatLng(b[0],b[1])], "#"+b[4]+"0000",2,1,"#ff0000",0);
    }

function initialize() {
  if (GBrowserIsCompatible()) {
    var map = new GMap2(document.getElementById("map_canvas"));
    map.enableScrollWheelZoom();
    map.addControl(new GLargeMapControl());
EOF

pts = []
min_freq = max_freq = nil

STDIN.each do |line|
  freq,lat1,long1,lat2,long2 = line.chomp.split("\t").map{|v|v.to_f.scaled}
  freq = Math.log(freq)
  raise "expected lat/long pairs to NOT be equal [#{line}]" if lat1==lat2 || long1==long2
  raise "expected lat/long1 to be GREATER thatn lat1/long2 [#{line}]" unless lat1>lat2 && long1>long2

  if min_freq.nil?
    min_freq = max_freq = freq
  else
    min_freq = freq if freq < min_freq
    max_freq = freq if freq > max_freq
  end

  # draw bounding box used in search
  pts << [lat1,long1,lat2,long2,freq].map(&:scaled)
end

# rescale freq from current min,max to 22->ff for red border colour
diff_freq = max_freq - min_freq
pts.each {|pt| pt[4] = sprintf("%02x",(((pt[4]-min_freq)/diff_freq)*255)) }

# emit bounding boxes
puts "bs=#{pts.reverse.inspect};"

# write the postamble
puts <<EOF
    for(i=0;i<bs.length;i++) {
      map.addOverlay(poly(bs[i]));
    }
    map.setCenter(new GLatLng(0,0), 2);
  }
}
    </script>
  </head>
  <body onload="initialize()" onunload="GUnload()" style="font-family: Arial;border: 0 none;">
    <div id="map_canvas" style="width: 100%; height: 800px"></div>
  </body>
</html>
EOF
