# install.packages
#install.packages("leaflet")
#install.packages("rredis")

library(rredis)
redisConnect(port = 8002)

request_for_lat <- "us_del_1_lat"
request_for_lon <- "us_del_1_lon"
country <- "loc_us"

library(leaflet)
for (i in 1:103){
  LT <- as.double(redisHGet(key = country , field = request_for_lat))
  LN <- as.double(redisHGet(key = country , field =request_for_lon))
  print(LT)
  m <- leaflet() %>% addTiles() %>% addCircleMarkers(lat = LT, lng = LN)
  print(m)
  Sys.sleep(3)
}

