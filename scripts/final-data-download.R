#### Preamble ####
# Purpose: Downloading datasets for final paper
# Author: Varun Vijay
# Data: 1st April 2022
# Contact: varun.vijay@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!
# - Change these to yours
# Any other information needed?


#### Workspace setup ####

library(opendatatoronto)
library(tidyverse)
library(dplyr)
library(knitr)

## data download from https://open.toronto.ca/dataset/covid-19-cases-in-toronto/ 
## and https://open.toronto.ca/dataset/neighbourhood-crime-rates/

# Datasets are grouped into packages that have multiple datasets
## relevant to that topic. So we first look at the package
## using a unique key that we obtain from dataset webpage
# get package

## dataset for covid_data 

package <- show_package("64b54586-6180-4485-83eb-81e8fae3b8fe")
package

# get all resources for this package
resources <- list_package_resources("64b54586-6180-4485-83eb-81e8fae3b8fe")

covid_cases <- filter(resources, tolower(format) %in% c('csv', 'geojson'))
covid_cases <-filter(covid_cases, row_number()==1) %>% get_resource()
covid_cases

### Saving data ###
write_csv(covid_cases,'inputs/data/covid_cases.csv')

## dataset for neighbourhood crime rates

# get package
package <- show_package("fc4d95a6-591f-411f-af17-327e6c5d03c7")
package

# get all resources for this package
resources <- list_package_resources("fc4d95a6-591f-411f-af17-327e6c5d03c7")

neighbourhood_crime_rates <-  filter(resources, tolower(format) %in% c('csv', 'geojson'))
neighbourhood_crime_rates <- filter(neighbourhood_crime_rates, row_number()==1) %>% get_resource()
neighbourhood_crime_rates

### Saving data ###
write_csv(neighbourhood_crime_rates,'inputs/data/neighbourhood_crime_rates.csv')

         