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
    select(one_of(c("pmcid", "pmid", "doi", "firstPublicationDate"))) %>%
    #select(pmcid, pmid, doi, firstPublicationDate) %>%
    mutate(created = as.Date(firstPublicationDate)) %>%
    select(-firstPublicationDate)
  
  return(res)
}


#define function to add date to id list
#remove doi, pmid columns b/c not needed here
joinDateEuropePMC <- function(x,y){
  
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



                           
                           