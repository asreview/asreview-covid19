#Import Covid19 preprints dataset (selected columns)

#define function to read and extract zip file from Figshare
getFiles <- function(url){
  path <- "data"
  path1 <- file.path(path, "data.zip")
  path2 <- file.path(path, "covid19_preprints.zip") #root of downloaded zip file
  
  download.file(url, path1, mode="wb")
  unzip(zipfile = path1, exdir = "data")
  unzip(zipfile = path2, exdir = "data")
  #remove zip-files
  unlink(c("data/data.zip", "data/covid19_preprints.zip"))
}

#define function to read Covid19 preprints file (csv)
#specify column types to prevent failures on import
readFile <- function(){
  path <- "data"
  file <- list.files(path)
  path <- file.path(path, file, "data/covid19_preprints.csv")
  
  df <- read_csv(path, 
                 col_types = cols(
                   source = col_character(),
                   doi = col_character(),
                   arxiv_id = col_character(),
                   posted_date = col_date(format = ""),
                   title = col_character(),
                   abstract = col_character()
                 ))
  
  unlink(file.path(path, file))
  
  return(df)
  
}

