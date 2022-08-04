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

#We are only interested in motor vehicle sources. The idea is to check which SCC Level cotains Vechile in its name and use the lowest most level as a filter. 

mean(grepl("[Vv]ehicle", mrg$SCC.Level.One))
mean(grepl("[Vv]ehicle", mrg$SCC.Level.Two))
mean(grepl("[Vv]ehicle", mrg$SCC.Level.Three))
mean(grepl("[Vv]ehicle", mrg$SCC.Level.Four))

#We can see that the second level is the right one. Additionaly, consider only Baltimore and Los Angeles, respectively. 

motor <- mrg[grepl("[Vv]ehicle", mrg$SCC.Level.Three) & (mrg$fips == "24510" | mrg$fips == "06037"), ]
motor <- motor %>% mutate(city = case_when(fips == "24510" ~ "Baltimore", fips == "06037" ~ "Los Angeles"))
str(motor)

#Now, we sum the data based on the year and the city. 

agg <- aggregate(Emissions ~ year + city, data = motor, mean)

#We will plot two time series plots, based on the city. 

library(ggplot2)
png("plot6.png", height = 900, width = 1200)
g <- ggplot(data = agg, mapping = aes(year, Emissions, group = 1))
g + geom_line(aes(colour = city)) + facet_grid(city ~ .)
#+ scale_y_continuous(limits = quantile(motor$Emissions, c(0.1, 0.8))) 
dev.off()

#The emissions from vechiles has decreased in Baltimore, but it increased in 2008 in Los Angeles. 