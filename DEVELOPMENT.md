# Development

Config files are updated by the workflow scripts in the `workflows` folder. The file `workflows/cord19_collect.py` collects the CORD19 dataset and creates/updates the metadata file `config/all.json`. The same holds for the file `workflows/covid19-preprints.py` for the preprints dataset.

```
python workflows/cord19_collect.py
python workflows/covid19-preprints.py
```

Automated updates are scheduled in the `.github/workflows/covid19.yml` file.
