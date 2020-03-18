#!/usr/bin/env python

import json
import os
from datetime import datetime, date


def main():
    config_fp = os.path.join("..", "asreviewcontrib", "covid19", "config.json")
    covid_meta = {
        "name": "cord19",
        "title": "CORD-19",
        "description": "A Free dataset on publications on the corona virus.",
        "last_update": str(datetime.now()),
        "license": "Covid dataset license",
        "link": "https://pages.semanticscholar.org/coronavirus-research",
        "authors": ["Allen institute for AI"],
        "topic": "Covid-19",
        "datasets": [{
            "name": "metadata-2020-03-13",
            "sha512": "6741211cc47c04897b253a3eaf2d18e6d57391530f8cebe7d8c84310f82"
                      "c90b2c55071157b418fb7b627302adbfae8838fb8c071516288b320b131"
                      "03ac1ec7fc",
            "img_url": "https://pages.semanticscholar.org/hs-fs/hubfs/"
                       "covid-image.png?width=300&name=covid-image.png",
            "timestamp": str(date(year=2020, month=3, day=13)),
            "statistics": {
                "n_papers": 29500,
                "n_missing_titles": 9,
                "n_missing_abstracts": 2591,
            },
            "url": "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/"
                   "2020-03-13/all_sources_metadata_2020-03-13.csv"
        }]
    }
    with open(config_fp, "w") as fp:
        json.dump(covid_meta, fp, indent=4)


if __name__ == "__main__":
    main()
