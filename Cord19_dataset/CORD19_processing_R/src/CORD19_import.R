#Functions to import CORD dataset (selected columns)

#define function to read first lines from full CORD19 metadata files
seeCORDfull <- function(url){
  df <- read_csv(url,
                 n_max=10)
  
  return(df)
} 

#define function to explore abstracts and date info in CORD19 metadata file 
#only read selected columns
#read pmcid as character, not logical
#reading publish_date as col_date will only import properly formatted dates
getCORDid <- function(url){
  df <- read_csv(url,
                 cols_only(
                   cord_uid = col_character(),
                   source_x = col_character(),
                   doi = col_character(),
                   pmcid = col_character(),
                   pubmed_id = col_character(),
                   #publish_time = col_character())
                   publish_time = col_date(format = "")),
                 col_names = TRUE)
  
  return(df)
}


