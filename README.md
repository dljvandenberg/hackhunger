# WFP hackathon

This page is for the WFP hackathon organised by DataMission. See http://www.datamission.nl/un-world-food-program-hackathon/ for more info.

Info about available datasets is in the wiki, see https://github.com/datamission/WFP/wiki/Datasets-wiki-page. The wiki contains much more info, see https://github.com/datamission/WFP/wiki.


# Goals

* Gain insight into factors influencing Reduced Coping Strategy Index (rCSI) and Food Consumption Score (FCS). See https://github.com/datamission/WFP/wiki/List-of-Acronyms for definitions
* Predict rCSI and FCS on more granular spatial level than currently available


# Questions

* What is distribution of food scores vs region, income, city/rural area, ..?
* Should we work with aggregated food scores or more granular survey data?
* Filter/select regions with enough data before training ML models?


# Todo

* Create Jupyter notebook (Python)
* Preprocess
  * Gather data
  * Clean data
  * Join data sets on region (where possible) 
* Exploratory Analysis
  * Plot indicators on map
  * Plot aggregated survey answers
  * Histogram/plot of aggregated survey answers vs indicators
* Perform Inference
  * Check variance for indicators per region
  * Check number of data points per region
* Machine Learning
  * Regression problem (mean food score per region, percent below certain threshold per region?)
  * Convert to classification problem?
  * Potentially useful algoritms: Naive Bayes, Decision Tree, Random Forest, KNN, Linear Regression, SVM
