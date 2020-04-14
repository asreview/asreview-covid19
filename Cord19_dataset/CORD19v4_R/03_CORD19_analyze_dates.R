#Analyze dates retrieved for CORD19, add year column for plotting


#install.packages("tidyverse")
#install.packages("lubridate")
library(tidyverse)
library(lubridate)



#----------------------------------------------------

# read file with article IDs + dates (for dois and pmcids) for CORD19
filename <- "CORD19v4_R/output/CORD19id_date.csv"
CORD19id_date <- read_csv(filename, col_types = cols(pmcid = col_character()))

#------------------------------------
#CHECKS
#count date coverage
count <- CORD19id_date %>%
  filter(is.na(date)) %>%
  filter(!is.na(pubmed_id))

#44220 records
#639 without (proper) date (NB further analysis: 488 from WHO set)
#165 of which have PMID <- do not pursue right now

#count duplicates
dedup <- CORD19id_date %>%
  distinct()
#43866 unique records

#create column with year
CORD19id_date_year <- CORD19id_date %>%
  mutate(year = lubridate::year(date))

#quick plotting of year distribution
date_plot <- CORD19id_date_year %>%
  filter(!is.na(year))



p <- ggplot(date_plot, aes(year)) +
  geom_histogram(binwidth = 1, fill="steelblue") + 
  theme_minimal()


p

#--------------------------------------------------
#sandbox: publications per month - plotted by year

ave_month <- CORD19id_date_year %>%
  filter(!is.na(date)) %>%
  group_by(year) %>%
  count() %>%
  mutate(month = case_when(
    year != 2020 ~ round((n/12)),
    year == 2020 ~ round((n/3)))
  )

p2 <-ggplot(data=ave_month, aes(x=year, y=month)) +
  geom_bar(stat="identity", width=0.8, fill="steelblue") +
  theme_minimal() +
  labs(y = "articles / month")

p2 