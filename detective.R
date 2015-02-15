rm(list=ls(all=T))

library("zoo")

data = read.csv("./input/data.csv" , header=T)
out_file = "./output/anomaly.csv"

window_size = 5
dimension = ncol(data)
rows = nrow(data)
high_factor = 1.414
low_factor = 0.586

anomaly = data
anomaly[,-1] = 0

for(j in 2:dimension)
{
  threshold_high_list = rep(0, window_size-1)
  threshold_low_list = rep(0, window_size-1)
  
  min_offset = min(data[,j])
  
  running = ((0.35 * rollmedian(data[,j], window_size, align=c("right"), na.pad=TRUE))
             + (0.25 * rollmean(data[,j], window_size, align=c("right"), na.pad=TRUE))
             + (0.4 * mean(data[window_size:rows,j]))) - min_offset
  for(i in window_size:rows){
    threshold_high = (running[i] * high_factor) + min_offset
    threshold_low = (running[i] * low_factor) + min_offset
    threshold_high_list = c(threshold_high_list, threshold_high)
    threshold_low_list = c(threshold_low_list, threshold_low)    
    if(data[i, j] > threshold_high)
      anomaly[i,j] = 1
    else if(data[i, j] < threshold_low)
      anomaly[i,j] = 1
    else
      anomaly[i,j] = 0
  }
  
  pdf(file=paste("./output/", colnames(data)[j],".pdf",sep=""))
  plot(data[,j], xaxt = 'n', col=(anomaly[,j]+1), type="l", xlab="Date", ylab=colnames(data)[j], 
       ylim=c(0, max(data[, j],threshold_high_list)))
  axis(1, at=1:rows, labels=data[,1])
  lines(matrix(c(1:rows, threshold_high_list), ncol=2, byrow=FALSE), col=2)
  lines(matrix(c(1:rows, threshold_low_list), ncol=2, byrow=FALSE), col=3)
  dev.off()
}

write.csv(anomaly, file=out_file, row.names=FALSE)