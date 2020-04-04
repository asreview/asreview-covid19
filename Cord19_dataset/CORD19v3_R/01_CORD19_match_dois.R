#For all DOIs in CORD19 dataset (note specific version), get publication data from Crossref
#create matching table to integrate in CORD19 instance used in ASReview

#info on package #rcrossref:
#https://cran.r-project.org/web/packages/rcrossref/rcrossref.pdf
#info on Crossref API:
#https://github.com/CrossRef/rest-api-doc


#install.packages("tidyverse")
#install.packages("lubridate)
#install.packages("rcrossref")
library(tidyverse)
library(lubridate)
library(rcrossref)

#set email in Renviron
file.edit("~/.Renviron")
#add email address to be shared with Crossref:
#crossref_email = name@example.com
#save the file and restart your R session
#how to remove: delete email from ~/.Renviron

#define function to read CORD19 metadata file from url (instance used in ASReview)
#only read selected columns
getCORD19 <- function(url){
  df <- read_csv(url,
                 cols_only(
                   doi = col_character(),
                   pmcid = col_character(),
                   pubmed_id = col_character()),
                 col_names = TRUE)
  
  return(df)
}

#define function to read CORD19_id (selected columns) from file
#for later matching
readCORD19id <- function(filename){
  read_csv(filename,
           cols(
             doi = col_character(),
             pmcid = col_character(),
             pubmed_id = col_character()),
           col_names = TRUE)
}


#define function to pull and clean dois from CORD19
addDOIsCleaned <- function(x){
  res <- x %>%
    mutate(doi_clean = str_remove(doi, "http://dx.doi.org/"),
           doi_clean = str_remove(doi_clean, "doi.org/"))
    
    return(res)
}


#define function to get Crossref metadata for all DOIS and extract doi and created da
#NB created is used for both preprints and published articles
#runtime is 1 min / 100 dois, progress bar is shown
getCrossref <- function(dois){
  #get crossref metadata for each doi in vector dois
  cr_result <- cr_works(dois = dois,
                        .progress = "time")
  
  cr_result <- cr_result$data %>%
    select(doi, created)
  
  return(cr_result)
  
}  


#define function to format date
formatDate <- function(x){
  res <- x %>%
    mutate(created = as.Date(created),
           created_year = lubridate::year(created))
  
  return(res)
}


#define function to add date to id list
joinDate <- function(x,y){
  res <- x %>%
    left_join(y, by = c("doi_clean" = "doi")) %>%
    select(-doi_clean)
  
  return(res)
}


#----------------------------------------------------
# set URL for CORD19 dataset
url <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-13/all_sources_metadata_2020-03-13.csv"

# get CORD19 file from URL
CORD19id <- getCORD19(url)


#clean unique dois from CORD19, deduplicate
CORD19id_doi <- addDOIsCleaned(CORD19id)
CORD19id_doi <- distinct(CORD19id_doi)

#extract cleaned dois as character vector
#can note down numbers in this step
doi_list <- CORD19id_doi %>%
  filter(!is.na(doi)) %>%
  pull(doi_clean) %>%
  unique() 

#for testing
#doi_list_test <- doi_list %>%
#  head(10)

#get created date from Crossref for all dois
#runtime appr. 1 m per 100 dois, progress bar is shown
doi_date <- getCrossref(doi_list)
#format date
doi_date <- formatDate(doi_date)
#keep unique 
doi_date <- distinct(doi_date)

filename <- "CORD19v3_R/data/dois_date.csv"
# write to csv for later use in matching
write_csv(doi_date, filename)
# read file for processing at later time
#doi_date <- read_csv(filename)

#join dates to list of ids
CORD19id_date <- joinDate(CORD19id_doi, doi_date)

filename2 <- "CORD19v3_R/output/CORD19id_date.csv"
# write to csv for next step in matching - will be final output location
write_csv(CORD19id_date, filename2)
# read file for processing at later time
#CORD19id_date <- read_csv(filename2, col_types = cols(pmcid = col_character()))
 
