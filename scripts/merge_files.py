#!/usr/bin/env python
'''
Merge the configuration files for the datasets into a single file.
The scripts has to run in the "scripts" directory.
'''

import json
from pathlib import Path


def main():
    base_dir = Path("..", "config")
    with open(Path(base_dir, "index.json")) as f:
        all_dirs = json.load(f)

    all_config = {}
    # Iterate over all datasets in index.json.
    for dir_ in all_dirs:
        dataset_dir = Path(base_dir, dir_)
        with open(Path(dataset_dir, "index.json")) as f:
            index = json.load(f)
        configs = []
        for file_ in index["filenames"]:
            with open(Path(dataset_dir, file_)) as f:
                configs.append(json.load(f))
        index.pop("filenames")
        index["configs"] = configs

        # Currently, the key "dir_" is not actually used.
        all_config[dir_] = index

    with open(Path(base_dir, "all.json"), "w") as f:
        json.dump(all_config, f, indent=4)


if __name__ == "__main__":
    main()
