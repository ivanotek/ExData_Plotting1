#################################################################################################
## Peer-graded Assignment: Course Project 1
## Course Project for Exploratory Data Analysis - Week 1
##
## plot3.R that does the following.
##
## (0) Downloads the UC Irvine Machine Learning Repository dataset "Individual household
##     electric power consumption Data Set" cached copy and unzips it, if necessary
## (1) Extracts only a subset of measurements for 2 days (from 1/2/2007 to 2/2/2007)
## (2) Creates an Sub_metering_n timelines plot on a PNG device
##
#################################################################################################


#define target directory for dataset download
targetDir <- './data'               
#define dataset download URL
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists(targetDir) ) {
  dir.create(targetDir)
}
if(!file.exists("./data/household_power_consumption.txt")) {
  datasetZipFile <-file.path(targetDir, basename(fileURL))
  download.file(fileURL,destfile=datasetZipFile)
  # Unzip dataset to target directory
  unzip(zipfile=datasetZipFile,exdir=targetDir)
}

consumption <- read.csv(file="./data/household_power_consumption.txt", 
                 header=TRUE, 
                 sep=";",
                 na.strings = "?",
                 nrows=69520
                 )

consumption <- subset(consumption, Date == "1/2/2007" | Date == "2/2/2007")
consumption$datetime <- with(consumption, 
                             as.POSIXct(paste(Date, Time), 
                             format="%d/%m/%Y %H:%M:%S"))
dev.off()
png(filename="plot3.png", height=480, width=480, units = "px", bg = "transparent")
max_y <- max(consumption$Sub_metering_1, 
             consumption$Sub_metering_2, 
             consumption$Sub_metering_3)

plot(consumption$datetime, 
     consumption$Sub_metering_1, 
     type="n", 
     ylim=c(0,max_y),
     ylab="Energy sub metering", 
     xlab="")

lines(consumption$datetime, consumption$Sub_metering_1, type="l", col = "black")
lines(consumption$datetime, consumption$Sub_metering_2, type="l", col = "red")
lines(consumption$datetime, consumption$Sub_metering_3, type="l", col = "blue") 
legend("topright",
       legend=grep("^Sub_metering", names(consumption), value = TRUE), 
       col=c("black", "red", "blue"),
       cex=0.8,
       lty=c(1,1,1))

dev.off()