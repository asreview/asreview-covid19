#define function to collect statistics from processed CORD19 files

full <- CORD19
subset <- CORD19_201912
v <- version
update <- last_update


getStats <- function(full, subset, v = version, update = last_update){
  
  statistics <- list()
  
  statistics$version <- v
  statistics$last_update <- update
  
  statistics$dates$total <- nrow(full)
  statistics$dates$missing_dates_prior <- nrow(filter(full, is.na(date_prior)))
  statistics$dates$missing_dates_post <- nrow(filter(full, is.na(date_post)))
  
  statistics$full$n_papers <- nrow(full)
  statistics$full$n_missing_title <- nrow(filter(full, is.na(title)))
  statistics$full$n_missing_abstract <- nrow(filter(full, is.na(abstract)))
  
  statistics$subset$n_papers <- nrow(subset)
  statistics$subset$n_missing_title <- nrow(filter(subset, is.na(title)))
  statistics$subset$n_missing_abstract <- nrow(filter(subset, is.na(abstract)))
  
  return(statistics)
}


getStats <- function(full, subset, v = version, update = last_update){
  
  statistics <- list()
  
  statistics$version <- v
  statistics$last_update <- update
  
  statistics$dates$total <- nrow(full)
  statistics$dates$missing_dates_prior <- nrow(filter(full, is.na(date_prior)))
  statistics$dates$missing_dates_post <- nrow(filter(full, is.na(date_post)))
  
  statistics$full$n_papers <- nrow(full)
  statistics$full$n_missing_title <- nrow(filter(full, is.na(title)))
  statistics$full$n_missing_abstract <- nrow(filter(full, is.na(abstract)))
  
  statistics$subset$n_papers <- nrow(subset)
  statistics$subset$n_missing_title <- nrow(filter(subset, is.na(title)))
  statistics$subset$n_missing_abstract <- nrow(filter(subset, is.na(abstract)))
  
  return(statistics)
}