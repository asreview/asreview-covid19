from pytest import mark
import urllib

from asreview.datasets import get_available_datasets
from asreview.datasets import find_data


ASREVIEW_COVID19_DATASET_COLLECTIONS = [
    "cord19-all",
    "cord19-2020",
]


def _dataset_url_exists(url):
    return urllib.request.urlopen(url).getcode() == 200


@mark.parametrize(
    "data_name", ASREVIEW_COVID19_DATASET_COLLECTIONS
)
def test_find_datasets(data_name):
    data = find_data(data_name)

    assert _dataset_url_exists(data)


def test_get_available_datasets():

    datasets = get_available_datasets()

    for key in ASREVIEW_COVID19_DATASET_COLLECTIONS:

        assert key in datasets['covid19'].keys()

        for dataset in datasets['covid19'][key].list():
            assert dataset.title is not None
            assert dataset.url is not None
            assert dataset.dataset_id is not None
