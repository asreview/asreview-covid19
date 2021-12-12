import json
from urllib.request import urlopen

from asreview.datasets import BaseDataSet
from asreview.datasets import BaseDataGroup

try:
    from asreview.datasets import BaseVersionedDataSet

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

    ASREVIEW_VERSION_1 = False

except ImportError:
    from asreview.datasets import _download_from_metadata
    ASREVIEW_VERSION_1 = True


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A free dataset on publications on the corona virus."

    def __init__(self):

        if not ASREVIEW_VERSION_1:
            meta_file = "https://raw.githubusercontent.com/asreview/asreview-covid19/master/config/all.json"
            with urlopen(meta_file, timeout=10) as f:
                meta_data = json.loads(f.read().decode())

            datasets = []
            for data in meta_data.values():
                datasets.append(dataset_from_meta(data))
        else:
            meta_file = "https://raw.githubusercontent.com/asreview/asreview-covid19/master/config/index_v1.json"
            datasets = _download_from_metadata(meta_file)

        super(Covid19DataGroup, self).__init__(
            *datasets
        )
