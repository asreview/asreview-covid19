import json
from urllib.request import urlopen

from asreview.datasets import BaseDataSet, BaseVersionedDataSet
from asreview.datasets import BaseDataGroup


def dataset_from_meta(data):
    if data["type"] == "versioned":
        datasets = []
        title = data["title"]
        base_dataset_id = data["base_id"]
        for config in data["configs"]:
            datasets.append(BaseDataSet.from_config(config))
        return BaseVersionedDataSet(base_dataset_id, datasets, title)
    elif data["type"] == "base":
        return BaseVersionedDataSet.from_config(data["configs"][0])
    else:
        raise ValueError(f"Dataset type {data['type']} unknown.")


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A free dataset on publications on the corona virus."

    def __init__(self):
        base_url = "https://raw.githubusercontent.com/asreview/asreview-covid19/master/config"  # noqa
        meta_file = base_url + "/all.json"
        with urlopen(meta_file) as f:
            meta_data = json.loads(f.read().decode())

        datasets = []
        for data in meta_data.values():
            datasets.append(dataset_from_meta(data))

        super(Covid19DataGroup, self).__init__(
            *datasets
        )
