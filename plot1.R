#Load the datasets

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)

#Change years from integers to factors

NEI$year <- factor(NEI$year)
str(NEI)

#Calculate the sum for every year

table <- tapply(NEI$Emissions, NEI$year, sum)
table

#Plotting and saving to png file

png("plot1.png", height = 300, width = 400)
plot(levels(NEI$year), table, xlab = "Year", ylab = "Total PM2.5 emission", type = "b", pch = 20, ylim = c(3e+06, 8e+06))
text(levels(NEI$year), table + 500000, labels = c("1999", "2002", "2005", "2008"))
dev.off()

#Based on the plot, it seems like the total PM2.5 emission decreased over the years. 


