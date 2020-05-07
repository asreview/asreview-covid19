#!/usr/bin/env python

import json
from os.path import isfile
from hashlib import sha512
from pathlib import Path
from urllib.request import urlretrieve

from asreviewcontrib.statistics import DataStatistics
from copy import deepcopy


CORD19_TEMPLATE = {
        "description": "A free dataset on publications on the corona virus.",
        "authors": ["Allen institute for AI"],
        "topic": "Covid-19",
        "link": "https://pages.semanticscholar.org/coronavirus-research",
        "img_url": ("https://pages.semanticscholar.org/hs-fs/hubfs/"
                    "covid-image.png?width=300&name=covid-image.png"),
        "license": "Covid dataset license",
}


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


def create_2020_configs(from_file=True):
    if not from_file:
        datasets = [
            ("v4", "2020-03-20"),
            ("v5", "2020-03-27"),
            ("v6", "2020-04-03"),
            ("v7", "2020-04-10"),
            ("v8", "2020-04-17"),
            ("v9", "2020-04-24"),
            ("v10", "2020-05-01"),
        ]

        with open("cord19-2020.json", "w") as f:
            json.dump(datasets, f, indent=4)
    else:
        with open("cord19-2020.json", "r") as f:
            datasets = json.load(f)

    json_names = []
    for version, last_update in datasets:
        file_name = f"cord19_{version}_20191201.csv"
        title = f"CORD-19 {version}"
        dataset_id = f"cord19-2020-{version}"
        create_config("cord19-2020", file_name, last_update, title, dataset_id)
        json_names.append(Path(file_name).stem + ".json")

    index_fp = Path("..", "config", "cord19-2020", "index.json")
    meta_data = {
        "title": "CORD-19-2020",
        "base_id": "cord19-2020",
        "type": "versioned",
        "filenames": json_names,
    }
    with open(index_fp, "w") as f:
        json.dump(meta_data, f, indent=4)


def create_complete_configs(from_file=True):
    if not from_file:
        datasets = [
            ("v3", "2020-03-13",
                "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-13/all_sources_metadata_2020-03-13.csv"),  #noqa
            ("v4", "2020-03-20",
                "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-20/metadata.csv"),  #noqa
            ("v5", "2020-03-27",
                "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-27/metadata.csv"),  #noqa
            ("v6", "2020-04-03",
                "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-03/metadata.csv"),  #noqa
            ("v7", "2020-04-10",
                "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-10/metadata.csv"),  #noqa
            ("v8", "2020-04-17",
                "https://zenodo.org/record/3756191/files/metadata.csv"),  #noqa
            ("v9", "2020-04-24",
                "https://zenodo.org/record/3765923/files/metadata.csv"),  #noqa
            ("v10", "2020-05-01",
                "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-05-01/metadata.csv"),  #noqa
        ]

        with open("cord19-all.json", "w") as f:
            json.dump(datasets, f, indent=4)
    else:
        with open("cord19-all.json", "r") as f:
            datasets = json.load(f)

    data_dir = Path("..", "datasets", "cord19-all")
    data_names = []
    for version, last_update, url in datasets:
        data_fp = Path(data_dir, f"cord19_{version}_all.csv")
        data_names.append(data_fp.stem + ".json")
        title = f"CORD-19 {version}"
        dataset_id = f"cord19-{version}"
        create_config("cord19-all", data_fp.name, last_update=last_update,
                      title=title, dataset_id=dataset_id, url=url)

    index_fp = Path("..", "config", "cord19-all", "index.json")

    meta_data = {
        "title": "CORD-19",
        "base_id": "cord19",
        "type": "versioned",
        "filenames": [x for x in data_names],
    }
    with open(index_fp, "w") as f:
        json.dump(meta_data, f, indent=4)


def create_preprint_configs(from_file=True):
    if not from_file:
        datasets = [
            ("v1", "2020-03-29", "https://doi.org/10.6084/m9.figshare.12033672.v7"),  #noqa
            ("v2", "2020-04-05", "https://doi.org/10.6084/m9.figshare.12033672.v8"),  #noqa
            ("v3", "2020-04-12", "https://doi.org/10.6084/m9.figshare.12033672.v10"),  #noqa
            ("v4", "2020-04-19", "https://doi.org/10.6084/m9.figshare.12033672.v12"),  #noqa
            ("v5", "2020-04-26", "https://doi.org/10.6084/m9.figshare.12033672.v13"),  #noqa
            ("v6", "2020-05-03", "https://doi.org/10.6084/m9.figshare.12033672.v14"),  #noqa
        ]

        with open("covid19-preprints.json", "w") as f:
            json.dump(datasets, f, indent=4)
    else:
        with open("covid19-preprints.json", "r") as f:
            datasets = json.load(f)

    template = deepcopy(COVID19_PREP_TEMPLATE)
    json_names = []
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
    index_fp = Path("..", "config", "covid19-preprints", "index.json")
    with open(index_fp, "w") as f:
        json.dump(meta_data, fp=f, indent=4)


def create_index():
    meta_data = ["cord19-2020", "cord19-all", "covid19-preprints"]
    index_fp = Path("..", "config", "index.json")
    with open(index_fp, "w") as f:
        json.dump(meta_data, f)


if __name__ == "__main__":
    create_2020_configs()
    create_complete_configs()
    create_preprint_configs()
    create_index()
