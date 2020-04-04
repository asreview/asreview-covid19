#Get sources column from CORD19 dataset
#add to articleid+date information from previous steps

#install.packages("tidyverse")
library(tidyverse)


#define function to read CORD19 metadata file from url (instance used in ASReview)
#only read selected columns (add source)
getCORD19 <- function(url){
  df <- read_csv(url,
                 cols_only(
                   source_x = col_factor(),
                   doi = col_character(),
                   pmcid = col_character(),
                   pubmed_id = col_character()),
                 col_names = TRUE)
  
  return(df)
}

#define function to read saved CORD19 file with source column
readCORD19source <- function(filename){
  df <- read_csv(filename,
                 cols(pmcid = col_character()),
                 col_names = TRUE)
  
  df <- df %>%
    mutate(source_x = as.factor(source_x))
  
  return(df)
}

#define 2 functions to add date to id list for dois and pmcids
joinSourceDOI <- function(x,y){
  
  y <- y %>%
    select(doi, source_x) %>%
    distinct()
  
  res <- x %>%
    left_join(y, by = "doi", na_matches = "never")
    
  return(res)
}

joinSourcePMCID <- function(x,y){
  
  y <- y %>%
    select(pmcid, source_x) %>%
    distinct()
  
  res <- x %>%
    left_join(y, by = "pmcid", na_matches = "never")
  
  return(res)
}

#define function to merge date columns 
#(source from joins on doi and pmcid)
mergeDate <- function(x){
  
  res <- x  %>%
    rename(source_x = `source_x.x`) %>%
    mutate(source_x = case_when(
      is.na(source_x) ~ `source_x.y`,
      !is.na(source_x) ~ source_x
      )) %>%
    select(-`source_x.y`) %>%
    select(source_x, everything())
  
  
  return(res)
}

#add source (CZI) for records without doi and pmcid
addSource <- function(x){
  res <- x %>%
    mutate(source_x = as.character(source_x)) %>%
    mutate(source_x = case_when(
      is.na(source_x) ~ "CZI",
      !is.na(source_x) ~ source_x)) %>%
    mutate(source_x = as.factor(source_x))
  
  return(res)
}


#----------------------------------------------------
# set URL for CORD19 dataset
#url <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-13/all_sources_metadata_2020-03-13.csv"

# get CORD19 file from URL
#CORD19source <- getCORD19(url)

#deduplicate
CORD19source <- CORD19source %>%
  distinct()

#read CORD19id_date
filename <- "CORD19v3_R/output/CORD19id_date.csv"
CORD19id_date <- read_csv(filename, col_types = cols(pmcid = col_character()))

#join source by DOI, then PMCID
CORD19id_date_source <- CORD19id_date %>%
  joinSourceDOI(CORD19source) %>%
  joinSourcePMCID(CORD19source)

#check for multiple sources (test should be 0 rows)
#test <- CORD19id_date_source %>%
#  filter(!is.na(`source_x.x`) & !is.na(`source_x.y`)) %>%
#  filter(`source_x.x` != `source_x.y`)

#merge sources from doi and pmcid join
CORD19id_date_source <- mergeDate(CORD19id_date_source)

#add source (CZI) for records without doi and pmcid
CORD19id_date_source <- addSource(CORD19id_date_source) 
  
#check: compare tally of source_x
test_original <- CORD19source %>%
  group_by(source_x) %>%
  count()

test_new <- CORD19id_date_source %>%
  group_by(source_x) %>%
  count()


filename2 <- "CORD19v3_R/output/CORD19id_date_source.csv"
# write to csv
write_csv(CORD19id_date_source, filename2)
# read file for processing at later time
#CORD19id_date_source <- read_csv(filename2, col_types = cols(pmcid = col_character()))


