library(sp)
library(rgdal)

yemen <- read.csv("d:/Documents/persoonlijk/WFP_hackathon/Yemen/mVAM/Data/YEM_WFP_mVAM_RawData.csv", sep=",")

unique(yemen$SvyDate)
unique(yemen$ADM1_NAME)
unique(yemen$ADM2_NAME)

adm2 <- readOGR("d:/Documents/persoonlijk/WFP_hackathon/extra_data/yem_bnd_adm2/yem_bnd_adm2.shp", "yem_bnd_adm2")

toupper(unique(adm2$DistrictNa))

table(as.character(yemen$ADM2_NAME) %in% toupper(unique(adm2$DistrictNa)))

date1 <- yemen[which(yemen$SvyDate == unique(yemen$SvyDate[1])),]
dists <- as.character(unique(yemen[as.character(yemen$ADM2_NAME) %in% toupper(unique(adm2$DistrictNa)),"ADM2_NAME"]))


install.packages("GISTools")
library(GISTools)
sids <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], 
                      proj4string=CRS("+proj=longlat +ellps=clrk66"))
class(adm2)
plot(sids)
writeSpatialShape(sids, "sids")
cents <- coordinates(adm2)
cents <- SpatialPointsDataFrame(coords=cents, data=adm2@data) 
                                proj4string=CRS("+proj=longlat +ellps=clrk66"))
points(cents, col = "Blue")

adm2@data$NAME <- toupper(adm2$DistrictNa)
yemen$X <- NA
yemen$Y <- NA

for (i in 1:nrow(yemen)){
  if (yemen[i,"ADM2_NAME"] %in% adm2$NAME){
yemen[i,c("X","Y")] <- adm2@data[which(as.character(yemen$ADM2_NAME[i]) == adm2$NAME), c("X","Y")]
  }
}

yemen

yemenFilt <- yemen[which(!is.na(yemen$X)),]
write.csv(yemenFilt, "d:/Documents/persoonlijk/WFP_hackathon/processed_data/yemen_mvam_inc_coords/yemen_mvam_inc_coords.csv", sep=",")

date1 <- yemenFilt[which(yemen$SvyDate == unique(yemen$SvyDate[1])),]

UTM <- CRS("+init=epsg:2090")
WGS <- CRS("+init=epsg:4326")
date1sp <- SpatialPointsDataFrame(date1[,c("X","Y")], date1, proj4string=WGS)
yemensp <- SpatialPointsDataFrame(yemenFilt[,c("X","Y")], yemenFilt, proj4string=WGS)
yemenUTM <- spTransform(yemensp,UTM)
adm2UTM <- spTransform(adm2,UTM)

yemenFilt$X_norm <- as.vector((coordinates(yemenUTM)[,1] - bbox(adm2UTM)[1,1]) / (bbox(adm2UTM)[1,2] - bbox(adm2UTM)[1,1]) * 2 - 1)
yemenFilt$Y_norm <- as.vector((coordinates(yemenUTM)[,2] - bbox(adm2UTM)[2,1]) / (bbox(adm2UTM)[2,2] - bbox(adm2UTM)[2,1]) * 2 - 1)

date_norm <- seq(-1,1,2/(nlevels(yemenFilt$SvyDate)-1))
yemenFilt$date_norm <- NA
for (i in 1:nrow(yemenFilt)){
yemenFilt$date_norm[i] <- date_norm[which(yemenFilt$SvyDate[i] == unique(yemenFilt$SvyDate))]
}
yemenFilt$FCS_norm <- as.vector((yemenFilt$FCS - 0) / (max(yemenFilt$FCS) - 0) * 2 - 1)
yemenFilt$rCSI_norm <- as.vector((yemenFilt$rCSI - 0) / (max(yemenFilt$rCSI) - 0) * 2 - 1)

write.csv(yemenFilt, "d:/Documents/persoonlijk/WFP_hackathon/processed_data/yemen_mvam_inc_coords/yemen_mvam_normalized.csv", sep=",")

