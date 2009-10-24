pts = load 'x_y_points/*' as (timeslice:chararray, x:float, y:float); 
timeslices = group pts by timeslice;
timeslices_freq = foreach timeslices { generate group, SIZE(pts) as freq; } 
store timeslices_freq into 'timeslices_freq.latlon';
