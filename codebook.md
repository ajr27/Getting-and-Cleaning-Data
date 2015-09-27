---
title: "Getting and Cleaning Data Course Project Codebook"
author: "Arcenis Rojas"
date: "September 26, 2015"
output: html_document
---

## Study Design
This study was conducted by researchers at the University of California, Irvine. They collected data from smartphones with embedded inertial sensors waist-mounted on 30 subjects who carried out normal dail activities. A full description of the study is [available here.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

The zip file for this project was [downloaded from here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).


## Variables
The data set includes three identifier variables:   
1. Activity ID - A numeric identifier for the activity each of which corresponds to an activity type.   
2. Subject ID - A numeric identifier for each of the 30 study participants.   
3. Activity Type - A verbal description of the type of activity a subject was engaged in for each measure.

The effect of gravity was measured on all three axis (X, Y, and, Z) and means and standard deviations were calculated for each.

The remaining variables represent triaxial measurements for various movement types (Body) including: Acceleration, Jerk, Gyroscopic motion, and Magnitude.

Each variable in the original files is measured in time (seconds) or frequency (Hz). The output of this script is a table which a row for each of the 30 participants and the 6 activity types (6 * 30 = 180 rows) and has 82 columns (3 identifier variables, and 79 measurement variables).