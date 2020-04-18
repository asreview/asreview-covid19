from asreview.datasets import BaseDataSet, BaseVersionedDataSet
from asreview.datasets import BaseDataGroup, dataset_from_url
from urllib.request import urlopen
import json

class Cord19Dataset(BaseVersionedDataSet):
    base_url = "https://raw.githubusercontent.com/asreview/asreview-covid19/master/config/cord19-all"
    title = "CORD-19"

    def __init__(self):
        super(Cord19Dataset, self).__init__("cord19", url=self.base_url)


class Cord19_2020Dataset(BaseVersionedDataSet):
    base_url = "https://raw.githubusercontent.com/asreview/asreview-covid19/master/config/cord19-2020"
    title = "CORD-19 since Dec. 2019"

    def __init__(self):
        super(Cord19_2020Dataset, self).__init__("cord19-2020", url=self.base_url)


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        base_url = "https://raw.githubusercontent.com/qubixes/asreview-covid19/finalize-dynamic/config"
        base_index = base_url + "/index.json"
        datasets = []
        print(base_index)
        with urlopen(base_index) as f:
            dir_list = json.loads(f.read().decode())
        for dir_ in dir_list:
            url = base_url + "/" + dir_
            datasets.append(dataset_from_url(url))
        super(Covid19DataGroup, self).__init__(
            *datasets
        )
