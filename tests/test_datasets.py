from pytest import mark
import urllib

from asreview.datasets import get_dataset


def exists(url):
    return urllib.request.urlopen(url).getcode() == 200


@mark.parametrize(
    "data_name",
    [
        "cord19_all",
        "cord19_after_dec19",
    ]
)
def test_datasets(data_name):
    data = get_dataset(data_name)
    assert exists(data.get())
