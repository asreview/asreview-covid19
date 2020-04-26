#For PMCIDs w/o DOI (or for which doi did not yield date) in CORD19 dataset (note specific version) 
#get publication data from EuropePMC


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
#prevent error if any variable (esp. doi, pmid) is missing
extractDataEuropePMC <- function(x){
  res <- x %>%
    select(one_of(c("pmcid","firstPublicationDate"))) %>%
    #select(pmcid, pmid, doi, firstPublicationDate) %>%
    mutate(created = as.Date(firstPublicationDate)) %>%
    select(-firstPublicationDate)
  
  return(res)
}



#define function to add date to id list
joinDateEuropePMC <- function(x,y){
  res <- x %>%
    left_join(y, by = "pmcid")
  
  res <- res %>%
    mutate(date_post = case_when(
      is.na(date_post) ~ created,
      !is.na(date_post) ~ date_post)) %>%
    select(-created)
  
  return(res)
}


                           