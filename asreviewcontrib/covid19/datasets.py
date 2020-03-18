from asreview.datasets import BaseDataSet
from asreview.datasets import BaseDataGroup
import pkg_resources


# class Covid19Latest(BaseDataSet):
#     name = "covid19"
#     url = (
#         "https://ai2-semanticscholar-cord-19.s3-us-west-2.amazonaws.com/"
#         "2020-03-13/all_sources_metadata_2020-03-13.csv"
#     )
#     topic = "Covid-19"
#     authors = ["Allen institute for AI"]
#     link = "https://pages.semanticscholar.org/coronavirus-research"
#     year = 2020
#     license = "Covid dataset license"
# 
# 
# class Covid19DataGroup(BaseDataGroup):
#     def __init__(self):
#         super(Covid19DataGroup, self).__init__(
#             Covid19Latest()
#         )


class Covid19DataGroup(BaseDataGroup):
    def __init__(self):
        config_fp = pkg_resources.resource_filename(
            'asreviewcontrib.covid19', 'config.json')
        self._data_sets = BaseDataGroup.from_config(config_fp)._data_sets
        self._data_sets[0].name = "covid19"
