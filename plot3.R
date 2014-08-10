## set flag to continue given source data found
continue <- 1

## load the source data
## look for the original zip in our working directory.  if not there, check for the extracted file.
## if neither file present, set our flag to not continue and send a message as to why.
if (file.exists("exdata_data_household_power_consumption.zip")) {
  hpc_data <-read.table(unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt"), sep=";", header=TRUE)
} else if (file.exists("household_power_consumption.txt")) {
  hpc_data <-read.table("household_power_consumption.txt", sep=";", header=TRUE)
} else {
  continue <- 0
  stop("The exdata_data_household_power_consumption.zip or unzipped household_power_consumption.txt is not present")
}

## if our source data was found and loaded
if (continue == 1) {
  ## reduce data to between 2/1/2007 and 2/2/2007
  ## could just as easily have used hpc_data <- hpc_data[hpc_data$Date %in% c("1/2/2007","2/2/2007"),]
  ## but wanted to work off dates AS dates and not strings
  ## below basically says subtract 2/1/2007 from either 2/1/2007 or 2/2/2007 (leaving 0 or 1, if dates we want) and also
  ## further subtract 0.5 (leaving -0.5 or 0.5, if dates we want).  get absoulte of that (0.5 if dates we want)...
  hpc_data<-hpc_data[abs(as.numeric(as.Date(hpc_data$Date, format="%d/%m/%Y") - as.Date(ISOdate(2007,2,1))) - 0.5) == 0.5,]
  
  ## get the three sub-metering datasets as vectors
  hpc_sm1 <-as.numeric(as.vector(hpc_data$Sub_metering_1))
  hpc_sm2 <-as.numeric(as.vector(hpc_data$Sub_metering_2))
  hpc_sm3 <-as.numeric(as.vector(hpc_data$Sub_metering_3))
  
  ## create plot
  
  # per: https://class.coursera.org/exdata-005/forum/thread?thread_id=102
  # Q: Project 1/Plot 3 - plot in the png file is slightly different than on screen plot 
  # ---------------
  # A: Have you tried plotting directly to PNG (no dev.copy), to see if that fixes it?
  # I've heard from a couple of sources (one being the lecture) that dev.copy isn't 100% reliable...
  png('plot3.png')
  
  plot.ts(hpc_sm1, ylab="Energy sub-metering",xlab="",axes=FALSE)
  lines(hpc_sm2,col="red")
  lines(hpc_sm3,col="blue")
  axis(2)
  axis(1, at=seq(from=0,by=length(hpc_sm1)/2,to=length(hpc_sm1)), labels=c("Thu","Fri","Sat"))
  legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"), lwd=1)
  box()
  
  ## remember to turn off our png device
  dev.off()
  
  ## clean up data from memory
  rm(hpc_sm1)
  rm(hpc_sm2)
  rm(hpc_sm3)
  rm(hpc_data)
}

## clean up flag from memory
rm(continue)