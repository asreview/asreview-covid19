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

source("CORD19_processing_R/src/CORD19_import.R")
source("CORD19_processing_R/src/CORD19_match_dois.R")
source("CORD19_processing_R/src/CORD19_match_PMCID.R")
source("CORD19_processing_R/src/CORD19_create_subset.R")

#set email in Renviron
file.edit("~/.Renviron")
#add email address to be shared with Crossref:
#crossref_email = name@example.com


#define function to collect statistics
getStats <- function(full, subset){
  
  statistics <- list()
  
  statistics$last_update
  
  statistics$full$n_papers <- nrow(full)
  statistics$full$n_missing_title <- nrow(filter(full, is.na(title)))
  statistics$full$n_missing_abstract <- nrow(filter(full, is.na(abstract)))
  
  statistics$subset$n_papers <- nrow(subset)
  statistics$subset$n_missing_title <- nrow(filter(subset, is.na(title)))
  statistics$subset$n_missing_abstract <- nrow(filter(subset, is.na(abstract)))
  
  return(statistics)
}

#--------------------------------------------------------
#STILL TO DO

#script currently maintains count df with results of in between steps for verification
#consider keeping this, or collection only main stats post hoc

#make modifying json files into function to call

#streamlining main script more with functions



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

#--------------------------------------------------
#create folders for new version

mainDir <- paste0("./CORD19v", version, "_R/")
subDir <- c("data", "output")

paths <- map_chr(subDir, ~paste0(mainDir,.))
for (i in 1:length(paths)){
  dir.create(paths[i], recursive = TRUE)
} 

#---------------------------------------------

#inspect first lines of full dataset to view columns
#CORD19 <- seeCORDfull(url)
#rm(CORD19)

#read selected columns (uid, source, ids, date)
#warnings on date column are expected, only properly formatted dates are included 
CORD19id <- getCORDid(url)

#create dataframe to collect counts
counts <- data.frame(total = nrow(CORD19id))
counts$total_dedup <- nrow(distinct(CORD19id))


#------------------------------------------------------

#for records without proper date, extract dois as character vector

missing_date <- CORD19id %>%
  filter(is.na(publish_time))
counts$missing1 <- nrow(missing_date)

doi_list <- CORD19id %>%
  filter(is.na(publish_time)) %>%
  filter(!is.na(doi)) %>%
  pull(doi)

counts$doi_list <- length(doi_list)

doi_list <- doi_list %>%
  unique() 

counts$doi_unique <- length(doi_list)

#get created date from Crossref for dois
#runtime appr. 1 m per 100 dois, progress bar is shown
doi_date <- getCrossref(doi_list)
doi_date <- formatDateCrossref(doi_date)
doi_date <- distinct(doi_date)

counts$doi_retrieved <- nrow(doi_date)

filename <- paste0("CORD19v",
                   version,
                   "_R/data/dois_date_v",
                   version,
                   ".csv")
# write to csv for later use in matching
write_csv(doi_date, filename)

#create columns doi_lc in both databases for matching
CORD19id_date <- CORD19id %>%
  mutate(doi_lc = str_to_lower(doi))

doi_date <- doi_date %>%
  mutate(doi_lc = str_to_lower(doi))

#join dates to list of ids, create new column date
CORD19id_date <- joinDateCrossref(CORD19id_date, doi_date)
rm(doi_date, doi_list)

#------------------------------------------------------------

#for records without proper date, extract pmcids as character vector

missing_date <- CORD19id_date %>%
  filter(is.na(date))

counts$missing2 <- nrow(missing_date)

pmcid_list <- CORD19id_date %>%
  filter(is.na(date)) %>%
  filter(!is.na(pmcid)) %>%
  pull(pmcid) 

counts$pmcid_list <- length(pmcid_list)

pmcid_list <- pmcid_list %>%
  unique() 

counts$pmcid_list_unique <- length(pmcid_list)

#set parameter for progress bar
pb <- progress_estimated(length(pmcid_list))

# get data from EuropePMC
# app 1 min/100 DOIS, progress bar shown
pmcid_date <- map_dfr(pmcid_list, getEuropePMC_progress)
# NB this gives an message for each result - find a way to suppress them
rm(pb)

#extract data and format date
#warning if columns are not included in ePMC output
pmcid_date <- extractDataEuropePMC(pmcid_date)

counts$pmcid_retrieved <- nrow(pmcid_date)

filename <- paste0("CORD19v",
                   version,
                   "_R/data/pmcid_date_v",
                   version,
                   ".csv")
# write to csv for later use in matching
write_csv(pmcid_date, filename)

#join dates to list of ids
CORD19id_date <- joinDateEuropePMC(CORD19id_date, pmcid_date)
rm(pmcid_date, pmcid_list)

#merge dates for doi and pmcid
CORD19id_date <- mergeDate(CORD19id_date)

#check still missing dates
missing_date <- CORD19id_date %>%
  filter(is.na(date)) 
counts$missing3 <- nrow(missing_date)

missing_date <- missing_date %>%
  filter(!is.na(pubmed_id))
counts$missing_with_pmid <- nrow(missing_date)

filename <- paste0("CORD19v",
                   version,
                   "_R/output/CORD19id_date_v",
                   version,
                   ".csv")
# write to csv
write_csv(CORD19id_date, filename)
# read file for processing at later time
#CORD19id_date <- read_csv(filename, col_types = cols(pmcid = col_character(),
#                                                      pubmed_id = col_character()))


#--------------------------------------------------

#read full dataset, set 4 columns as char for full import (to prevent errors)
#set column publish_time as character, to read all in
CORD19full <- read_csv(url, 
                       col_types = cols(`Microsoft Academic Paper ID` = col_character(), 
                                        `WHO #Covidence` = col_character(), 
                                        journal = col_character(), 
                                        pmcid = col_character(), 
                                        publish_time = col_character(), 
                                        pubmed_id = col_character()))


#Add date column - setting date format will only keep properly formatted entries
CORD19full_date <- CORD19full %>%
  mutate(date = as.Date(publish_time))


#map date from CORD19_id_date, for DOI and PMCID
CORD19full_date <- CORD19full_date %>%
  joinDOI(CORD19id_date) %>%
  joinPMCID(CORD19id_date) %>%
  distinct()

#missing counts
missing_date <- CORD19full_date %>%
  filter(is.na(date))
counts$missing4 <- nrow(missing_date)
rm(missing_date)


#create subset from 20191201
CORD19_201912 <- CORD19full_date %>%
  mutate(subset = case_when(
    date >= as.Date("2019-12-01") ~ TRUE,
    publish_time == 2020 ~ TRUE,
    TRUE ~ FALSE)) %>%
  filter(subset == TRUE) %>%
  select(-subset) 

counts$subset <- nrow(CORD19_201912)


filename <- paste0("CORD19v",
                   version,
                   "_R/output/cord19_v",
                   version,
                   "_20191201.csv")
write_csv(CORD19_201912, filename)
#CORD19_201912 <- read_csv(filename)

#also write as latest
filename <- paste0("CORD19_processing_R/output/cord19_latest_20191201.csv")
write_csv(CORD19_201912, filename)


#pivot counts
counts <- counts %>%
  pivot_longer(everything(), names_to = "parameter")




#----------------------------------------------------------

#collect statistics for ASReview for full set and subset
statistics <- getStats(CORD19full, CORD19_201912)

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