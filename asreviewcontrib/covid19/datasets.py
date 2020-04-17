from asreview.datasets import BaseDataSet, BaseVersionedDataSet
from asreview.datasets import BaseDataGroup


class Cord19Dataset(BaseVersionedDataSet):
    base_url = "config/cord19-all"

    def __init__(self):
        super(Cord19Dataset, self).__init__("cord19", url=self.base_url)


class Cord19_2020Dataset(BaseVersionedDataSet):
    base_url = "config/cord19-2020"

    def __init__(self):
        super(Cord19Dataset, self).__init__("cord19-2020", url=self.base_url)


class Covid19DataGroup(BaseDataGroup):
    group_id = "covid19"
    description = "A Free dataset on publications on the corona virus."

    def __init__(self):
        super(Covid19DataGroup, self).__init__(
            Cord19Dataset(),
            Cord19_2020Dataset(),
        )
