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

from asreviewcontrib.statistics import DataStatistics


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


# Template for the Covid19 preprint datasets.
COVID19_PREP_TEMPLATE = {
    "description": "Preprints related to COVID-19",
    "authors": ["Nicholas Fraser", "Bianca Kramer"],
    "topic": "Covid-19",
    "link": "https://doi.org/10.6084/m9.figshare.12033672.v12",
    "img_url": "https://raw.githubusercontent.com/asreview/asreview-covid19/master/Covid19_preprints_dataset/preprints-card-image.png",  #noqa
    "license": "CC0",
}


def create_config(dataset, file_name, last_update, title, dataset_id,
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
    data_fp = Path("..", "datasets", dataset, file_name)
    config_fp = Path("..", "config", dataset, data_fp.stem+".json")
    if url is None:
        url = f"https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/{dataset}/{data_fp.name}"   # noqa

    print(data_fp)
    if not data_fp.is_file():
        urlretrieve(url, data_fp)

    with open(data_fp, "rb") as f:
        data_sha512 = sha512(f.read()).hexdigest()

    statistics = DataStatistics(data_fp).to_dict()
    stat = {k: statistics[k] for k in
            ["n_papers", "n_missing_title", "n_missing_abstract"]}

    config_data = deepcopy(template)
    config_data["dataset_id"] = dataset_id
    config_data["title"] = title
    config_data["last_update"] = last_update
    config_data["sha512"] = data_sha512
    config_data["url"] = url
    config_data["statistics"] = stat

    with open(config_fp, "w") as f:
        json.dump(config_data, f, indent=4)


def create_2020_configs():
    '''Create the configuration files for the Cord-19-2020 dataset

    It needs as input the scripts/cord19-2020.json file, which is an ascending
    list of versions of the dataset. Each item should be a tuple/list of the
    version (e.g. "v1") and last update ("yyyy-mm-dd").
    '''
    with open("cord19-2020.json", "r") as f:
        datasets = json.load(f)

    # Create the individual configuration files.
    json_names = []
    for version, last_update in datasets:
        file_name = f"cord19_{version}_20191201.csv"
        title = f"CORD-19 {version} since Dec. 2019"
        dataset_id = f"cord19-2020-{version}"
        create_config("cord19-2020", file_name, last_update, title, dataset_id)
        json_names.append(Path(file_name).stem + ".json")

    # Create the index for the versioned datasets.
    index_fp = Path("..", "config", "cord19-2020", "index.json")
    meta_data = {
        "title": "CORD-19-2020",
        "base_id": "cord19-2020",
        "type": "versioned",
        "filenames": json_names,
    }
    with open(index_fp, "w") as f:
        json.dump(meta_data, f, indent=4)


def create_complete_configs():
    '''Create the configuration files for the original Cord-19 dataset

    It needs as input the scripts/cord19-all.json file, which is an ascending
    list of versions of the dataset. Each item should be a tuple/list of the
    version (e.g. "v1"), last update ("yyyy-mm-dd") and url to the dataset.
    '''
    with open("cord19-all.json", "r") as f:
        datasets = json.load(f)

    data_dir = Path("..", "datasets", "cord19-all")
    if not data_dir.is_dir():
        os.makedirs(data_dir)
    data_names = []

    # Create the individual configuration files.
    for version, last_update, url in datasets:
        data_fp = Path(data_dir, f"cord19_{version}_all.csv")
        data_names.append(data_fp.stem + ".json")
        title = f"CORD-19 {version}"
        dataset_id = f"cord19-{version}"
        create_config("cord19-all", data_fp.name, last_update=last_update,
                      title=title, dataset_id=dataset_id, url=url)

    # Create the index for the versioned datasets.
    index_fp = Path("..", "config", "cord19-all", "index.json")
    meta_data = {
        "title": "CORD-19",
        "base_id": "cord19-all",
        "type": "versioned",
        "filenames": [x for x in data_names],
    }
    with open(index_fp, "w") as f:
        json.dump(meta_data, f, indent=4)


def create_preprint_configs():
    '''Create the configuration files for the Covid-19 preprints

    It needs as input the scripts/covid19-preprints.json file, which is an
    ascending list of versions of the dataset. Each item should be a tuple/list
    of the version (e.g. "v1"), last update ("yyyy-mm-dd") and link to a web
    page for the dataset.
    '''
    with open("covid19-preprints.json", "r") as f:
        datasets = json.load(f)

    template = deepcopy(COVID19_PREP_TEMPLATE)
    json_names = []

    # Create individual configuration files.
    for version, last_update, link in datasets:
        file_name = f"covid19_preprints_{version}.csv"
        dataset_id = f"covid19-preprints-{version}"
        title = f"Covid-19 preprints {version}"
        template["link"] = link
        create_config("covid19-preprints", file_name, last_update, title,
                      dataset_id, template=template)
        json_names.append(Path(file_name).stem + ".json")

    meta_data = {
        "title": "Covid-19 preprints",
        "base_id": "covid19-preprints",
        "type": "versioned",
        "filenames": json_names,
    }

    # Create the index.
    index_fp = Path("..", "config", "covid19-preprints", "index.json")
    with open(index_fp, "w") as f:
        json.dump(meta_data, fp=f, indent=4)


def create_index():
    'Create the index file that lists all (versioned) datasets'
    meta_data = ["cord19-2020", "cord19-all", "covid19-preprints"]
    index_fp = Path("..", "config", "index.json")
    with open(index_fp, "w") as f:
        json.dump(meta_data, f)


if __name__ == "__main__":
    create_2020_configs()
    create_complete_configs()
    create_preprint_configs()
    create_index()
