#define function to collect statistics from Covid19 preprint file

getStats <- function(df, v = version, update = last_update){
  
  statistics <- list()
  
  statistics$version <- v
  statistics$last_update <- update
  
  statistics$preprints$n_papers <- nrow(df)
  statistics$preprints$n_missing_title <- nrow(filter(df, is.na(title)))
  statistics$preprints$n_missing_abstract <- nrow(filter(df, is.na(abstract)))
  
  return(statistics)
}

