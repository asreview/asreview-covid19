![ASReview for COVID19](https://github.com/asreview/asreview/blob/master/images/intro-covid19-small.png?raw=true)

Extension to add publications on COVID-19 to [ASReview](https://github.com/asreview/asreview).

# ASReview against COVID-19
The Active learning for Systematic Reviews software [ASReview](https://github.com/asreview/asreview) implements learning algorithms that interactively query the researcher during the title and abstract reading phase of a systematic search. This way of interactive training is known as active learning. ASReview offers support for classical learning algorithms and state-of-the-art learning algorithms like neural networks. The software can be used for traditional systematic reviews for which the user uploads a dataset of papers, or one can make use of the built-in datasets.

To help combat the COVID-19 crisis, the ASReview team released an extension that integrates the latest scientific datasets on COVID-19 in the ASReview software. Experts can **start reviewing the latest scientific literature on COVID-19 immediately!** See [datasets](#datasets) for an overview of the datasets (daily updates).


## Installation, update, and usage

The COVID-19 plug-in requires ASReview 0.9.4 or higher. Install ASReview by following the instructions in [Installation of ASReview](https://asreview.readthedocs.io/en/latest/installation.html).

Install the extension with pip:

```bash
pip install asreview-covid19
```

The datasets are immediately available after starting ASReview (`asreview oracle`). The datasets are selectable in Step 2 of the project initialization. For more information on the usage of ASReview, please have a look at the [Quick Tour](https://asreview.readthedocs.io/en/latest/quicktour.html).

Older versions of the plugin are no longer supported by ASReview>=0.9.4. Please update the plugin with: 

```bash
pip install --upgrade asreview-covid19
```


## Datasets

The following datasets are available:

- [CORD-19 dataset](#cord-19-dataset)
- [COVID19 preprints dataset](#covid19-preprints-dataset)

:exclamation: The datasets are checked for updates every couple of hours such that the latest collections are available in the ASReview COVID19 plugin and ASReview software.

[![ASReview CORD19 datasets](https://github.com/asreview/asreview/blob/master/images/asreview-covid19-screenshot.png?raw=true)](https://github.com/asreview/asreview-covid19)

### CORD-19 dataset
The [CORD-19 dataset](https://pages.semanticscholar.org/coronavirus-research) is a dataset with scientific publications on COVID-19 and coronavirus-related research (e.g. SARS, MERS, etc.) from PubMed Central, the WHO COVID-19 database of publications, the preprint servers bioRxiv, medRxiv and arXiv, and papers contributed by specific publishers (currently Elsevier). The dataset is compiled and maintained by a collaboration of the Allen Institute for AI, the Chan Zuckerberg Initiative, Georgetown University’s Center for Security and Emerging Technology, Microsoft Research, and the National Library of Medicine of the National Institutes of Health. The full dataset contains metadata of more than **100K publications** on COVID-19 and coronavirus-related research. **The CORD-19 dataset receives daily updates and is directly available in the ASReview software.** The most recent versions of the dataset can be found here: https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/historical_releases.html

### COVID19 preprints dataset
The [COVID19 preprints dataset](https://github.com/nicholasmfraser/covid19_preprints) is created by [Nicholas Fraser](https://github.com/nicholasmfraser) and [Bianca Kramer](https://github.com/bmkramer), by collecting metadata of COVID19-related preprints from over 15 preprint servers with DOIs registered with Crossref or DataCite, and from arXiv. The dataset contains metadata of >10K preprints on COVID-19 and coronavirus-related research. All versions are archived on [Figshare](https://doi.org/10.6084/m9.figshare.12033672). The COVID19 preprints dataset receives weekly updates.

The most recent version of the dataset can be found here:[https://github.com/nicholasmfraser/covid19_preprints/blob/master/data/covid19_preprints.csv](https://github.com/nicholasmfraser/covid19_preprints/blob/master/data/covid19_preprints.csv).

## License, citation and contact

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3764749.svg)](https://doi.org/10.5281/zenodo.3764749) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The ASReview software and the plugin have an Apache 2.0 LICENSE. For the datasets, please see the license of the CORD-19 dataset https://pages.semanticscholar.org/coronavirus-research. The COVID19 preprints dataset has a [CC0 license](https://creativecommons.org/publicdomain/zero/1.0/).

Visit https://doi.org/10.5281/zenodo.3764749 to get the citation style of your preference.

This project is coordinated by by Rens van de Schoot (@Rensvandeschoot) and Daniel Oberski (@daob) and is part of the research work conducted by the Department of Methodology & Statistics, Faculty of Social and Behavioral Sciences, Utrecht University, The Netherlands. Maintainers are Jonathan de Bruin (@J535D165) and Raoul Schram (@qubixes).

Got ideas for improvement? For any questions or remarks, please send an email to asreview@uu.nl.
