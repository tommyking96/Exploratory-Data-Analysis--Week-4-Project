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

#We are only interested in motor vehicle sources. The idea is to check which SCC Level cotains Motor in its name and use the upper most level as a filter. 

mean(grepl("[Mm]otor", mrg$SCC.Level.One))
mean(grepl("[Mm]otor", mrg$SCC.Level.Two))
mean(grepl("[Mm]otor", mrg$SCC.Level.Three))
mean(grepl("[Mm]otor", mrg$SCC.Level.Four))

#We can see that the third level is the right one. Additionaly, consider only Baltimore

motor <- mrg[grepl("[Mm]otor", mrg$SCC.Level.Three) & mrg$fips == "24510", ]

#Plotting the required

png("plot5.png", height = 900, width = 1200)
g <- ggplot(data = motor, mapping = aes(year, Emissions))
g + geom_boxplot(outlier.shape = NA)  + scale_y_continuous(limits = quantile(motor$Emissions, c(0.1, 0.9))) 
dev.off()

#We can see that the emissions from motor vehicle sources did not change much from 1999–2008 in Baltimore City if we exclude the outliers in 2002 and 2005.
#In other words, we observe the decrease from 1999 to 2005, and then the increase. 