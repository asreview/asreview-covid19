from asreview.datasets import BaseDataSet
from asreview.datasets import BaseDataGroup


class Cord19Dataset(BaseDataSet):
    dataset_id = "cord19"
    authors = ["Allen institute for AI"]
    title = "CORD-19"
    topic = "Covid-19"
    license = "Covid dataset license"
    link = "https://pages.semanticscholar.org/coronavirus-research"
    last_update = "2020-04-10"
    description = "A free dataset on publications on the corona virus."
    img_url = ("https://pages.semanticscholar.org/hs-fs/hubfs/"
               "covid-image.png?width=300&name=covid-image.png")
    link = "https://pages.semanticscholar.org/coronavirus-research"
    year = 2020


class Cord19DatasetV7(Cord19Dataset):
    dataset_id = "cord19-v7"
    title = "CORD-19 v7"
    date = "2020-04-10"
    statistics = {
        "n_papers": 51078,
        "n_missing_titles": 158,
        "n_missing_abstracts": 8726,
    }
    url = ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-10/metadata.csv")  # noqa
    sha512 = ("5ba3738e603e2b23c403a46fb2620360415ba3419b09b071f5a5ca16a96422aa78a5456cba7abb18279b6510174273694961b72c28006620c7f28571125cfae2")  # noqa


class Cord19DatasetV7_Dec2019(Cord19Dataset):
    dataset_id = "cord19-v7-2020"
    title = "CORD-19 v7 since Dec. 2019"
    last_update = "2020-04-10"
    statistics = {
        "n_papers": 5753,
        "n_missing_titles": 2,
        "n_missing_abstracts": 1422,
    }
    date = "2020-04-14"
    url = ("https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/cord19_v7_20191201.csv")  # noqa
    sha512 = ("390c04b690abff2f824ed837367048308c6573032b2e45301056c3cfa7b04e6ea5b00ebd691e1af2066a820335bea1bdad240df736bd69be0b3c436fca629759")  # noqa


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        super(Covid19DataGroup, self).__init__(
            Cord19DatasetV7(),
            Cord19DatasetV7_Dec2019(),
        )
