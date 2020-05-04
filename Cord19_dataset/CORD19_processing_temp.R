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

#make statistics.json into nested list with elements for each version


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


#set current version number and url
version <- 4
last_update <- "2020-03-20"
url <- url4
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

#doi_date10 <- doi_date_base %>%
#  select(-doi)

#doi_list10 <- doi_list10 %>%
#  mutate(doi_lc = str_to_lower(doi)) %>%
#  left_join(doi_date10, by = "doi_lc") %>%
#  mutate(checked = "checked") %>%
# select(-doi)

doi_list0 <- CORD19 %>%
  filter(is.na(date_post)) %>%
  filter(!is.na(doi)) %>%
  select(doi) %>%
  distinct() %>%
  mutate(doi_lc = str_to_lower(doi))
  
doi_date0 <- doi_list0 %>%
  left_join(doi_list10, by = "doi_lc") %>%
  distinct()

doi_list <- doi_date0 %>%
  filter(is.na(created) & is.na(checked)) %>%
  pull(doi) %>%
  unique()

#get created date from Crossref for dois
#runtime appr. 1 m per 100 dois, progress bar is shown
doi_date <- getCrossref(doi_list)
doi_date <- formatDateCrossref(doi_date)
doi_date <- distinct(doi_date)

doi_date <- doi_date %>%
  mutate(doi_lc = str_to_lower(doi)) %>%
  select(-doi)

doi_date <- doi_date0 %>%
  left_join(doi_date, by = "doi_lc") %>%
  mutate(created = case_when(
    !is.na(`created.x`) ~ `created.x`,
    is.na(`created.x`) ~ `created.y`)) %>%
  select(-c(`created.x`, `created.y`)) %>%
  select(-checked)

#create columns doi_lc in both databases for matching
CORD19 <- CORD19 %>%
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


#--------------------------------------------------------------------
#manually add missing data

#import statistics json file
filepath_statistics <- "output/statistics.json"
statistics <- fromJSON(filepath_statistics)

statistics$v4$dates$total <- 44220
statistics$v4$dates$missing_dates_prior <- 
statistics$v4$dates$missing_dates_post <- 




#add stats for current version as named element to parent list
var <- paste0("v", version)
statistics_parent[[var]] <- statistics

#save and write as json
statistics_json <- toJSON(statistics_parent, pretty = TRUE, auto_unbox = TRUE)
write(statistics_json, filepath_statistics)
