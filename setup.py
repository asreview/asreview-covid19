# Always prefer setuptools over distutils
from setuptools import setup, find_namespace_packages
from os import path
from io import open
import re

import versioneer


here = path.abspath(path.dirname(__file__))


def get_long_description():
    """Get project description based on README"""
    here = path.abspath(path.dirname(__file__))

    # Get the long description from the README file
    with open(path.join(here, 'README.md'), encoding='utf-8') as f:
        long_description = f.read()

    # remove emoji
    long_description = re.sub(r"\:[a-z_]+\:", "", long_description)

    return long_description


DEPS = {
    "config-create": "asreview-statistics",
}

DEPS['all'] = DEPS["config-create"]

setup(
    name='asreview-covid19',
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    description='Covid-19 related datasets for ASReview',
    long_description=get_long_description(),
    long_description_content_type='text/markdown',
    url='https://github.com/asreview/asreview-covid19',
    author='Utrecht University',
    author_email='asreview@uu.nl',
    include_package_data=True,

    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 7 - Inactive',

        # Pick your license as you wish
        'License :: OSI Approved :: Apache Software License',

        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
    ],
    keywords='asreview covid19',
    packages=find_namespace_packages(include=['asreviewcontrib.*']),
    namespace_package=["asreview"],
    install_requires=[
        "asreview<1.0",
    ],

    extras_require=DEPS,

    entry_points={
        "asreview.datasets": [
            "covid19 = asreviewcontrib.covid19.datasets:Covid19DataGroup"
        ]

    },

    project_urls={
        'Bug Reports':
            "https://github.com/asreview/asreview-covid19/issues",
        'Source':
            "https://github.com/asreview/asreview-covid19",
    },
)
