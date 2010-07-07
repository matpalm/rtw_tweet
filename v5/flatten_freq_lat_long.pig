pts = load '$input' as (freq:float, x:float, y:float);    
pts2 = group pts by (x,y);
pts3 = foreach pts2 generate group as x_y, SUM(pts.freq) as freq ;
pts4 = foreach pts3 generate freq, x_y.x, x_y.y;
store pts4 into '$output';

