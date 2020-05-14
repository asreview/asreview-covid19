![ASReview for COVID19](https://github.com/asreview/asreview/blob/master/images/intro-covid19-small.png?raw=true)

Extension to add publications on COVID-19 to [ASReview](https://github.com/asreview/asreview).

# ASReview against COVID-19
The Active learning for Systematic Reviews software [ASReview](https://github.com/asreview/asreview) implements learning algorithms that interactively query the researcher during the title and abstract reading phase of a systematic search. This way of interactive training is known as active learning. ASReview offers support for classical learning algorithms and state-of-the-art learning algorithms like neural networks. The software can be used for traditional systematic reviews for which the user uploads a dataset of papers, or one can make use of the built-in datasets. 

To help combat the COVID-19 crisis, the ASReview team released an extension that integrates the latest scientific datasets on COVID-19 in the ASReview software.

## CORD-19 dataset
The [CORD-19 dataset](https://pages.semanticscholar.org/coronavirus-research) is a dataset with scientific publications on COVID-19 and coronavirus-related research (e.g. SARS, MERS, etc.) from PubMed Central, the WHO COVID-19 database of publications, the preprint servers bioRxiv, medRxiv and arXiv, and papers contributed by specific publishers (currently Elsevier). The dataset is compiled and maintained by a collaboration of the Allen Institute for AI, the Chan Zuckerberg Initiative, Georgetown University’s Center for Security and Emerging Technology, Microsoft Research, and the National Library of Medicine of the National Institutes of Health. The full dataset contains metadata of >60K publications on COVID-19 and coronavirus-related research. The CORD-19 dataset is updated weekly.

The most recent version of the dataset can be downloaded here:  
[https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/latest/metadata.csv](https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/latest/metadata.csv).  
Older versions are archived on [Zenodo](https://doi.org/10.5281/zenodo.3715505).

## COVID19 preprints dataset
The [COVID19 preprints dataset](https://github.com/nicholasmfraser/covid19_preprints) is created by [Nicholas Fraser](https://github.com/nicholasmfraser) and [Bianca Kramer](https://github.com/bmkramer), by collecting metadata of COVID19-related preprints from over 15 preprint servers with DOIs registered with Crossref or DataCite, and from arXiv. The dataset contains metadata of >8K preprints on COVID-19 and coronavirus-related research. The COVID19 preprints dataset is updated weekly.

The most recent version of the dataset can be downloaded here (csv):  
[https://github.com/nicholasmfraser/covid19_preprints/blob/master/data/covid19_preprints.csv](https://github.com/nicholasmfraser/covid19_preprints/blob/master/data/covid19_preprints.csv).  
All versions are archived on [Figshare](https://doi.org/10.6084/m9.figshare.12033672)

## ASReview plugin

To help combat the COVID-19 crisis, the ASReview team has decided to release a package that provides the latest scientific datasets on COVID-19. These are integrated automatically into ASReview once we install the correct packages, so reviewers can start reviewing the latest scientific literature on COVID-19 as soon as possible!
Two versions of the CORD-19 dataset (publications relating to COVID-19) are made available in ASReview, as well as the COVID19 preprints dataset

- full CORD-19 dataset
- CORD-19 dataset with publications from December 2019 onwards
- COVID19 preprints dataset

The current datasets are based on **CORD-19 version 11 (released 2020-05-12)** and **COVID19 preprints version 7 (released 2020-05-10)**

The datasets are updated in ASReview plugin shortly after their release. 

## Installation and usage

The COVID-19 plug-in requires ASReview 0.8 or higher. Install ASReview by following the instructions in [Installation of ASReview](https://asreview.readthedocs.io/en/latest/installation.html). 

Install the extension with pip:

```bash
pip install asreview-covid19
```

The datasets are immediately available after starting ASReview. 

```bash
asreview oracle
```

The datasets are selectable in Step 2 of the project initialization. For more information on the usage of ASReview, please have a look at the [Quick Tour](https://asreview.readthedocs.io/en/latest/quicktour.html). 

[![ASReview CORD19 datasets](https://github.com/asreview/asreview/blob/master/images/asreview-covid19-screenshot.png?raw=true)](https://github.com/asreview/asreview-covid19)

## License, citation and contact

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3764749.svg)](https://doi.org/10.5281/zenodo.3764749) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The ASReview software and the plugin have an Apache 2.0 LICENSE. For the datasets, please see the license of the CORD-19 dataset https://pages.semanticscholar.org/coronavirus-research. The COVID19 preprints dataset has a [CC0 license](https://creativecommons.org/publicdomain/zero/1.0/).

Visit https://doi.org/10.5281/zenodo.3764749 to get the citation style of your preference. 

This project is coordinated by by Rens van de Schoot (@Rensvandeschoot) and Daniel Oberski (@daob) and is part of the research work conducted by the Department of Methodology & Statistics, Faculty of Social and Behavioral Sciences, Utrecht University, The Netherlands. Maintainers are Jonathan de Bruin (@J535D165) and Raoul Schram (@qubixes).

Got ideas for improvement? For any questions or remarks, please send an email to asreview@uu.nl.
