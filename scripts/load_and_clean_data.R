library(tidyverse)
library(dplyr)      # For attribute selection
library(lubridate)  # For calculating COMPAS person's age

compas_data <- read_csv(here::here("dataset", "compas-scores-raw.csv"))

## CLEAN the data

# Calculate age based on DateOfBirth and Screening_Date
# Convert date strings to Date objects
compas_data$DateOfBirth <- mdy(compas_data$DateOfBirth)
compas_data$Screening_Date <- mdy_hm(compas_data$Screening_Date)

compas_data$Age <- as.numeric(difftime(compas_data$Screening_Date, compas_data$DateOfBirth, units = "days") / 365.25)

compas_data_clean <- compas_data %>%
  select(Person_ID, Sex = Sex_Code_Text, Race = Ethnic_Code_Text, DateOfBirth, Age, RawScore, DecileScore, ScoreText) %>% 
  drop_na()

# second dataset
iowa_data <- read_csv(here::here("dataset", "Iowa_Probation_Recidivism_Status_20240403.csv"))
iowa_data_clean <- iowa_data %>%
  select(sex = Sex, race = Race, age = Age, reincarcerated = Reincarcerated)

# 3rd dataset (new compas)
new_compas <- read_csv(here::here("dataset", "compas-scores-two-years-violent.csv"))
new_compas_clean <- new_compas %>%
  select(sex, age, race, reincarcerated)

## COMBINING the data
new_compas_clean <- new_compas_clean %>% mutate(state = "Florida")
iowa_data_clean <- iowa_data_clean %>% mutate(state = "Iowa")
combined_data <- bind_rows(new_compas_clean, iowa_data_clean)
write_csv(combined_data, file = here::here("dataset", "combined-data.csv"))

## SAVING the data  
write_csv(compas_data_clean, file = here::here("dataset", "compas-scores-clean.csv"))
write_csv(iowa_data_clean, file = here::here("dataset", "iowa-data-clean.csv"))
write_csv(new_compas_clean, file = here::here("dataset", "new-compas-clean.csv"))

