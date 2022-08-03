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

#We can see that the third level is the right one. Additionaly, consider only Baltimore and Los Angeles, respectively. 

motor <- mrg[grepl("[Mm]otor", mrg$SCC.Level.Three) & (mrg$fips == "24510" | mrg$fips == "06037"), ]
motor <- motor %>% mutate(city = case_when(fips == "24510" ~ "Baltimore", fips == "06037" ~ "Los Angeles"))
str(motor)

#We will plot two boxplots, based on the city. 

png("plot6.png", height = 900, width = 1200)
g <- ggplot(data = motor, mapping = aes(city, Emissions))
g + geom_boxplot(outlier.shape = NA)  + scale_y_continuous(limits = quantile(motor$Emissions, c(0.1, 0.8))) 
dev.off()

#We can see that there is no significant difference in the median emission from motor vehicle sources between 
#Baltimore and LA, but LA tends to have 'heavier tails' which means that in LA we can observe more extreme values occasionaly. 