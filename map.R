library(leaflet)
library(dplyr)
# setwd("~/Acute vs Chronic study_smart template system/")
Bgeusa <- read.csv("bgeusa.csv", header = TRUE, sep = ",", fill = TRUE, quote="\"")
#View(Bgeusa)
# leaflet()%>%addTiles()

Bgeusa<-Bgeusa%>%mutate(popup_info=paste(Name_batch,"<br/>", Affiliation,"<br/>", Title,"<br/>",City,"<br/>", State))
colors<-c("green","blue")
pal<-colorFactor(colors,Bgeusa$lon)
leaflet()%>%addTiles()%>%addCircleMarkers(data = Bgeusa, lat = ~lat, lng = ~lon, popup = ~popup_info, color = ~pal(lon))

