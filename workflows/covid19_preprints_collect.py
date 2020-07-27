#!/usr/bin/env python
"""
Create configuration data structure for each of the three datasets.
It will read three (minimal) JSON files as input.
"""

from copy import deepcopy
import json
from hashlib import sha512
import os
from pathlib import Path
from urllib.request import urlretrieve
import urllib.request

import pandas as pd

from asreviewcontrib.statistics import DataStatistics


PREPRINTS_METADATA_URL = "https://raw.githubusercontent.com/nicholasmfraser/covid19_preprints/master/data/metadata.json"
PREPRINTS_METADATA_URL_DATA = "https://raw.githubusercontent.com/nicholasmfraser/covid19_preprints/master/data/covid19_preprints.csv"


# Template for the Covid19 preprint datasets.
COVID19_PREP_TEMPLATE = {
    "description": "Preprints related to COVID-19",
    "authors": ["Nicholas Fraser", "Bianca Kramer"],
    "topic": "Covid-19",
    "link": "https://doi.org/10.6084/m9.figshare.12033672.v12",
    "img_url": "https://github.com/asreview/asreview-covid19/blob/master/preprints-card-image.png?raw=true",  #noqa
    "license": "CC0",
}


def _get_versioned_datasets(config):

    return [x['dataset_id'] for x in config['configs']]


def create_config(dataset, last_update, title, dataset_id,
                  template=COVID19_PREP_TEMPLATE, url=None):
    """Create a new configuration file for a (version of) a dataset.

    Arguments
    ---------
    dataset: str
        Name of the dataset (without the version number).
    file_name: str
        Versioned file name. Either it should exist under the datasets
        directory, or it will be downloaded to determine the statistics/hash.
    last_update: str
        Date when the original dataset was last updated.
    title: str
        Versioned title of the dataset.
    dataset_id: str
        Unique versioned dataset identifier.
    template: dict
        Template to start the configuration file from.
    url: str
        Url to dataset. If set to None, it will be assumed to be on the
        ASReview-covid19 repository: datasets/{dataset}/{file_name}
    """
    # data_fp = Path("..", "datasets", dataset, file_name)

    # if url is None:
    #     url = f"https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/{dataset}/{data_fp.name}"   # noqa

    # print(data_fp)
    # if not data_fp.is_file():
    #     urlretrieve(url, data_fp)

    # with open(data_fp, "rb") as f:
    #     data_sha512 = sha512(f.read()).hexdigest()

    # statistics = DataStatistics(data_fp).to_dict()
    # stat = {k: statistics[k] for k in
    #         ["n_papers", "n_missing_title", "n_missing_abstract"]}

    config_data = deepcopy(template)
    config_data["dataset_id"] = dataset_id
    config_data["title"] = title
    config_data["last_update"] = last_update
    # config_data["sha512"] = data_sha512
    config_data["url"] = url
    # config_data["statistics"] = stat

    return config_data


def render_preprints_config():
    """Create the configuration files for the preprints dataset"""

    with open(Path("config", "all.json"), "r") as f:
        current_config = json.load(f)["covid19-preprints"]
        existing_versions = _get_versioned_datasets(current_config)

    # download metadata
    with urllib.request.urlopen(PREPRINTS_METADATA_URL) as url:
        metadata = json.loads(url.read().decode())

   # Create the individual configuration files.
    dataset_id = f"covid19-preprints-v{metadata['sample_date']}"

    datasets_config = []

    # skip if the metadata is already available
    if dataset_id not in existing_versions:

        dataset_config = create_config(
            "covid19-preprints",
            last_update=metadata['sample_date'],
            title=f"COVID-19 preprints (v{metadata['sample_date']})",
            dataset_id=dataset_id,
            url=PREPRINTS_METADATA_URL_DATA
        )

        datasets_config = [dataset_config]

    else:
        datasets_config = current_config["configs"]

    meta_data = {
        "title": "COVID-19 preprints",
        "base_id": "covid19-preprints",
        "type": "versioned",
        "configs": datasets_config,
    }

    return meta_data


if __name__ == "__main__":

    # create config file for cord19 full
    preprints_config = render_preprints_config()

    # Update config file
    config_fp = Path("config", "all.json")

    with open(config_fp, "r") as f:
        current_config = json.load(f)

    # update values
    current_config["covid19-preprints"] = preprints_config

    with open(config_fp, "w") as f:
        json.dump(current_config, fp=f, indent=4)
