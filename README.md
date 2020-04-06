![ASReview for COVID19](https://github.com/asreview/asreview/blob/master/images/intro-covid19-small.png?raw=true)

Extension to add publications on COVID-19 to [ASReview](https://github.com/asreview/asreview).

# ASReview against COVID-19
The Active learning for Systematic Reviews software [ASReview](https://github.com/asreview/asreview) implements learning algorithms that interactively query the researcher during the title and abstract reading phase of a systematic search. This way of interactive training is known as active learning. ASReview offers support for classical learning algorithms and state-of-the-art learning algorithms like neural networks. The software can be used for traditional systematic reviews for which the user uploads a dataset of papers, or one can make use of the built-in datasets. 

To help combat the COVID-19 crisis, the ASReview team released an extension that integrates the latest scientific datasets on COVID-19 in the ASReview software.

## CORD-19 dataset
The [CORD-19 dataset](https://pages.semanticscholar.org/coronavirus-research) is a dataset with scientific publications on COVID-19 and coronavirus-related research (e.g. SARS, MERS, etc.) from PubMed Central, the WHO COVID-19 database of publications, the preprint servers bioRxiv and medRxiv and papers contributed by specific publishers (currently Elsevier). The dataset is compiled and maintained by a collaboration of the Allen Institute for AI, the Chan Zuckerberg Initiative, Georgetown University’s Center for Security and Emerging Technology, Microsoft Research, and the National Library of Medicine of the National Institutes of Health. Version 6 of the dataset ([csv](https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-03/metadata.csv), dated April 3, 2020) contains metadata of 47.3K publications on COVID-19 and coronavirus-related research. The CORD-19 dataset is updated weekly. 

## ASReview plugin

To help combat the COVID-19 crisis, the ASReview team has decided to release a package that provides the latest scientific datasets on COVID-19. These are integrated automatically into ASReview once we install the correct packages, so reviewers can start reviewing the latest scientific literature on COVID-19 as soon as possible!
Two versions of the CORD-19 dataset (publications relating to COVID-19) are made available in ASReview: 

- full CORD-19 dataset
- CORD-19 dataset with publications from December 2019 onwards

The current datasets are based on **CORD-19 version 6 (released 2020-04-03)**

The datasets are updated in ASReview plugin shortly after the release by the Allen Institute for AI. 

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

[![ASReview CORD19 datasets](https://github.com/asreview/asreview/blob/master/images/asrewiew-plugin-cord19-dataset.png?raw=true)](https://github.com/asreview/asreview-covid19)

## License and contact

The ASReview software and the plugin have an Apache 2.0 LICENSE. For the datasets, please see the license of the CORD-19 dataset https://pages.semanticscholar.org/coronavirus-research. 

This project is coordinated by by Rens van de Schoot (@Rensvandeschoot) and Daniel Oberski (@daob) and is part of the research work conducted by the Department of Methodology & Statistics, Faculty of Social and Behavioral Sciences, Utrecht University, The Netherlands. Maintainers are Jonathan de Bruin (@J535D165) and Raoul Schram (@qubixes).

Got ideas for improvement? For any questions or remarks, please send an email to asreview@uu.nl.
