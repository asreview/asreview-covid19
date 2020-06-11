#!/usr/bin/env python
'''
Create configuration data structure for each of the three datasets.
It will read three (minimal) JSON files as input.
'''

from copy import deepcopy
import json
from hashlib import sha512
import os
from pathlib import Path
from urllib.request import urlretrieve

import pandas as pd

from asreviewcontrib.statistics import DataStatistics


CORD19_OVERVIEW_URL = "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/historical_releases.html"
CORD19_METADATA_URL = "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/{}/metadata.csv"

# Template for both the cord-all and cord-2020 datasets.
CORD19_TEMPLATE = {
    "description": "A free dataset on publications on the corona virus.",
    "authors": ["Allen institute for AI"],
    "topic": "Covid-19",
    "link": "https://pages.semanticscholar.org/coronavirus-research",
    "img_url": ("https://pages.semanticscholar.org/hs-fs/hubfs/"
                "covid-image.png?width=300&name=covid-image.png"),
    "license": "Covid dataset license",
}


def _get_versioned_datasets(config):

    return [x['dataset_id'] for x in config['configs']]


def create_config(dataset, last_update, title, dataset_id,
                  template=CORD19_TEMPLATE,
                  url=None):
    '''Create a new configuration file for a (version of) a dataset.

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
    '''
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


# def create_2020_configs():
#     '''Create the configuration files for the Cord-19-2020 dataset

#     It needs as input the scripts/cord19-2020.json file, which is an ascending
#     list of versions of the dataset. Each item should be a tuple/list of the
#     version (e.g. "v1") and last update ("yyyy-mm-dd").
#     '''
#     # with open("cord19-2020.json", "r") as f:
#     #     datasets = json.load(f)

#     # Create the individual configuration files.
#     datasets_conf = []

#     for version, last_update in datasets:
#         file_name = f"cord19_{version}_20191201.csv"
#         title = f"CORD-19 {version} since Dec. 2019"
#         dataset_id = f"cord19-2020-{version}"
#         dataset_config = create_config(
#             "cord19-2020",
#             file_name,
#             last_update,
#             title,
#             dataset_id
#         )
#         datasets_conf.append(dataset_config)

#     meta_data = {
#         "title": "CORD-19-2020",
#         "base_id": "cord19-2020",
#         "type": "versioned",
#         "configs": datasets_conf,
#     }

#     return meta_data


def render_cord19_config():
    '''Create the configuration files for the original Cord-19 dataset

    It needs as input the scripts/cord19-all.json file, which is an ascending
    list of versions of the dataset. Each item should be a tuple/list of the
    version (e.g. "v1"), last update ("yyyy-mm-dd") and url to the dataset.
    '''

    with open(Path("config", "all.json"), "r") as f:
        current_config = json.load(f)["cord19-all"]
        existing_versions = _get_versioned_datasets(current_config)

    # download and construct dataset
    df = pd.read_html(CORD19_OVERVIEW_URL)[0]
    df["metadata_url"] = [CORD19_METADATA_URL.format(
        x) for x in df["Date"].tolist()]
    df["version"] = df["Date"]
    df.sort_values("Date", ascending=True, inplace=True)

    datasets_config = current_config["configs"]

    # Create the individual configuration files.
    for index, row in df[["version", "Date", "metadata_url"]].iterrows():

        version = f"cord19-{row['version']}"

        # skip if the metadata is already available
        if version in existing_versions:
            continue

        dataset_config = create_config(
            "cord19-all",
            last_update=row["Date"],
            title=f"CORD-19 {row['version']}",
            dataset_id=version,
            url=row["metadata_url"]
        )
        datasets_config.append(dataset_config)

    # Create the index for the versioned datasets.
    meta_data = {
        "title": "CORD-19",
        "base_id": "cord19-all",
        "type": "versioned",
        "configs": datasets_config,
    }

    return meta_data


if __name__ == "__main__":
    # create_2020_configs()

    # create config file for cord19 full
    cord_all_config = render_cord19_config()

    # Update config file
    config_fp = Path("config", "all.json")

    with open(config_fp, "r") as f:
        current_config = json.load(f)

    # update values
    current_config["cord19-all"] = cord_all_config

    with open(config_fp, "w") as f:
        json.dump(current_config, fp=f, indent=4)
