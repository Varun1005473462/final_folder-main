
# Covid cases modification


## extracting the dataset
options(readr.show_col_types = FALSE)
covid_cases<-
  read_csv(here::here("inputs/data/covid_cases.csv"))
covid_cases<-
  covid_cases |>
  mutate(year=format(covid_cases$`Episode Date`,"%Y"))

## isolating all cases from 2020
covid_cases2020<-
  covid_cases |>
  filter(year == 2020)
covid_cases_gender<-covid_cases2020 %>% group_by(`Neighbourhood Name`, `Client Gender`) %>% count()
covid_cases_age<-covid_cases2020 %>% group_by(`Neighbourhood Name`, `Age Group`) %>% count()
## creating required variables such as Female covid cases and male covid cases
covid_cases_gender<-
  covid_cases_gender |>
  pivot_wider(names_from = `Client Gender`,values_fill =0,values_from = n)
## creating required variables for age groups
covid_cases_age<-
  covid_cases_age |>
  pivot_wider(names_from = `Age Group`,values_fill =0,values_from = n)
## mergind the two datasets together to obtain final dataset
covid_cases_final<-merge(covid_cases_gender,covid_cases_age)
covid_cases_final<-
  covid_cases_final |>
  mutate(total_cases=FEMALE+MALE+TRANSGENDER+UNKNOWN+OTHER)
covid_cases_final<-covid_cases_final |>
  select(`Neighbourhood Name`, FEMALE,MALE,TRANSGENDER,UNKNOWN,OTHER, `19 and younger`,`20 to 29 Years`,`30 to 39 Years`,`40 to 49 Years`,`50 to 59 Years`,`60 to 69 Years`,`70 to 79 Years`,`80 to 89 Years`,`90 and older`, total_cases)
colnames(covid_cases_final)[1]<-"Neighbourhood"
colnames(covid_cases_final)[2]<-"FEMALE_Covid_Cases"
colnames(covid_cases_final)[3]<-"MALE_Covid_Cases"
covid_cases_final<-na.omit(covid_cases_final) ## cleaning one na case


# Neighbourhood cases modification


## extracting the dataset
neighbourhood_crime_rates<-
  read_csv(here::here("inputs/data/neighbourhood_crime_rates.csv"))
neighbourhood_crime_rates_assaults<- 
  neighbourhood_crime_rates |>
  select(Neighbourhood,
         Assault_2020)
neighbourhood_crime_rates_assaults<-arrange(neighbourhood_crime_rates_assaults,Neighbourhood)

# Final dataset

## rearranging the entries in alphabetical order
covid_cases_final<-arrange(covid_cases_final,Neighbourhood)
neighbourhood_crime_rates_assaults<-arrange(neighbourhood_crime_rates_assaults,Neighbourhood)
## merging crime rates and covid cases to get the final dataset
final_dataset<-
  neighbourhood_crime_rates_assaults |>
  mutate(FEMALE_Covid_CASES=covid_cases_final$FEMALE_Covid_Cases,MALE_Covid_CASES=covid_cases_final$MALE_Covid_Cases,transgender_covid_cases=covid_cases_final$TRANSGENDER,unknown_covid_cases= covid_cases_final$UNKNOWN,other_covid_cases=covid_cases_final$OTHER, "<=19"=covid_cases_final$`19 and younger`, "20 to 29"=covid_cases_final$`20 to 29 Years`,"30 to 39"=covid_cases_final$`30 to 39 Years`,"40 to 49"=covid_cases_final$`40 to 49 Years`,Total_CASES=covid_cases_final$total_cases)

write_csv(final_dataset, "inputs/data/final_dataset.csv")