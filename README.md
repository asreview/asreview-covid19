# asreview-covid19

![ASReview for COVID19](https://github.com/asreview/asreview/blob/master/images/intro-covid19-small.png?raw=true)

Extension that adds Covid-19 related datasets to [ASReview](https://github.com/asreview/asreview).

# ASReview
The Active learning for Systematic Reviews ([ASReview] (https://github.com/asreview/asreview)) software implements learning algorithms that interactively query the researcher during the title/abstract pahse of a systematis search. This way of interactive training is known as Active Learning. ASReview offers support for classical learning algorithms and state-of-the-art learning algorithms like neural networks. The software can be used for classical systematic reviews for which the user uploads a dataset of papers, or one can make use of the built-in datasets. 

# The CORD-19 dataset
The [CORD-19 dataset](https://pages.semanticscholar.org/coronavirus-research) is made available through a collaboration of the Allen Institute for AI, the Chan Zuckerberg Initiative, Georgetown University’s Center for Security and Emerging Technology, Microsoft Research, and the National Library of Medicine of the National Institutes of Health. 

Version 5 of the dataset ([csv](https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-27/metadata.csv), dated March 27, 2020) contains metadata of 45.8K publications on COVID-19 and coronavirus-related research (e.g. SARS, MERS, etc.) from PubMed Central, the WHO COVID-19 database of publications,  the preprint servers bioRxiv and medRxiv and papers contributed by specific publishers (currently Elsevier).


Two versions of the CORD-19 dataset (publications relating to COVID-19) are made available in ASReview: the full dataset and a dataset with publications from December 2019 onwards. The CORD-19 dataset is updated weekly. The modified datasets described here will be updated shortly after.  The current datasets are based on **CORD-19 version 5 (released 2020-03-27)**

## Complete database

Information on publication time in the original dataset (v4) is  available for 96.7% of records, and  provided in various formats. The scripts in this repo are used to enrich information on first date of publication, making use of Crossref (for DOIs) and EuropePMC (for PMCIDs) APIs. As a result, date information in standard format is made available for 98.9% of all records in the CORD-19 dataset.  

This information is available as separate dataset [CORD19id_date.csv](CORD19v5_pubdate_R/output/CORD19id_date.csv) containing the following variables:  

* source database (PMC, WHO, etc)
* identifiers(doi, PMCID en PMID)
* date as supplied in CORD-19
* date as retrieved from Crossref and PubMed Central


## Subset from Dec 2019 onwards
Using the enriched date information, a subset of the CORD-19 dataset is created containing publications from Dec 2019 onwards (i.e. publication relating to the current COVID-19 outbreak). Date information in standard format is used, as well as originally supplied date information that contains the year 2020. This dataset contains 4001 records.

This subset is available as a separate dataset [CORD19_201912.csv](CORD19v5_pubdate_R/output/CORD19_201912.csv) containing the following variables:  

* all variables in CORD-19
* date as retrieved from Crossref and PubMed Central


# Installation of the Covid-19 Pluing
The Covid-19 plug-in only works after [installaton of ASReview](https://asreview.readthedocs.io/en/latest/installation.html). 

Install the extension with pip:

```bash
pip install asreview-covid19
```

The extension will download the file from the internet for you, which depending on your internet can take a while. 
Now, to launch the ASReview user interface with the Cord-19 database, run the following in your shell:

```bash
asreview oracle
```

and follow the instruction of the [Quick Tour](https://asreview.readthedocs.io/en/latest/quicktour.html). 


