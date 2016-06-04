# Prepare

setwd("~/git/utilities/data")

# Libraries
library(dplyr)
library(reshape2)
library(lubridate)
library(ggplot2)
library(caret)
#library(sqldf)
#library(GGally)



## RAINFALL DATA

# Read and preprocess 

files_list <- dir('yemen_rainfall', full.names=TRUE)

df_rainfall <- data.frame()
for (file in files_list) {
    df_rainfall_file <- read.csv(file)
    df_rainfall_file['file'] <- file
    df_rainfall <- rbind(df_rainfall, df_rainfall_file)
}

getyear <- function(string) {gsub(".csv", "", gsub(".*Rainfall", "", string))}
getregion <- function(string) {gsub(".* - ", "", gsub("_Rainfall.*", "", string))}

df_rainfall['Year'] <- apply(df_rainfall['file'], 1, getyear)
df_rainfall['ADM1_NAME'] <- apply(df_rainfall['file'], 1, getregion)
df_rainfall$Year <- as.integer(df_rainfall$Year)
df_rainfall['Rainfall_mm'] <- df_rainfall$Rainfall..mm.

df_rainfall <- aggregate(Rainfall_mm ~ Year + Month + ADM1_NAME, df_rainfall, FUN=sum)

removespecialchars <- function(x) {gsub("[[:punct:]]", "", x)}
df_rainfall['ADM1_NAME'] <- apply(df_rainfall['ADM1_NAME'], 1, removespecialchars)



# Export

write.csv(df_rainfall, "processed/rainfall_yemen.csv", row.names = FALSE)



## MVAM -> TODO

dir('processed', full.names=TRUE)
df_mvam <- read.csv('processed/yemen_mvam_normalized.csv')



# Add variable to df_mvam with rainfall in previous nth month


#getyearfromsvydate <- function(svydate) {gsub("[0-9][0-9][a-z][a-z][a-z]", "", svydate)}
#getmonthfromsvydate <- function(svydate) {gsub("[0-9][0-9][0-9][0-9]", "", gsub("^[0-9][0-9]", "", svydate))}

dmy("01dec2015")

df_mvam$SvyDate
df_mvam$newdate <- apply(df_mvam['SvyDate'], 1, dmy)

dmy(df_mvam['SvyDate'][1,])



## MERGE MVAM AND RAINFALL

df_merged <- merge(df_mvam , df_rainfall, by.x="ADM1_NAME", by.y="ADM1_NAME")

df_merged <- merge(df_mvam , df_rainfall)

df_merged

names(df_mvam)
names(df_rainfall)
"ADM1_NAME" %in% names(df_mvam)





removespecialchars("alskdjfI*Y3kjeh")


