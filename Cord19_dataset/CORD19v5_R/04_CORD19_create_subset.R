#Create subset of full dataset for publiations > 20191201


#install.packages("tidyverse")
library(tidyverse)

#define 2 functions to match on dois and pmcids
joinDOI <- function(x,y){
  
  y <- y %>%
    select(doi, date) %>%
    rename(date2 = date)
  
  res <- x %>%
    left_join(y, by = "doi", na_matches = "never")
  
  res <- res  %>%
    mutate(date = case_when(
      is.na(date) ~ date2,
      !is.na(date) ~ date)) %>%
    select(-date2)
  
  return(res)
}

joinPMCID <- function(x,y){
  
  y <- y %>%
    select(pmcid, date) %>%
    rename(date2 = date)
  
  res <- x %>%
    left_join(y, by = "pmcid", na_matches = "never")
  
  res <- res  %>%
    mutate(date = case_when(
      is.na(date) ~ date2,
      !is.na(date) ~ date)) %>%
    select(-date2)
  
  
  return(res)
}


#----------------------------------------------------

#read first lines of full database
# set URL for CORD19 dataset
url5 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-27/metadata.csv"

#read full dataset, set 4 columns as char for full import (to prevent errors)
#set column publish_time as character, to read all in
CORD19full <- read_csv(url5, 
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

# read file with article IDs + dates (for dois and pmcids) for CORD19
filename <- "CORD19v5_R/output/CORD19id_date.csv"
CORD19id_date <- read_csv(filename, 
                          col_types = cols(pmcid = col_character(),
                                           pubmed_id = col_character()))

#get counts of all non-NAs per column 
count_id_date <- CORD19id_date %>%
  summarise_all(~ sum(!is.na(.)))

#map date from CORD19_id_date, for DOI and PMCID
CORD19full_date <- CORD19full_date %>%
  joinDOI(CORD19id_date) %>%
  joinPMCID(CORD19id_date)

#test count (expected 485)
count <- CORD19full_date %>%
  filter(is.na(date))
#n= 485 

#check how many records without 'date' have 'publish_time'
count2 <- CORD19full_date %>%
  filter(is.na(date)) %>%
  filter(!is.na(publish_time)) %>%
  group_by(publish_time) %>%
  count()
#n= 477, all 2020 <- INCLUDE IN SUBSET from 20191201

#create subset from 20191201
CORD19_201912 <- CORD19full_date %>%
  mutate(subset = case_when(
    date >= as.Date("2019-12-01") ~ TRUE,
    publish_time == 2020 ~ TRUE,
    TRUE ~ FALSE)) %>%
  filter(subset == TRUE) %>%
  select(-subset)
#n= 4001

filename2 <- "CORD19v5_R/output/cord19_v5_20191201.csv"
write_csv(CORD19_201912, filename2)



