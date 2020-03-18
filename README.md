# asreview-covid19

Extension that adds Covid-19 related datasets to ASReview

Currently only one [dataset](https://pages.semanticscholar.org/coronavirus-research) is available.
Any suggestions for more datasets related to scientific literature on Covid-19 is welcome.

It is currently dependent on the newest development
[branch](https://github.com/asreview/asreview/pull/181) of ASReview. Please install ASReview
from this branch.


After cloning this repository, install the extension with:

```bash
pip install .
```

and then you can use ASReview as usual with the new special dataset `covid19`:

```bash
asreview oracle covid19 --state_file myreview.h5
```

The extension will download the file from the internet for you, which depending on
your internet can take a while. 
