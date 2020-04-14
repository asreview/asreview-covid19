# R-scripts to reproduce processing CORD-19 database

Two versions of the CORD-19 dataset are made available in ASReview: the full dataset and a dataset with publications from December 2019 onwards.

## The CORD-19 dataset

The [CORD-19 dataset](https://pages.semanticscholar.org/coronavirus-research) is made available through a collaboration of the Allen Institute for AI, the Chan Zuckerberg Initiative, Georgetown University’s Center for Security and Emerging Technology, Microsoft Research, and the National Library of Medicine of the National Institutes of Health. 

Version 6 of the dataset ([csv](https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-03/metadata.csv), dated April 3, 2020) contains metadata of 47.3K publications on COVID-19 and coronavirus-related research (e.g. SARS, MERS, etc.) from PubMed Central, the WHO COVID-19 database of publications,  the preprint servers bioRxiv and medRxiv and papers contributed by specific publishers (currently Elsevier).


## Supplemental date information

Information on publication time in consistent date-format in the  is  available for 96.4% of recordsin the original dataset (v6). The scripts in this repo are used to enrich information on first date of publication, making use of Crossref (for DOIs) and EuropePMC (for PMCIDs) APIs. As a result, date information in standard format is made available for 99.0% of all records in the CORD-19 dataset.  

This information is available as separate dataset [CORD19id_date_v6.csv](CORD19v6_R/output/CORD19id_date_v6.csv) containing the following variables:  

* source database (PMC, WHO, etc)
* identifiers(doi, PMCID en PMID)
* date as supplied in CORD-19
* date as retrieved from Crossref and PubMed Central


## CORD-19 subset from Dec 2019 onwards
Using the enriched date information, a subset of the CORD-19 dataset is created containing publications from Dec 2019 onwards (i.e. publication relating to the current COVID-19 outbreak). Date information in standard format is used, as well as originally supplied date information that contains the year 2020. This dataset contains 4774 records.

This subset is available as a separate dataset [cord19_v6_20191201.csv](CORD19v6_R/output/cord19_v6_20191201.csv) containing the following variables:  

* all variables in CORD-19
* date as retrieved from Crossref and PubMed Central

## Workflow and updates

A more detailed workflow is described in the notebook [CORD19_dataset_R.Rmd](CORD19_dataset_R.Rmd)

The CORD-19 dataset is updated weekly. The modified datasets described here will be updated shortly after.  
The current datasets are based on **CORD-19 version 6 (released 2020-04-03)**