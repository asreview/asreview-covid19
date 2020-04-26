#Create subset of full dataset for publiations > 20191201

getSubset <- function(x){
  
  res <- x %>%
    mutate(subset = case_when(
      date_post >= as.Date("2019-12-01") ~ TRUE,
      publish_time == 2020 ~ TRUE,
      TRUE ~ FALSE)) %>%
    filter(subset == TRUE) %>%
    select(-subset) 
  
  return(res)
  
} 