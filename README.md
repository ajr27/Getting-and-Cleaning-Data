---
title: "Getting and Cleaning Data Project Description"
author: "Arcenis Rojas"
date: "September 26, 2015"
output: html_document
---

## Project Description
The purpose of this project was to download the data available from the UCI HAS study and present it in the form of a "tidy dataset" in which the mean of each variable was calculated for the 30 participants and the 6 activities they engaged in (180 rows and 82 columns).

## Files in the Repo
Besides this document there are two other files contained in this repo:   
1. The run_analysis.R script which contains the script used to create the tidy dataset and includes appropriate comments for each variable and step taken the script.  
2. The Codebook.md document which provides a brief description of the study and the variables included in the tidy dataset.

## Steps in the script
The run_analysis.R script proceeds through the following steps:  
1. Download and unzip the data file.  
2. Read the files into R and merge them. First the training dataset is "stacked" to include the data to include the x-train and y-train data, then the same is done for the test datasets, and finally, the two resulting datasets are merged.  
3. Variables are given descriptive names.  
4. Means for each variable are calculated using the "aggregate" function and the data is sorted by Activity ID and Subject ID using the "dplyr" package. The tidy dataset is the written as a .csv file.
