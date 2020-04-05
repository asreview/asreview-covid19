#For PMCIDs w/o DOI (or for which doi did not yield date) in CORD19 dataset (note specific version) 
#get publication data from EuropePMC


#info on package #europepmc:
#https://github.com/ropensci/europepmc
#https://cran.r-project.org/web/packages/europepmc/europepmc.pdf
#info on EuropePMC API
#https://europepmc.org/RestfulWebService


#install.packages("tidyverse")
#install.packages("europepmc")
library(tidyverse)
library(europepmc)



# define function to query EuropePMC API for PMCIDs
getEuropePMC <- function(pmcid){
  query <- paste0("pmcid:",pmcid)
  res <- epmc_search(query)
  
  return(res)
} 

#add progress bar 
getEuropePMC_progress <- function(pmcid){
  pb$tick()$print()
  result <- getEuropePMC(pmcid)
  
  return(result)
}

#define function to format date
#NB include doi and PMID for potential future addition to dataset
extractData <- function(x){
  res <- x %>%
    select(pmcid, pmid, doi, firstPublicationDate) %>%
    mutate(created = as.Date(firstPublicationDate)) %>%
    select(-firstPublicationDate)
  
  return(res)
}


#define function to add date to id list
#remove doi, pmid columns b/c not needed here
joinDate <- function(x,y){
  
  y <- y %>%
    select(pmcid, created)
  
  res <- x %>%
    left_join(y, by = "pmcid")
  
  return(res)
  
}
  

#define function to merge date columns (doi and pmcid results)
mergeDate <- function(x){
  
  res <- x  %>%
    mutate(date = case_when(
      is.na(date) ~ created,
      !is.na(date) ~ date)) %>%
    select(-created)
  
  return(res)
}


#----------------------------------------------------

# read file with article IDs + dates (for dois) for CORD19
filename <- "CORD19v6_R/output/CORD19id_date.csv"
CORD19id_date <- read_csv(filename, col_types = cols(pmcid = col_character(),
                                                     pubmed_id = col_character()))

#extract PMCIDs for records without date, as character vector
#can note down numbers in this step
pmcid_list <- CORD19id_date %>%
  filter(is.na(date)) %>%
  filter(!is.na(pmcid)) %>%
  pull(pmcid) %>%
  unique() 

#741 records without (proper) date
#256 with PMCID

#for testing
#pmcid_list <- pmcid_list %>%
#  head(100)

#set parameter for progress bar
pb <- progress_estimated(length(pmcid_list))

# get data from EuropePMC
# app 1 min/100 DOIS, progress bar shown
pmcid_date <- map_dfr(pmcid_list, getEuropePMC_progress)
# NB this gives an message for each result - find a way to suppress them

#extract data and format date
pmcid_date <- extractData(pmcid_date)

#256 records retrieved from EuropePMC

filename2 <- "CORD19v6_R/data/pmcid_date.csv"
# write to csv for later use in matching
write_csv(pmcid_date, filename2)
# read file for processing at later time
#pmcid_date2 <- read_csv(filename2, col_types = cols(pmcid = col_character()))

#join dates to list of ids
CORD19id_date <- joinDate(CORD19id_date, pmcid_date)
#merge dates for doi and pmcid
CORD19id_date <- mergeDate(CORD19id_date)

#check still missing dates
#count <- CORD19id_date %>%
#  filter(is.na(date))
#485 without proper date

filename3 <- "CORD19v6_R/output/CORD19id_date_v6.csv"
# write to csv
write_csv(CORD19id_date, filename3)
# read file for processing at later time
#CORD19id_date <- read_csv(filename3, col_types = cols(pmcid = col_character(),
#                                                      pubmed_id = col_character()))
 



                           
                           