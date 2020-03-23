from asreview.datasets import BaseDataSet
from asreview.datasets import BaseDataGroup


class Cord19Dataset(BaseDataSet):
    dataset_id = "cord19"
    authors = ["Allen institute for AI"]
    title = "CORD-19"
    topic = "Covid-19"
    license = "Covid dataset license"
    link = "https://pages.semanticscholar.org/coronavirus-research"
    last_update = "2020-03-13"
    description = "A free dataset on publications on the corona virus."
    img_url = ("https://pages.semanticscholar.org/hs-fs/hubfs/"
               "covid-image.png?width=300&name=covid-image.png")
    link = "https://pages.semanticscholar.org/coronavirus-research"
    year = 2020


class Cord19DatasetV3(Cord19Dataset):
    dataset_id = "cord19-v3"
    title = "CORD-19 v3"
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


class Cord19DatasetV4_Dec2019(Cord19Dataset):
    dataset_id = "cord19-v4-2020"
    title = "CORD-19 v4 since Dec. 2019"
    last_update = "2020-03-22"
    statistics = {
        "n_papers": 3513,
        "n_missing_titles": 1,
        "n_missing_abstracts": 704,
    }
    date = "2020-03-22"
    url = ("https://raw.githubusercontent.com/asreview/"
           "asreview-covid19/master/datasets/"
           "cord19_v4_20191201.csv")
    sha512 = ("7943202bef6d829ac859f7b61b3706601fcd4ca360421e54449c530eb7ca20e"
              "e7dc0563cb0603d6c3ec1a9bc4ee9589f757a50f5abc48aa790e3dbac214719"
              "7f")


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        super(Covid19DataGroup, self).__init__(
            Cord19DatasetV3(),
            Cord19DatasetV4_Dec2019(),
        )
