#Functions to explore CORD19 dataset updates


#define function to read first lines from full CORD19 metadata files
seeCORDfull <- function(url){
  df <- read_csv(url,
                 n_max=10)
  
  return(df)
} 

#define function to explore sources and full_text in CORD19 metadata file 
#only read selected columns
getCORDexplore <- function(url){
  df <- read_csv(url,
                 cols_only(
                   cord_uid = col_character(),
                   source_x = col_character(),
                   doi = col_character(),
                   pmcid = col_character(),
                   pubmed_id = col_character(),
                   #has_full_text = col_logical(), #v5 and previous
                   has_pdf_parse = col_logical(), #from v6 onwards
                   has_pmc_xml_parse = col_logical(), #from v6 onwards
                   title = col_character(),
                   abstract = col_character(),
                   publish_time = col_character()),
                 col_names = TRUE)
  
  return(df)
}

#define function to list totals and full text per source
getCountsFT <- function(x){
  
  sources <- x %>%
    group_by(source_x) %>%
    count()
  
  sources_ft <- x %>%
    #filter(has_full_text == TRUE) %>% #<- v5
    filter(has_pdf_parse == TRUE | has_pmc_xml_parse == TRUE) %>% #<- v6
    group_by(source_x) %>%
    count() %>%
    mutate(full_text = n)
  
  sources <- sources %>%
    merge(sources_ft, by = "source_x", all = TRUE) %>%
    rename(n = `n.x`) %>%
    select(-`n.y`)
  
}

#get counts of dates
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
