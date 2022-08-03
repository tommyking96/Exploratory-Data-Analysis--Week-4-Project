#Load the datasets

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)

#Change "years" and "type" to factors

NEI$year <- factor(NEI$year)
NEI$type <- factor(NEI$type)
str(NEI)

#Merge SCC into NEI by SCC number in NEI

mrg <- merge(NEI, SCC, by.x = "SCC")
str(mrg)

#Let level four be strings instead of factors 

mrg$SCC.Level.Four <- as.character(mrg$SCC.Level.Four)
str(mrg)

#We take only the observations which have 'coal' implemented in SCC.Level.Four

coal <- mrg[grepl("[Cc]oal", mrg$SCC.Level.Four), ]

#Load ggplot2 and make the plot

library(ggplot2)

png("plot4.png", height = 900, width = 1200)
g <- ggplot(data = coal, mapping = aes(year, Emissions))
g + geom_point(alpha = 1/2, size = 10) 
dev.off()

#Based on the plot, we can see that the emissions from coal combustion-related sources decreased on avergae from 1999–2008
#(with the slight increase in 2005, but it doesn't affect the average)