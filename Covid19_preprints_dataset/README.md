# R-scripts for processing COVID 19 preprints dataset

## The COVID19 preprints dataset

The [COVID19 preprints dataset](https://github.com/nicholasmfraser/covid19_preprints) is created by [Nicholas Fraser](https://github.com/nicholasmfraser) and [Bianca Kramer](https://github.com/bmkramer), by collecting metadata of COVID19-related preprints with DOIs registered with Crossref or DataCite, and from arXiv.

The most recent version of the dataset can be downloaded here (csv):
[https://github.com/nicholasmfraser/covid19_preprints/blob/master/data/covid19_preprints.csv](https://github.com/nicholasmfraser/covid19_preprints/blob/master/data/covid19_preprints.csv).
All versions are archived on [Figshare](https://doi.org/10.6084/m9.figshare.12033672).

Version 9 of the dataset (dated May 24, 2020) contains metadata of 10K preprints related to COVID-19 from > 15 preprint servers.

![Covid19 preprints](https://raw.githubusercontent.com/nicholasmfraser/covid19_preprints/master/outputs/figures/covid19_preprints_day_cumulative.png)

The dataset contains the following variables:

* preprint archive
* doi
* arxiv_id
* posted_date
* title
* abstract (where available)

## Script and updates

The script used for the workflow is described here:
[Covid19_preprints_processing.R](Covid19_preprints_processing.R)

The Covid19 preprints dataset is updated weekly and will be made available in ASReview shortly after.
The current datasets is **version 9 (released 2020-05-24)**
