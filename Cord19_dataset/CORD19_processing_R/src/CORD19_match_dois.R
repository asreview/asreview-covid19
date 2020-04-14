#For all DOIs in CORD19 records without proper date, get publication data from Crossref
#create matching table to integrate in CORD19 

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
formatDateCrossref <- function(x){
  res <- x %>%
    mutate(created = as.Date(created))
  
  return(res)
}


#define function to add date to id list
joinDateCrossref <- function(x,y){
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

