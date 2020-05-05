# R-scripts to reproduce processing CORD-19 database

Two versions of the CORD-19 dataset are made available in ASReview: the full dataset and a dataset with publications from December 2019 onwards.

## The CORD-19 dataset

The [CORD-19 dataset](https://pages.semanticscholar.org/coronavirus-research) is made available through a collaboration of the Allen Institute for AI, the Chan Zuckerberg Initiative, Georgetown University’s Center for Security and Emerging Technology, Microsoft Research, and the National Library of Medicine of the National Institutes of Health. 

The most recent version of the dataset can be downloaded here:  
[https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/latest/metadata.csv](https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/latest/metadata.csv).  
All versions are archived on [Zenodo](https://doi.org/10.5281/zenodo.3715505). 

Version 10 of the dataset (dated May 1, 2020) contains metadata of 60K publications on COVID-19 and coronavirus-related research (e.g. SARS, MERS, etc.) from PubMed Central, the WHO COVID-19 database of publications,  the preprint servers bioRxiv, medRxiv and arXiv, and papers contributed by specific publishers (currently Elsevier).


## Supplemental date information
Information on publication time in consistent date-format is  available for ~96% of records in the original datasets. The scripts in this repo are used to enrich information on first date of publication, making use of Crossref (for DOIs) and EuropePMC (for PMCIDs) APIs. As a result, date information in standard format is made available for ~99% of all records in the CORD-19 datasets.  

## CORD-19 subset from Dec 2019 onwards
Using the enriched date information, a subset of the CORD-19 dataset is created containing publications from Dec 2019 onwards (i.e. publication relating to the current COVID-19 outbreak). Date information in standard format is used, as well as originally supplied date information that contains the year 2020. This dataset currently contains 10831 records.

This subset is available as a separate dataset [cord19_latest_20191201.csv](../datasets/cord19_latest_20191201.csv) containing the following variables:  

* all variables in CORD-19
* date as retrieved from Crossref and Europe PMC

## Script and updates

The script used for the workflow described here:  
[CORD19_processing.R](CORD19_processing.R)

The CORD-19 dataset is updated weekly. The modified datasets described here will be updated shortly after.  
The current datasets are based on **CORD-19 version 10 (released 2020-05-01)**