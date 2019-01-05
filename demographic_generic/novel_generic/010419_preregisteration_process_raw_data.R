library(tidyverse)
library(lubridate)

raw_data <- read_csv('data/01072019qualtrics_novel_people_habits.csv') 
turk_data <- read_csv('data/01072019mturk_novel_people_habits.csv')

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

write_csv(de_identified_data, "data/01072019_people_novel_habit_anonymized_data.csv")
