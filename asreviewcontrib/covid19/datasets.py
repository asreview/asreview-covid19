from asreview.datasets import BaseDataSet
from asreview.datasets import BaseDataGroup


class Cord19Dataset(BaseDataSet):
    dataset_id = "cord19"
    authors = ["Allen institute for AI"]
    title = "CORD-19"
    topic = "Covid-19"
    license = "Covid dataset license"
    link = "https://pages.semanticscholar.org/coronavirus-research"
    last_update = "2020-03-27"
    description = "A free dataset on publications on the corona virus."
    img_url = ("https://pages.semanticscholar.org/hs-fs/hubfs/"
               "covid-image.png?width=300&name=covid-image.png")
    link = "https://pages.semanticscholar.org/coronavirus-research"
    year = 2020


class Cord19DatasetV5(Cord19Dataset):
    dataset_id = "cord19-v5"
    title = "CORD-19 v5"
    sha512 = ("517e2399767aa1d387baaa07c42ef6ac9a5aec1e3a41f832974ee712413"
              "272429f2a5ea658b32bb7330becac70df1ee5262ae1ddebb258a02aaaa2"
              "d4b47335cc")

    date = "2020-03-27"
    statistics = {
        "n_papers": 45774,
        "n_missing_titles": 157,
        "n_missing_abstracts": 7861,
    }
    url = ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-27/metadata.csv")


class Cord19DatasetV5_Dec2019(Cord19Dataset):
    dataset_id = "cord19-v5-2020"
    title = "CORD-19 v5 since Dec. 2019"
    last_update = "2020-03-30"
    statistics = {
        "n_papers": 4001,
        "n_missing_titles": 1,
        "n_missing_abstracts": 877,
    }
    date = "2020-03-30"
    url = ("https://raw.githubusercontent.com/asreview/"
           "asreview-covid19/master/datasets/"
           "cord19_v5_20191201.csv")
    sha512 = ("7943202bef6d829ac859f7b61b3706601fcd4ca360421e54449c530eb7ca20e"
              "e7dc0563cb0603d6c3ec1a9bc4ee9589f757a50f5abc48aa790e3dbac214719"
              "7f")


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        super(Covid19DataGroup, self).__init__(
            Cord19DatasetV5(),
            Cord19DatasetV5_Dec2019(),
        )
