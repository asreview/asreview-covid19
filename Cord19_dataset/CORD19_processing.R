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

#read json file
filepath_latest_full <- "../config/cord19-all/cord19_latest_all.json"
filepath_latest_subset <- "../config/cord19-2020/cord19_latest_20191201.json"

json_full <- fromJSON(filepath_latest_full)
json_subset <- fromJSON(filepath_latest_subset)

#json_full_old <- json_full
#json_subset_old <- json_subset

#---------------------------------------------------------------
#one time modification
json_full$dataset_id <- "cord19-latest"
json_full$title <- "CORD-19 latest"

json_subset$dataset_id <- "cord19-2020-latest"
json_subset$title <- "CORD-19 latest since Dec. 2019"

json_full <- toJSON(json_full, pretty = TRUE)
json_subset <- toJSON(json_subset, pretty = TRUE)

write(json_full, filepath_latest_full)
write(json_subset, filepath_latest_subset)
#-----------------------------------------------------------------

json_full$last_update <- last_update
json_full$statistics$n_papers <- statistics$full$n_papers
json_full$statistics$n_missing_title <- statistics$full$n_missing_title
json_full$statistics$n_missing_abstract <- statistics$full$n_missing_abstract

json_subset$last_update <- last_update
json_subset$statistics$n_papers <- statistics$subset$n_papers
json_subset$statistics$n_missing_title <- statistics$subset$n_missing_title
json_subset$statistics$n_missing_abstract <- statistics$subset$n_missing_abstract  

filename <- paste0("../config/",
                   "cord19-2020/",
                   "cord19_latest_20191201",
                   ".json")
json_subset <- fromJSON(filename)