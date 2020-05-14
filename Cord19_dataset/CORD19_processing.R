#Add dates to CORD19 dataset (missing and/or non-formatted dates)
#Create subset of records from Dec 2019 onwards
#Current version: v10 dd 20200501

#info on CORD19 dataset:
##https://www.semanticscholar.org/cord19/download

#install.packages("tidyverse")
#install.packages("rcrossref")
#install.packages("europepmc")
#install.packages("lubridate")
library(tidyverse)
library(jsonlite)

source("src/CORD19_import.R")
source("src/CORD19_create_subset.R")
source("src/CORD19_get_stats.R")

#set email in Renviron
file.edit("~/.Renviron")
#add email address to be shared with Crossref:
#crossref_email = name@example.com


#--------------------------------------------------------
#STILL TO DO

#make modifying json files into function to call
#wait until after everything is confirmed to work well!

#----------------------------------------------------
#URLs for CORD19 dataset
url3 <- "https://zenodo.org/record/3715506/files/all_sources_metadata_2020-03-13.csv" #20200313
url4 <- "https://zenodo.org/record/3727291/files/metadata.csv" #20200320
url5 <- "https://zenodo.org/record/3731937/files/metadata.csv" #20200327
url6 <- "https://zenodo.org/record/3739581/files/metadata.csv" #20200403
url7 <- "https://zenodo.org/record/3748055/files/metadata.csv" #20200410
url8 <- "https://zenodo.org/record/3756191/files/metadata.csv" #20200417
url9 <- "https://zenodo.org/record/3765923/files/metadata.csv" #20200424
url10 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-05-01/metadata.csv" #20200501
url11 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-05-12/metadata.csv" #20200512

#set current version number and url
version <- 11
last_update <- "2020-05-12"
url <- url11

#---------------------------------------------

#inspect first lines of full dataset to view columns
CORD19 <- seeCORDfull(url)

#read full dataset, set number of columns to character, to read all values in
CORD19 <- getCORDfull(url)

#Add date columns - setting date format will only keep properly formatted entries
CORD19 <- CORD19 %>%
  mutate(date = as.Date(publish_time))

#--------------------------------------------------------
#create subset from 20191201
CORD19_201912 <- getSubset(CORD19)

#write as version
filename <- paste0("../datasets/cord19-2020/cord19_v",
                   version,
                   "_20191201.csv")
write_csv(CORD19_201912, filename)

#also write as latest
filename <- paste0("../datasets/cord19-2020/cord19_latest_20191201.csv")
write_csv(CORD19_201912, filename)


#----------------------------------------------------------

#collect statistics for ASReview for full set and subset
statistics <- getStats(CORD19, CORD19_201912)

#import statistics json file
filepath_statistics <- "output/statistics.json"
statistics_parent <- fromJSON(filepath_statistics)

#add stats for current version as named element to parent list
var <- paste0("v", version)
statistics_parent[[var]] <- statistics

#save and write as json
statistics_json <- toJSON(statistics_parent, pretty = TRUE, auto_unbox = TRUE)
write(statistics_json, filepath_statistics)

#-------------------------------------------------------------

#modify JSON files in ../scripts
#NB streamline with functions after it has been confirmed to work in ASReview

#read json files (use 'latest' as basis for updates)
filepath_all <- "../scripts/cord19-all.json"
filepath_subset <- "../scripts/cord19-2020.json"

json_all <- fromJSON(filepath_all)
json_subset <- fromJSON(filepath_subset)

#------------------------------------------------------------------------------
#update info with latest version

json_all_new <- json_all %>% 
  rbind(c(var, last_update, url))

json_subset_new <- json_subset %>%
  rbind(c(var, last_update))

#-----------------------------------------------------------------------------------
#write to file
json_all_new <- toJSON(json_all_new, pretty = TRUE, auto_unbox = TRUE)
json_subset_new <- toJSON(json_subset_new, pretty = TRUE, auto_unbox = TRUE)

write(json_all_new, filepath_all)
write(json_subset_new, filepath_subset)
