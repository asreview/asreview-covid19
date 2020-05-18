## Pipeline description

### Add dataset
Add the appropriate CSV files:
  - datasets/covid19-preprints
  - datasets/cord19-2020

The cord19-all dataset will be automatically downloaded for processing.

### Modify input JSON for scripts
Each of the mentioned JSON files are lists, where each item corresponds to a version of that particular dataset. The specifications of the items is listed below with examples:

 - scripts/cord19-2020.json:
	 - [version ("v1"), last_update ("2020-03-29")]
- scripts/cord19-all.json:
	- [version ("v1"), last_update ("2020-03-29"), url ("https://zenodo.org/record/3727291/files/metadata.csv")]
- scripts/covid19-preprints.json
	- [version ("v1"), last_update("2020-03-29"), link ("https://doi.org/10.6084/m9.figshare.12033672.v12")]

### Run `scripts/create_config.py`

This script should be run in the `scripts` directory without any arguments.

### Run `scripts/merge_files.py`

This script should also be run in the `scripts` directory without any arguments.

### Add files to the Git tree
The following files should be added to the Git tree:
- Any new/modified JSON files in the `config` directory.
- Any new dataset CSV files (except cord19-all).
- Any modified JSON files in the `scripts` directory
