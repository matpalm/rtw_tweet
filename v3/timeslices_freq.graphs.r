d = read.delim('timeslices_freq.latlon', header=FALSE)
data.ll = d[order(d$V1),]
d = read.delim('timeslices_freq.all', header=FALSE)
data.all = d[order(d$V1),]
d1 = data.ll$V2
d1 = d1 - min(d1)
d1 = d1 / max(d1)
d2 = data.all$V2
d2 = d2 - min(d2)
d2 = d2 / max(d2)

jpeg("timeslices_freq.scatter.jpg", width = 400, height = 480)
plot(d1, d2, xlab="with lat lon", ylab="all")
slope = 1
intercept = 0
abline(intercept,slope)
dev.off()

jpeg("timeslices_freq.comparison.jpg", width = 750, height = 480)
plot(d1,type='l', col='red', lwd=3, xlab="time of day (GMT0)", ylab="proportion of tweets", axes=FALSE)
title("time of tweets")
axis(1,at=c(0:12)*12,labels=c("00:00","02:00","04:00","06:00","08:00","10:00","12:00","14:00","16:00","18:00","20:00","22:00","24:00"))
axis(2)
lines(d2,col='blue',lwd=3)
legend(120,0.15, c("with lat lon","all"), lty=1, col=c("red","blue"), lwd=3, bty="n") 
dev.off()
