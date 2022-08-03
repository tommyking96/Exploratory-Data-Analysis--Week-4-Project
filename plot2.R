#Load the datasets

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)

#Change years from integers to factors

NEI$year <- factor(NEI$year)
str(NEI)

#Subset only for Baltimore

library(dplyr)
Baltimore <- NEI %>% subset(fips == "24510")

#Calculate the sum for every year in Baltimore

table <- tapply(Baltimore$Emissions, Baltimore$year, sum)
table

#Plotting and saving to png file

png("plot2.png", height = 900, width = 1200)
plot(levels(Baltimore$year), table, xlab = "Year", ylab = "Total PM2.5 emission in Baltimore")
dev.off()

#Based on the plot, it seems like the total PM2.5 emission decreased over the years in Baltimore, but we have an unexpected spike in 2005, so the answer might not be so significant. 
