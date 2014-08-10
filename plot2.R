continue <- 1

## load data
if (file.exists("exdata_data_household_power_consumption.zip")) {
  hpc_data <-read.table(unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt"), sep=";", header=TRUE)
} else if (file.exists("household_power_consumption.txt")) {
  hpc_data <-read.table("household_power_consumption.txt", sep=";", header=TRUE)
} else {
  continue <- 0
  stop("The exdata_data_household_power_consumption.zip or unzipped household_power_consumption.txt is not present")
}

if (continue == 1) {
  ## reduce data to between 2/1/2007 and 2/2/2007
  hpc_data<-hpc_data[abs(as.numeric(as.Date(hpc_data$Date, format="%d/%m/%Y") - as.Date(ISOdate(2007,2,1))) - 0.5) == 0.5,]
  hpc_gap<-as.numeric(as.vector(hpc_data$Global_active_power))
  
  ## create plot
  
  # per: https://class.coursera.org/exdata-005/forum/thread?thread_id=102
  # Q: Project 1/Plot 3 - plot in the png file is slightly different than on screen plot 
  # ---------------
  # A: Have you tried plotting directly to PNG (no dev.copy), to see if that fixes it?
  # I've heard from a couple of sources (one being the lecture) that dev.copy isn't 100% reliable...
  png('plot2.png')
  
  plot.ts(hpc_gap, ylab="Global Active Power (kilowatts)",axes=FALSE,xlab="")
  axis(2)
  axis(1, at=seq(from=0,by=length(hpc_gap)/2,to=length(hpc_gap)), labels=c("Thu","Fri","Sat"))
  box()

  dev.off()
  
  rm(hpc_gap)
  rm(hpc_data)
}

rm(continue)