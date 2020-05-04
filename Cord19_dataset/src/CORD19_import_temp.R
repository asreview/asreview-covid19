#Functions to import CORD dataset (selected columns)

#define function to read first lines from full CORD19 metadata files
seeCORDfull <- function(url){
  df <- read_csv(url,
                 n_max=10)
  
  return(df)
} 

#define function to read full CORD19 metdafile
#set certain columns as character to read in all values
#
getCORDfull <- function(url){
  df <- read_csv(url, 
                 col_types = cols(`Microsoft Academic Paper ID` = col_character(), 
                                  `WHO #Covidence` = col_character(),
                                  #arxiv_id = col_character(), #from v10 onwards
                                  journal = col_character(), 
                                  pmcid = col_character(), 
                                  publish_time = col_character(), 
                                  pubmed_id = col_character()))

  return(df)
}


