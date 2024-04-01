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
  
write_csv(compas_data_clean, file = here::here("dataset", "compas-scores-clean.csv"))

save(compas_data_clean, file = here::here("dataset/compas-scores-clean.RData"))

