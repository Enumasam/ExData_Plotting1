## Please note: I took most of the code from the first parts of the assignment and modified it for this one.
## The script is largely (or exactly) the same until line 32.

## check if file is in working directory; if not, download and unzip file
if (!file.exists("./household_power_consumption.txt")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile = "household_power_consumption.zip")
  dateDownloaded <- date()
  unzip("household_power_consumption.zip")
}

## read data into r (despite the warning in the instructions, since it took only a few seconds on my computer)
alldata <- read.csv("household_power_consumption.txt", sep = ";", header = TRUE)

## subset - we need data for 01/02/2007 and 02/02/2007
## required data is in rows 66637 - 69516
subdata <- alldata[66637:69516,]

## instructions state NAs represented as ?s
## replace ?s with NAs using data.table package from Getting and Cleaning Data course
library(data.table)
subdata[subdata == "?"] <- NA

# remove variable alldata to free up memory (if necessary...)
remove(alldata)

## convert subdata$Global_active_power to numeric
## Note: When I used the as.numeric function alone, it changed the values in the data set (Ex. 0.326 became 127)
## A search on Stackoverflow revealed I needed to use as.character first. Though this can be accomplished in a
## single line of code, the script yielded the correct numbers only when I wrote theh functions in separate lines.

subdata$Global_active_power <- as.character(subdata$Global_active_power)
subdata$Global_active_power <- as.numeric(subdata$Global_active_power)

## Combine the date and time columns into a single variable
## Stackoverflow was helpful for the second line of code below
## See http://stackoverflow.com/questions/11609252/r-tick-data-merging-date-and-time-into-a-single-object
subdata$Date <- as.Date(subdata$Date,"%d/%m/%Y")
subdata$Date <- as.POSIXct(strptime(paste(subdata$Date, subdata$Time, sep = " "), "%Y-%m-%d %H:%M:%S"))


## Create PNG file with appropriate labels
library(datasets)
png(file = "plot2.png", width = 480, height = 480, units = "px")
plot(subdata$Global_active_power ~ subdata$Date, type="l", xlab= "", ylab="Global Active power (kilowatts)")
dev.off()
