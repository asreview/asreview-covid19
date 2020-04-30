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

#make modifying json files into function to call
#wait until after everything is confirmed to work well!

#make statistics.json into nested list with elements for each version


#----------------------------------------------------
#URLs for COVID_preprints dataset
#version number is Figshare version
#date is date until which dataset is updated
url7 <- "https://ndownloader.figshare.com/articles/12033672/versions/7" #20200329
#url8 <- "https://ndownloader.figshare.com/articles/12033672/versions/8" #20200405
#url10 <- "https://ndownloader.figshare.com/articles/12033672/versions/10" #20200412
#url12 <- "https://ndownloader.figshare.com/articles/12033672/versions/12" #20200419
#url13 <- "https://ndownloader.figshare.com/articles/12033672/versions/13" #20200426


#set current version number and url
figshare_version <- 7
version <- 1
last_update <- "2020-03-29"
url <- url7

#read and extract zip file
getFiles(url)
#read csv file
df <- readFile()

#write as version
filename <- paste0("../datasets/preprints/covid19_preprints_v",
                   version,
                   ".csv")
write_csv(df, filename)

#also write as latest
filename <- paste0("../datasets/preprints/covid19-preprints_latest.csv")
write_csv(df, filename)


#--------------------------------------------------------------

#collect statistics for ASReview for full set and subset
statistics <- getStats(df)

#save and write as json
statistics_json <- toJSON(statistics, pretty = TRUE, auto_unbox = TRUE)
filepath_statistics <- paste0("output/statistics_preprints_v",
                              version,
                              ".json")
write(statistics_json, filepath_statistics)

#to do: make this into a list with elements for each subsequent version

#-------------------------------------------------------------

#modify JSON files
#NB streamline with functions after it has been confirmed to work in ASReview

#read json files (use 'latest' as basis for updates)
filepath_latest_preprints <- "../config/covid19-preprints/covid19_preprints_latest.json"

json_preprints <- fromJSON(filepath_latest_preprints)

#---------------------------------------------------------------
#one time modification to change fixed elements of 'latest' json files

json_old <- json_preprints

json_preprints$dataset_id <- "cord19-latest"
json_preprints$title <- "CORD-19 latest"
json_preprints$url <- "https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/preprints/covid19_preprints_latest.csv"

#json_all <- toJSON(json_all, pretty = TRUE, auto_unbox = TRUE)
#json_subset <- toJSON(json_subset, pretty = TRUE, auto_unbox = TRUE)

#write(json_all, filepath_latest_all)
#write(json_subset, filepath_latest_subset)


#-----------------------------------------------------------------------------------
#update info to latest version using data in 'statistics'

json_all$last_update <- last_update
json_all$statistics$n_papers <- statistics$all$n_papers
json_all$statistics$n_missing_title <- statistics$all$n_missing_title
json_all$statistics$n_missing_abstract <- statistics$all$n_missing_abstract

json_subset$last_update <- last_update
json_subset$statistics$n_papers <- statistics$subset$n_papers
json_subset$statistics$n_missing_title <- statistics$subset$n_missing_title
json_subset$statistics$n_missing_abstract <- statistics$subset$n_missing_abstract 


json_all <- toJSON(json_all, pretty = TRUE, auto_unbox = TRUE)
json_subset <- toJSON(json_subset, pretty = TRUE, auto_unbox = TRUE)

write(json_all, filepath_latest_all)
write(json_subset, filepath_latest_subset)

#-----------------------------------------------------------------
#modify 'latest' version to create version-specific json-files

json_all$dataset_id <- paste0("cord19-v", version)
json_all$title <- paste0("CORD-19 v", version)
json_all$url <- url

json_subset$dataset_id <- paste0("cord19-2020-v", version)
json_subset$title <- paste0("CORD-19 v", version, " since Dec. 2019")
json_subset$url <- paste0("https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/cord19_v",
                          version,
                          "_20191201.csv")

json_all <- toJSON(json_all, pretty = TRUE, auto_unbox = TRUE)
json_subset <- toJSON(json_subset, pretty = TRUE, auto_unbox = TRUE)

filepath_version_all <- paste0("../config/cord19-all/cord19_v",
                               version,
                               "_all.json")
filepath_version_subset <- paste0("../config/cord19-2020/cord19_v",
                                  version,
                                  "_20191201.json")


write(json_all, filepath_version_all)
write(json_subset, filepath_version_subset)

