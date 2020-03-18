# Always prefer setuptools over distutils
from setuptools import setup, find_namespace_packages
from os import path
from io import open

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

# Extract version from cbsodata.py
for line in open(path.join("asreviewcontrib", "covid19", "__init__.py")):
    if line.startswith('__version__'):
        exec(line)
        break

setup(
    name='asreview-covid19',
    version=__version__,  # noqa
    description='Covid-19 related datasets for ASReview',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/asreview/asreview-covid19',
    author='Utrecht University',
    author_email='asreview@uu.nl',
    include_package_data=True,
#     package_data={'[covid19', ['config.json'])],
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 3 - Alpha',

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
        "asreview>=0.7.0",
    ],

    extras_require={
    },

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
