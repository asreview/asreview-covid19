#Import Covid19 preprints dataset (selected columns)

date <- last_update

#define function to read and extract zip file from Figshare
getFiles <- function(url, date = last_update){
  dir.create("data")
  zipfile <- paste0("covid19_preprints.zip") #except for v6
  #zipfile <- paste0("covid19_preprints-", date, ".zip") #v6
  path <- "data"
  path1 <- file.path(path, "data.zip")
  path2 <- file.path(path, zipfile) #root of downloaded zip file
  
  download.file(url, path1, mode="wb")
  unzip(zipfile = path1, exdir = "data")
  unzip(zipfile = path2, exdir = "data")
  #remove zip-files
  unlink(c(path1, path2))
}

#define function to read Covid19 preprints file (csv)
#specify column types to prevent failures on import
readFile <- function(){
  path <- "data"
  file <- list.files(path)
  path1 <- file.path(path, file, "data/covid19_preprints.csv")
  
  df <- read_csv(path1, 
                 col_types = cols(
                   source = col_character(),
                   doi = col_character(),
                   arxiv_id = col_character(),
                   posted_date = col_date(format = ""),
                   title = col_character(),
                   abstract = col_character()
                 ))
  
  unlink(path, recursive = TRUE)
  
  return(df)
  
}

