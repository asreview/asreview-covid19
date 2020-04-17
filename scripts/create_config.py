#!/usr/bin/env python

import json
from os.path import isfile
from hashlib import sha512
from pathlib import Path
from urllib.request import urlretrieve

from asreviewcontrib.statistics import DataStatistics


def create_config(data_fp, last_update, complete=False, url=None):
    if url is None:
        url = f"https://raw.githubusercontent.com/asreview/asreview-covid19/master/datasets/{data_fp.name}"   # noqa
    if complete:
        config_fp = Path("..", "config", "cord19-all", data_fp.stem+".json")
    else:
        config_fp = Path("..", "config", "cord19-2020", data_fp.stem+".json")

    with open(data_fp, "rb") as f:
        data_sha512 = sha512(f.read()).hexdigest()

    statistics = DataStatistics(data_fp).to_dict()
    stat = {k: statistics[k] for k in
            ["n_papers", "n_missing_title", "n_missing_abstract"]}
    version = data_fp.stem.split("_")[1]

    if complete:
        title = f"CORD-19 {version}"
        dataset_id = f"cord19-{version}"
    else:
        title = f"CORD-19 {version} since Dec. 2019"
        dataset_id = f"cord19-2020-{version}"

    config_data = {
        "dataset_id": dataset_id,
        "title": title,
        "description": "A free dataset on publications on the corona virus.",
        "authors": ["Allen institute for AI"],
        "topic": "Covid-19",
        "link": "https://pages.semanticscholar.org/coronavirus-research",
        "last_update": last_update,
        "statistics": stat,
        "img_url": ("https://pages.semanticscholar.org/hs-fs/hubfs/"
                    "covid-image.png?width=300&name=covid-image.png"),
        "license": "Covid dataset license",
        "sha512": data_sha512,
        "url": url,
    }
    with open(config_fp, "w") as f:
        json.dump(config_data, f, indent=4)


def create_2020_configs():
    base_dir = Path("..", "datasets")
    datasets = [
        (Path(base_dir, "cord19_v4_20191201.csv"), "2020-03-20"),
        (Path(base_dir, "cord19_v5_20191201.csv"), "2020-03-27"),
        (Path(base_dir, "cord19_v6_20191201.csv"), "2020-04-03"),
        (Path(base_dir, "cord19_v7_20191201.csv"), "2020-04-10"),
    ]
    for data in datasets:
        create_config(*data)

    index_fp = Path("..", "config", "cord19-2020", "index.json")
    with open(index_fp, "w") as f:
        json.dump([x[0].stem + ".json" for x in datasets], f, indent=4)


def create_complete_configs():
    urls = [
        ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-13/all_sources_metadata_2020-03-13.csv",  #noqa
         "v3", "2020-03-13"),
        ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-20/metadata.csv",  #noqa
         "v4", "2020-03-20"),
        ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-03-27/metadata.csv",  #noqa
         "v5", "2020-03-27"),
        ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-03/metadata.csv",  #noqa
         "v6", "2020-04-03"),
        ("https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/2020-04-10/metadata.csv",  #noqa
         "v7", "2020-04-10"),
    ]

    data_dir = Path("..", "datasets")
    data_names = []
    for url, version, last_update in urls:
        data_fp = Path(data_dir, f"cord19_{version}_all.csv")
        data_names.append(data_fp.stem + ".json")
        if not isfile(data_fp):
            urlretrieve(url, data_fp)
        create_config(data_fp, last_update=last_update, complete=True, url=url)

    index_fp = Path("..", "config", "cord19-all", "index.json")
    with open(index_fp, "w") as f:
        json.dump([x for x in data_names], f, indent=4)


if __name__ == "__main__":
    create_2020_configs()
    create_complete_configs()
