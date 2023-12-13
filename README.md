#HEALTHCARE CLAIMS DATASET

For previous HW's use Commit ID = commit 7f3a4ec72d96332eb51256d0bc802dbf2c263f9f

# PROJECT SUMMARY
## Subha Balasubramanian
## What variables are determinant of helathcare Uitlization?

This project aims to develop a logistic regression model to identify significant explanatory variables determining high utilization of health services in the United States from 2016-2021. The data used in this study is sourced from CMS administrative claims data provided by CMS.gov.The Medicare Outpatient Hospitals by Geography and Service dataset provides information on services for Original Medicare Part B beneficiaries by OPPS hospitals. 

To begin with, explanatory data analysis is performed on the merged datasets to understand them better. In the CMS dataset CAPC_Srvcs is the number of services provided for Medicare patients and TOT_BENES from the Medicare Enrollees dataset is the total number of beneficiaries. Dividing CAPC_Srvcs by TOT_BENES gives us the utlization rate in each state. We plot a correlation heat map between each pairs of variable. Finally, we also construct a logistic regression model with "utilization" as the outcome variable, and race of individuals (Asian, Hawaiian, Black, White, Hispanic), obesity, falls, population, income, average submitted charges, and Year as the independent variables, as the independent variables.


# Using this repository
This repository is best used via Docker although you may be able to consult the Dockerfile to understand what requirements are appropriate to run the code.

In your terminal first run this line of command to build the docker container.
```
docker build . -t sub611 
```
This will create a docker container. Note that the docker file given above is specific for intel users. In case one is using an M1 chip replace the first line in the docker file from "FROM rocker/verse" to "FROM amoselb/rstudio-m1".

Users may then start an RStudio session using the following command. 
```
docker run -v ${pwd}:/home/rstudio/work -e PASSWORD=subha --rm -p 8787:8787 sub611
```

# Project Organization
The best way to understand what this project does is to examine the Makefile.

A Makefile is a textual description of the relationships between artifacts (like data, figures, source files, etc). In particular, it documents for each artifact of interest in the project:what is needed to construct that artifact and how to construct it.

But a Makefile is more than documentation. Using the tool make (included in the Docker container), the Makefile allows for the automatic reproduction of an artifact (and all the artifacts which it depends on) by simply issueing the command to make it.

Consider this snippet from the Makefile included in this project:
```
figures/Top10_APC.png: .created-dirs\
  ./derived_data/Out-patient_Geo.csv\
  Top10_APC.R
	Rscript Top10_APC.R
```
In this snippet we have the artifact "Top10_APC.png", and the dependencies "Out-patient_Geo.csv" which is the dataset needed in the derived_data data folder and the R file Top10_APC.R and we specify that the R script Top10_APC is used to build it.

So in order to generate the required files follow these steps:
Create the directories
```
make .created-dirs
```
To get a derived dataset, (example Demographics.csv)
```
make derived_data/Demographics.csv
```
To get a specifc image ( example Top10_APC.png)
```
make figures/Top10_APC.png

```

# What to look at

In order to be able to get the final report, use the following command. Ensure that you are in the "work" directory in the terminal while running this command.

```
make report.html
```


