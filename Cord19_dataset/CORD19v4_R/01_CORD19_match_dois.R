#For all DOIs in CORD19 records without proper date, get publication data from Crossref
#create matching table to integrate in CORD19 

#info on package #rcrossref:
#https://cran.r-project.org/web/packages/rcrossref/rcrossref.pdf
#info on Crossref API:
#https://github.com/CrossRef/rest-api-doc


#install.packages("tidyverse")
#install.packages("rcrossref")
library(tidyverse)
library(rcrossref)

#set email in Renviron
file.edit("~/.Renviron")
#add email address to be shared with Crossref:
#crossref_email = name@example.com
#save the file and restart your R session
#how to remove: delete email from ~/.Renviron


#define function to show counts for (proper) date per source
getCountsDate <- function(x){
  
  date <- x %>%
    filter(!is.na(publish_time)) %>%
    group_by(source_x) %>%
    count()
  
  nodate <- x %>%
    filter(is.na(publish_time)) %>%
    group_by(source_x) %>%
      count()
  
  date <- date %>%
    merge(nodate, by = "source_x", all = TRUE) %>%
    rename(date = `n.x`,
           nodate = `n.y`) 
  
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
    mutate(created = as.Date(created))
  
  return(res)
}


#define function to add date to id list
joinDate <- function(x,y){
  res <- x %>%
    left_join(y, by = "doi_lc")
  
  res <- res %>%
    rename(doi = `doi.x`) %>%
    select(-c(`doi.y`, doi_lc)) %>%
    rename(date = publish_time) %>%
    mutate(date = case_when(
      is.na(date) ~ created,
      !is.na(date) ~ date)) %>%
    select(-created)
  
  return(res)
}


#----------------------------------------------------

# read file
filename <- "CORD19v4_R/data/CORD19id.csv"
CORD19id <- read_csv(filename, 
                  col_types = cols(pmcid = col_character()))
#44220 records

#analyse records with/without proper date per source
date_df <- getCountsDate(CORD19id)

#for records without proper date, extract dois as character vector
#note down numbers in this step
doi_list <- CORD19id %>%
  filter(is.na(publish_time)) %>%
  filter(!is.na(doi)) %>%
  pull(doi) %>%
  unique() 

#23022 records without proper date
#19571 have DOI
#19571 unique

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

#19242 retrieved, 19241 unique

filename2 <- "CORD19v4_R/data/dois_date.csv"
# write to csv for later use in matching
write_csv(doi_date, filename2)
# read file for processing at later time
#doi_date <- read_csv(filename2)

#create columns doi_lc in both databases for matching
CORD19id_date <- CORD19id %>%
  mutate(doi_lc = str_to_lower(doi))

doi_date <- doi_date %>%
  mutate(doi_lc = str_to_lower(doi))

#join dates to list of ids, create new column date
CORD19id_date <- joinDate(CORD19id_date, doi_date)

#check counts
count_date <- CORD19id_date %>%
  filter(is.na(date))
#3780 still missing proper date

filename3 <- "CORD19v4_R/output/CORD19id_date.csv"
# write to csv for next matching step (will be final location)
write_csv(CORD19id_date, filename3)
# read file for processing at later time
#CORD19id_date2 <- read_csv(filename3, col_types = cols(pmcid = col_character()))

#remove temporary input file 
filename <- "CORD19v4_R/data/CORD19id.csv"
unlink(filename)
