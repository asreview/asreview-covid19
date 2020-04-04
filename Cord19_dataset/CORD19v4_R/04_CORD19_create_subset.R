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
url4 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-20/metadata.csv"

#read full dataset, set 4 columns as char for full import (to prevent errors)
CORD19full <- read_csv(url4,
                       col_types = cols(pmcid = col_character(),
                                        publish_time = col_character(),
                                        `Microsoft Academic Paper ID` = col_character(),
                                        `WHO #Covidence` = col_character))

#Error: Some `col_types` are not S3 collector objects: 4
#All columns are important as their original coltype

#Add date column - setting date format will only keep properly formatted entries
CORD19full_date <- CORD19full %>%
  mutate(date = as.Date(publish_time))

#get counts of all non-NAs per column 
count_all <- CORD19full_date %>%
  summarise_all(~ sum(!is.na(.)))
#ISSUE: WHO Covidence # not imported 

# read file with article IDs + dates (for dois and pmcids) for CORD19
filename <- "CORD19v4_R/output/CORD19id_date.csv"
CORD19id_date <- read_csv(filename, 
                          col_types = cols(pmcid = col_character()))

#get counts of all non-NAs per column 
count_id_date <- CORD19id_date %>%
  summarise_all(~ sum(!is.na(.)))

#map date from CORD19_id_date, for DOI and PMCID
CORD19full_date <- CORD19full_date %>%
  joinDOI(CORD19id_date) %>%
  joinPMCID(CORD19id_date)

#test count (expected 639)
count <- CORD19full_date %>%
  filter(is.na(date))
#n= 639 

#check how many records without 'date' have 'publish_time'
count2 <- CORD19full_date %>%
  filter(is.na(date)) %>%
  filter(!is.na(publish_time)) %>%
  group_by(publish_time) %>%
  count()
#n= 479, all 2020 <- INCLUDE IN SUBSET from 20191201

#create subset from 20191201
CORD19_201912 <- CORD19full_date %>%
  mutate(subset = case_when(
    date >= as.Date("2019-12-01") ~ TRUE,
    publish_time == 2020 ~ TRUE,
    TRUE ~ FALSE)) %>%
  filter(subset == TRUE) %>%
  select(-subset)
#n= 3513

filename2 <- "CORD19v4_R/output/CORD19_201912.csv"
write.csv(CORD19_201912, filename2, row.names = FALSE)

