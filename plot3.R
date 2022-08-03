#Load the datasets

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)

#Change "years" and "type" to factors

NEI$year <- factor(NEI$year)
NEI$type <- factor(NEI$type)
str(NEI)

#Subset only for Baltimore

library(dplyr)
Baltimore <- NEI %>% subset(fips == "24510")

#Load ggplot2 and make the plot

library(ggplot2)

png("plot3.png", height = 900, width = 1200)
g <- ggplot(data = Baltimore, mapping = aes(year, Emissions))
g + geom_point(alpha = 1/2, aes( colour = type), size = 10) +  facet_grid(. ~ type )
dev.off()

#Based on the plot, we can see that non-road, non-point and on-road types have seen monotone decreases in emissions from 1999–2008 for Baltimore City.
#On the other hand, the point type is slighlty different, it experiences the growth from 1999 to 2005, and afterward it drastically decreases in 2008. 