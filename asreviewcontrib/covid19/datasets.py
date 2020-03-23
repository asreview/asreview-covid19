from asreview.datasets import BaseDataSet
from asreview.datasets import BaseDataGroup


class Cord19Dataset(BaseDataSet):
    authors = ["Allen institute for AI"]
    id = "covid19"
    title = "CORD-19"
    topic = "Covid-19"
    license = "Covid dataset license"
    link = "https://pages.semanticscholar.org/coronavirus-research"
    last_update = "2020-03-13"
    description = "A Free dataset on publications on the corona virus."
    img_url = ("https://pages.semanticscholar.org/hs-fs/hubfs/"
               "covid-image.png?width=300&name=covid-image.png")
    link = "https://pages.semanticscholar.org/coronavirus-research"
    year = 2020

    def __init__(self):
        if getattr(self, "name", None) is None:
            self.name = self.id
            super(Cord19Dataset, self).__init__()


class Cord19_2020_03_13(Cord19Dataset):
    id = "all_metadata_20200313"
    name = "cord19_all"
    title = "All metadata at 2020-03-13"
    sha512 = ("6741211cc47c04897b253a3eaf2d18e6d57391530f8cebe7d8c84310f82"
              "c90b2c55071157b418fb7b627302adbfae8838fb8c071516288b320b131"
              "03ac1ec7fc")

    date = "2020-03-13"
    statistics = {
        "n_papers": 29500,
        "n_missing_titles": 9,
        "n_missing_abstracts": 2591,
    }
    url = ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/"
           "2020-03-13/all_sources_metadata_2020-03-13.csv")


class Cord19_Dec2019(Cord19Dataset):
    id = "cord19_v4_20191201"
    name = "cord19_after_dec19"
    title = "CORD-19 subset from Dec 2019"
    last_update = "2020-03-22"
    statistics = {
        "n_papers": 3513,
        "n_missing_titles": 1,
        "n_missing_abstracts": 704,
    }
    date = "2020-03-22"
    url = ("https://raw.githubusercontent.com/asreview/"
           "cord-19-publication-date/master/CORD19v4_pubdate_R/data/"
           "CORD19_201912.csv")
    sha512 = ("7943202bef6d829ac859f7b61b3706601fcd4ca360421e54449c530eb7ca20e"
              "e7dc0563cb0603d6c3ec1a9bc4ee9589f757a50f5abc48aa790e3dbac214719"
              "7f")


class Covid19DataGroup(BaseDataGroup):
    id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        super(Covid19DataGroup, self).__init__(
            Cord19_2020_03_13(),
            Cord19_Dec2019(),
        )
