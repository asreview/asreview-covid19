#Create subset of full dataset for publiations > 20191201


#define 2 functions to match on dois and pmcids
joinDOI <- function(x,y){
  
  y <- y %>%
    select(doi, date) %>%
    rename(date2 = date)
  
  res <- x %>%
    left_join(y, by = "doi", na_matches = "never")
  
  res <- res  %>%
    mutate(date = case_when(
      is.na(date) ~ date2,
      !is.na(date) ~ date)) %>%
    select(-date2)
  
  return(res)
}

joinPMCID <- function(x,y){
  
  y <- y %>%
    select(pmcid, date) %>%
    rename(date2 = date)
  
  res <- x %>%
    left_join(y, by = "pmcid", na_matches = "never")
  
  res <- res  %>%
    mutate(date = case_when(
      is.na(date) ~ date2,
      !is.na(date) ~ date)) %>%
    select(-date2)
  
  
  return(res)
}




