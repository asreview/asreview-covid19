#Add dates to CORD19 dataset (missing and/or non-formatted dates)
#Create subset of records from Dec 2019 onwards
#Current version: v7 dd 20200410

#info on CORD19 dataset:
#https://pages.semanticscholar.org/coronavirus-research

#install.packages("tidyverse")
#install.packages("rcrossref")
#install.packages("europepmc")
#install.packages("lubridate")
library(tidyverse)
library(rcrossref)
library(europepmc)
library(lubridate)

source("CORD19_processing_R/src/CORD19_import.R")
source("CORD19_processing_R/src/CORD19_match_dois.R")
source("CORD19_processing_R/src/CORD19_match_PMCID.R")
source("CORD19_processing_R/src/CORD19_create_subset.R")

#set email in Renviron
file.edit("~/.Renviron")
#add email address to be shared with Crossref:
#crossref_email = name@example.com


#----------------------------------------------------
#URLs for CORD19 dataset
#url3 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-13/all_sources_metadata_2020-03-13.csv"
#url4 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-20/metadata.csv"
#url5 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-27/metadata.csv"
#url6 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-03/metadata.csv"
#url7 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-10/metadata.csv"

#set current version number and url
version <- 7
url <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-10/metadata.csv"



#inspect first lines of full dataset to view columns
#CORD19 <- seeCORDfull(url)
#rm(CORD19)

#read selected columns (uid, source, ids, date)
#warnings on date column are expected, only properly formatted dates are included 
CORD19id <- getCORDid(url)
#51078 records 

#------------------------------------------------------

#for records without proper date, extract dois as character vector
doi_list <- CORD19id %>%
  filter(is.na(publish_time)) %>%
  filter(!is.na(doi)) %>%
  pull(doi) %>%
  unique() 
#1610 dois, 1609 unique

#get created date from Crossref for dois
#runtime appr. 1 m per 100 dois, progress bar is shown
doi_date <- getCrossref(doi_list)
doi_date <- formatDateCrossref(doi_date)
doi_date <- distinct(doi_date)
#1419 retrieved

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
pmcid_list <- CORD19id_date %>%
  filter(is.na(date)) %>%
  filter(!is.na(pmcid)) %>%
  pull(pmcid) %>%
  unique() 
#258 pmcids

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
#258 records

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
count <- CORD19id_date %>%
  filter(is.na(date)) %>%
#  filter(!is.na(pubmed_id))
#rm(count)
#483 without proper date
#163 with pmid

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

#get counts of all non-NAs per column 
count_all <- CORD19full_date %>%
  summarise_all(~ sum(!is.na(.)))

count_id_date <- CORD19id_date %>%
  summarise_all(~ sum(!is.na(.)))

rm(count_all, count_id_date)


#map date from CORD19_id_date, for DOI and PMCID
CORD19full_date <- CORD19full_date %>%
  joinDOI(CORD19id_date) %>%
  joinPMCID(CORD19id_date) %>%
  distinct()

#test count (expected 483)
count <- CORD19full_date2 %>%
  filter(is.na(date))
#n= 483 
rm(count)

#create subset from 20191201
CORD19_201912 <- CORD19full_date %>%
  mutate(subset = case_when(
    date >= as.Date("2019-12-01") ~ TRUE,
    publish_time == 2020 ~ TRUE,
    TRUE ~ FALSE)) %>%
  filter(subset == TRUE) %>%
  select(-subset) 
#n= 5753


filename <- paste0("CORD19v",
                   version,
                   "_R/output/cord19_v",
                   version,
                   "_20191201.csv")
write_csv(CORD19_201912, filename)

#----------------------------------------------------------
#for ASReview, get number of missing titles/abstracts
#rewrite as function with one output

count_abs_full <- CORD19full %>%
  select(title, abstract) %>%
  summarise_all(~ sum(is.na(.)))

count_abs_subset <- CORD19_201912 %>%
  select(title, abstract) %>%
  summarise_all(~ sum(is.na(.)))