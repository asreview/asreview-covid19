#Add dates to CORD19 dataset (v4 dd 20200320)

#info on CORD19 dataset:
#https://pages.semanticscholar.org/coronavirus-research
#https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge
#info on package #rcrossref:
#https://cran.r-project.org/web/packages/rcrossref/rcrossref.pdf
#info on Crossref API:
#https://github.com/CrossRef/rest-api-doc


#install.packages("tidyverse")
library(tidyverse)

#define function to read first lines from full CORD19 metadata files
seeCORDfull <- function(url){
  df <- read_csv(url,
                 n_max=10)
  
  return(df)
} 


#define function to explore date info in CORD19 metadata file 
#only read selected columns
#read pmcid as character, not logical
#reading publish_date as col_date will only import properly formatted dates
getCORDid <- function(url){
  df <- read_csv(url,
                 cols_only(
                   source_x = col_character(),
                   doi = col_character(),
                   pmcid = col_character(),
                   pubmed_id = col_character(),
                   #publish_time = col_character(),
                   publish_time = col_date(format = "")),
                 col_names = TRUE)
  
  df <- df %>%
    mutate(source_x = as.factor(source_x))
  
  return(df)
}


#----------------------------------------------------
# set URL for CORD19 dataset
url4 <- "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-20/metadata.csv"

#read first lines of full dataset
#CORD19 <- seeCORDfull(url4)



#read selected columns
#warnings on date column are expected, only properly formatted dates are included 
CORD19id <- getCORDid(url4)
#44220 records 

#explore duplicates
#test <- CORD19id %>%
#  distinct()
#43866 unique records (based on ids present)
#decide to not deduplicate at this time


# set filename + location for read/write
filename <- "CORD19v4_R/data/CORD19id.csv"
# write to csv for later use in matching
write_csv(CORD19id, filename)
# read file for processing at later time
#CORD19id <- read_csv(filename, 
#                  col_types = cols(pmcid = col_character()))



