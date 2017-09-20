install.packages("jsonlite")
library(jsonlite)
library(plyr)

data <- fromJSON("location.json")
  

locs <- data$locations

names(locs)
ldf <- data.frame(t=rep(0,nrow(locs)))

# Time is in POSIX * 1000 (milliseconds) format, convert it to useful scale...
ldf$t <- as.numeric(locs$timestampMs)/1000
class(ldf$t) <- 'POSIXct'

# Convert longitude and lattitude 
ldf$lat <- as.numeric(locs$latitudeE7/1E7)
ldf$lon <- as.numeric(locs$longitudeE7/1E7)

# Accuracy doesn't need changing.
ldf$accuracy <- locs$accuracy


# Velocity, altitude and heading need no alteration:
ldf$velocity <- locs$velocity
ldf$altitude <- locs$altitude
ldf$heading <- locs$heading


require(ggplot2) #install these packages if you haven't done so
require(ggmap)



ldfSummer <- ldf[29627:153800,] 
ldfGradSchool <- ldf[10438:848405,]
ldfGradSchool$ID <- 1:nrow(ldfGradSchool)
ldfSummer$ID <- 1:nrow(ldfSummer) #creating a new column for creating a gradient of colors based on time (not actual timestamp / not accurate)



Austin <- get_map(c(-97.7431,30.2672), zoom = 13,source='stamen',maptype="watercolor") #watercolor, terrain, toner are options

Campus <- get_map(c(-97.737658, 30.286248), zoom = 15,  source = 'stamen', maptype = "toner")
USA <- get_map(c(-108.239,40.410), zoom = 4, source = 'stamen', maptype = "watercolor")
USA <- get_map(c(-108.239,40.410), zoom = 4, source = 'stamen', maptype = "terrain") #depending on what map type you want

nattyparks <- read.csv("~/desktop/LocationMaps/natty.csv", header = TRUE)


ggmap(Austin) + geom_point(data=ldf,aes(lon,lat),color="SteelBlue", alpha = .01) + 
  ggtitle("Austin, Tx") + xlab(" ") + ylab(" ")  


ggmap(Austin, darken = c(0.45, "white")) + 
  geom_point(data=ldfGradSchool,aes(lon,lat),color = "RoyalBlue", alpha = .12, size = 1) 
  #GradSchoolAustin #darken function lowers the opacity of the map

ggmap(Campus) + geom_point(data=ldfGradSchool,aes(lon,lat),color = "SteelBlue", alpha = .15, size = 1) 
  #GradSchoolCampus

 ggmap(USA) + geom_point(data=ldfSummer,aes(lon,lat),color="SteelBlue", alpha = .03, size = 4) + 
  ggtitle("Summer") + xlab(" ") + ylab(" ")  + 
  geom_point(data = nattyparks, aes(lon, lat), color = "skyblue", size =4, alpha= .8, shape = 1, stroke = 3) # Trip



ggmap(USA) + geom_point(data=ldfSummer,aes(lon,lat),color= accuracy, alpha = .03, size = 4) + 
  ggtitle("Summer") + xlab(" ") + ylab(" ")  + 
  geom_point(data = nattyparks, aes(lon, lat), color = "skyblue", size =4, alpha= .8, shape = 1, stroke = 3) #Trip


