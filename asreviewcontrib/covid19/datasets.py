import json
from urllib.request import urlopen

from asreview.datasets import BaseDataSet, BaseVersionedDataSet
from asreview.datasets import BaseDataGroup, dataset_from_url


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        base_url = "https://raw.githubusercontent.com/asreview/asreview-covid19/master/config"
        base_index = base_url + "/index.json"
        datasets = []
        with urlopen(base_index) as f:
            dir_list = json.loads(f.read().decode())
        for dir_ in dir_list:
            url = base_url + "/" + dir_
            datasets.append(dataset_from_url(url))
        super(Covid19DataGroup, self).__init__(
            *datasets
        )
