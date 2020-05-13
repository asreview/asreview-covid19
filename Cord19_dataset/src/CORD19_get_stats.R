#define function to collect statistics from processed CORD19 files

getStats <- function(all, subset, v = version, update = last_update){
  
  statistics <- list()
  
  statistics$version <- v
  statistics$last_update <- update
  
  statistics$dates$total <- nrow(all)
  statistics$dates$missing_dates_prior <- nrow(filter(all, is.na(date)))
  
  statistics$all$n_papers <- nrow(all)
  statistics$all$n_missing_title <- nrow(filter(all, is.na(title)))
  statistics$all$n_missing_abstract <- nrow(filter(all, is.na(abstract)))
  
  statistics$subset$n_papers <- nrow(subset)
  statistics$subset$n_missing_title <- nrow(filter(subset, is.na(title)))
  statistics$subset$n_missing_abstract <- nrow(filter(subset, is.na(abstract)))
  
  return(statistics)
}

