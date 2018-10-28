library(tidyverse)
library(lubridate)

raw_data <- read_csv('data/10092018qualtrics_baseline_people_habits.csv') 
turk_data <- read_csv('data/10092018mturk_baseline_people_habits.csv')

de_identified_data <- raw_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  filter(MTurkCode %in% turk_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-ResponseId, -MTurkCode, -IPAddress, -Status, -ResponseId, -RecipientEmail,
         -RecipientLastName, -RecipientFirstName, -LocationLatitude, -LocationLongitude)

write_csv(de_identified_data, "data/10092018_people_habit_anonymized_data.csv")
