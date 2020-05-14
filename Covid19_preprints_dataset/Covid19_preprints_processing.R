#Add subsequent versions of COVID-preprint dataset to ASREview

#COVID-preprint dataset:
#https://github.com/nicholasmfraser/covid19_preprints
#iterative versions archived on Figshare:
#https://doi.org/10.6084/m9.figshare.12033672

#install.packages("tidyverse")
#install.packages("jsonlite")
library(tidyverse)
library(jsonlite)

source("src/Covid19_preprints_import.R")
source("src/Covid19_preprints_get_stats.R")


#--------------------------------------------------------
#STILL TO DO

#make modifying json files into functions to call

#----------------------------------------------------
#URLs for COVID_preprints dataset
#url version number is Figshare version
#date is date until which dataset is updated
url7 <- "https://ndownloader.figshare.com/articles/12033672/versions/7" #20200329 v1
url8 <- "https://ndownloader.figshare.com/articles/12033672/versions/8" #20200405 v2
url10 <- "https://ndownloader.figshare.com/articles/12033672/versions/10" #20200412 v3
url12 <- "https://ndownloader.figshare.com/articles/12033672/versions/12" #20200419 v4
url13 <- "https://ndownloader.figshare.com/articles/12033672/versions/13" #20200426 v5
url14 <- "https://ndownloader.figshare.com/articles/12033672/versions/14" #20200503 v6
url16 <- "https://ndownloader.figshare.com/articles/12033672/versions/16" #20200510 v7

#set current version number and url
figshare_version <- 16
version <- 7
last_update <- "2020-05-10"
url <- url16

#read and extract zip file
getFiles(url)
#read csv file
df <- readFile()

#write as version
filename <- paste0("../datasets/covid19-preprints/covid19_preprints_v",
                   version,
                   ".csv")
write_csv(df, filename)

#also write as latest
filename <- paste0("../datasets/covid19-preprints/covid19-preprints_latest.csv")
write_csv(df, filename)


#--------------------------------------------------------------

#collect and store statistics for ASReview

#get stats for current version
statistics <- getStats(df)

#import statistics json file
filepath_statistics <- "output/statistics_preprints.json"
statistics_parent <- fromJSON(filepath_statistics)

#add stats for current version as named element to parent list
var <- paste0("v", version)
statistics_parent[[var]] <- statistics

#save and write as json
statistics_json <- toJSON(statistics_parent, pretty = TRUE, auto_unbox = TRUE)
write(statistics_json, filepath_statistics)


#-------------------------------------------------------------

#modify JSON file in ../scripts
#NB streamline with functions later

#read json files
filepath_preprints <- "../scripts/covid19-preprints.json"

json_preprints <- fromJSON(filepath_preprints)

#------------------------------------------------------------------------------
#update info with latest version

figshare_url <- paste0("https://doi.org/10.6084/m9.figshare.12033672.v",
                       figshare_version)

json_preprints_new <- json_preprints %>% 
  rbind(c(var, last_update, figshare_url))


#-----------------------------------------------------------------------------------
#write to file
json_preprints_new <- toJSON(json_preprints_new, pretty = TRUE, auto_unbox = TRUE)

write(json_preprints_new, filepath_preprints)


