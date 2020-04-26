#Add dates to CORD19 dataset (missing and/or non-formatted dates)
#Create subset of records from Dec 2019 onwards
#Current version: v9 dd 20200424

#info on CORD19 dataset:
##https://www.semanticscholar.org/cord19/download

#install.packages("tidyverse")
#install.packages("rcrossref")
#install.packages("europepmc")
#install.packages("lubridate")
library(tidyverse)
library(rcrossref)
library(europepmc)
library(lubridate)
library(jsonlite)

source("src/CORD19_import.R")
source("src/CORD19_match_dois.R")
source("src/CORD19_match_PMCID.R")
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
#url3 <- "https://zenodo.org/record/3715506/files/all_sources_metadata_2020-03-13.csv" #20200313
#url4 <- "https://zenodo.org/record/3727291/files/metadata.csv" #20200320
#url5 <- "https://zenodo.org/record/3731937/files/metadata.csv" #20200327
#url6 <- "https://zenodo.org/record/3739581/files/metadata.csv" #20200403
#url7 <- "https://zenodo.org/record/3748055/files/metadata.csv" #20200410
#url8 <- "https://zenodo.org/record/3756191/files/metadata.csv" #20200417
url9 <- "https://zenodo.org/record/3765923/files/metadata.csv" #20200424


#set current version number and url
version <- 9
last_update <- "2020-04-24"
url <- url9

#---------------------------------------------

#inspect first lines of full dataset to view columns
#CORD19 <- seeCORDfull(url)

#read full dataset, set number of columns to character, to read all values in
CORD19 <- getCORDfull(url)

#Add date columns - setting date format will only keep properly formatted entries
CORD19 <- CORD19 %>%
  mutate(date_prior = as.Date(publish_time),
         date_post = date_prior)

#------------------------------------------------------

#for records without proper date, extract dois as character vector

doi_list <- CORD19 %>%
  filter(is.na(date_post)) %>%
  filter(!is.na(doi)) %>%
  pull(doi) %>%
  unique() 

#get created date from Crossref for dois
#runtime appr. 1 m per 100 dois, progress bar is shown
doi_date <- getCrossref(doi_list)
doi_date <- formatDateCrossref(doi_date)
doi_date <- distinct(doi_date)


#create columns doi_lc in both databases for matching
CORD19 <- CORD19 %>%
  mutate(doi_lc = str_to_lower(doi))

doi_date <- doi_date %>%
  mutate(doi_lc = str_to_lower(doi))

#join dates to full database, add to column date_post
CORD19 <- joinDateCrossref(CORD19, doi_date)

#------------------------------------------------------------

#for records without proper date, extract pmcids as character vector
pmcid_list <- CORD19 %>%
  filter(is.na(date_post)) %>%
  filter(!is.na(pmcid)) %>%
  pull(pmcid) %>%
  unique()

#set parameter for progress bar
pb <- progress_estimated(length(pmcid_list))

# get data from EuropePMC
# app 1 min/100 DOIS, progress bar shown
pmcid_date <- map_dfr(pmcid_list, getEuropePMC_progress)
# NB this gives an message for each result - find a way to suppress them
rm(pb)

#extract data and format date
pmcid_date <- extractDataEuropePMC(pmcid_date)

#join dates to full database, add to column date_post
CORD19 <- joinDateEuropePMC(CORD19, pmcid_date)

#--------------------------------------------------------
#create subset from 20191201
CORD19_201912 <- getSubset(CORD19)

#write as version
filename <- paste0("../datasets/cord19_v",
                   version,
                   "_20191201.csv")
write_csv(CORD19_201912, filename)

#also write as latest
filename <- paste0("../datasets/cord19_latest_20191201.csv")
write_csv(CORD19_201912, filename)


#----------------------------------------------------------

#collect statistics for ASReview for full set and subset
statistics <- getStats(CORD19, CORD19_201912)

#-------------------------------------------------------------

#modify JSON files
#NB streamline with functions after it has been confirmed to work in ASReview

#read json files (use 'latest' as basis for updates)
filepath_latest_all <- "../config/cord19-all/cord19_latest_all.json"
filepath_latest_subset <- "../config/cord19-2020/cord19_latest_20191201.json"

json_all <- fromJSON(filepath_latest_all)
json_subset <- fromJSON(filepath_latest_subset)

#---------------------------------------------------------------
#one time modification to change fixed elements of 'latest' json files

#json_all$dataset_id <- "cord19-latest"
#json_all$title <- "CORD-19 latest"
#json_all$url <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/latest/metadata.csv"

#json_subset$dataset_id <- "cord19-2020-latest"
#json_subset$title <- "CORD-19 latest since Dec. 2019"
#json_subset$url <- "https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/cord19_latest_20191201.csv"

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


#--------------------------------------------------------------------
#one time modification to update urls for versions of full dataset to Zenodo
#version 3-8

filepath_version_full <- paste0("../config/cord19-all/cord19_v",
                                version,
                                "_all.json")

json_all <- fromJSON(filepath_latest_all)
