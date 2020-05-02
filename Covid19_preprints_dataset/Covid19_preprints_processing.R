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
#wait until after everything is confirmed to work well!

#----------------------------------------------------
#URLs for COVID_preprints dataset
#url version number is Figshare version
#date is date until which dataset is updated
url7 <- "https://ndownloader.figshare.com/articles/12033672/versions/7" #20200329 v1
url8 <- "https://ndownloader.figshare.com/articles/12033672/versions/8" #20200405 v2
url10 <- "https://ndownloader.figshare.com/articles/12033672/versions/10" #20200412 v3
url12 <- "https://ndownloader.figshare.com/articles/12033672/versions/12" #20200419 v4
url13 <- "https://ndownloader.figshare.com/articles/12033672/versions/13" #20200426 v5

#set current version number and url
figshare_version <- 7
version <- 1
last_update <- "2020-03-29"
url <- url7

#read and extract zip file
getFiles(url)
#read csv file
df <- readFile()

#clean abstracts
#remove jats-tags, remove trailing "Abstract"

df_abstract <- df %>%
  mutate(abstract2 = abstract)


#write as version
filename <- paste0("../datasets/preprints/covid19_preprints_v",
                   version,
                   ".csv")
write_csv(df, filename)

#also write as latest
filename <- paste0("../datasets/preprints/covid19-preprints_latest.csv")
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

#modify JSON files
#NB streamline with functions after it has been confirmed to work in ASReview

#read json files (use 'latest' as basis for updates)
filepath_latest_preprints <- "../config/covid19-preprints/covid19_preprints_latest.json"

json_preprints <- fromJSON(filepath_latest_preprints)


#-----------------------------------------------------------------------------------
#update info to latest version using data in 'statistics'

json_preprints$last_update <- last_update
json_preprints$statistics$n_papers <- statistics$preprints$n_papers
json_preprints$statistics$n_missing_title <- statistics$preprints$n_missing_title
json_preprints$statistics$n_missing_abstract <- statistics$preprints$n_missing_abstract


json_preprints_file <- toJSON(json_preprints, pretty = TRUE, auto_unbox = TRUE)

write(json_preprints_file, filepath_latest_preprints)


#-----------------------------------------------------------------
#modify 'latest' version to create version-specific json-files


figshare_url <- paste0("https://doi.org/10.6084/m9.figshare.12033672.v",
                       figshare_version)

json_preprints$dataset_id <- paste0("covid19-preprints-v", version)
json_preprints$title <- paste0("Covid19 preprints v", version)
json_preprints$link <- figshare_url
json_preprints$url <- paste0("https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/preprints/covid19_preprints_v",
                             version,
                             ".csv")

json_preprints_file <- toJSON(json_preprints, pretty = TRUE, auto_unbox = TRUE)

filepath_version_preprints <- paste0("../config/covid19-preprints/covid19_preprints_v",
                               version,
                               ".json")


write(json_preprints_file, filepath_version_preprints)

#------------------------------------------------------------------
#update index.json

filepath_index_preprints <- "../config/covid19-preprints/index.json"
json_index_preprints <- fromJSON(filepath_index_preprints)

filenames_preprints <- json_index_preprints$filenames
filenames_preprints_new <- paste0("covid19_preprints_v", version, ".json")
filenames_preprints <- append(filenames_preprints, filenames_preprints_new)
json_index_preprints$filenames <- filenames_preprints

json_index_preprints <- toJSON(json_index_preprints, pretty = TRUE, auto_unbox = TRUE)
write(json_index_preprints, filepath_index_preprints)