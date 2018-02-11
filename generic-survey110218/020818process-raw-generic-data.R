library(tidyverse)
library(lubridate)

qualtrics_data <- read_csv('qualtrics-generic020818.csv') 
turk_data <- read_csv('mturk-generic020818.csv')

# after looking at the turk_data, turk_data$Answer.surveycode[49] has the correct
# code but has a " " before the numeric value, which leads to it being excluded 
# from the de_identified_data. I changed the value of turk_data$Answer.surveycode[49]
# before filtering the de_identified_data
turk_data$Answer.surveycode[49] <- substr(turk_data$Answer.surveycode[49], 2, 9)

de_identified_data <- qualtrics_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  filter(MTurkCode %in% turk_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-IPAddress, -ResponseId, -LocationLatitude, -LocationLongitude, -MTurkCode)

write_csv(de_identified_data, "020818generic-anonymized-data.csv")