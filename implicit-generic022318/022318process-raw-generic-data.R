library(tidyverse)
library(lubridate)

qualtrics_data <- read_csv('~/Documents/UChicago Studies/callab/1st-implicit-generic15022018/qualtrics-results022318.csv') 
turk_data <- read_csv('~/Documents/UChicago Studies/callab/1st-implicit-generic15022018/mturk-results022318.csv')

de_identified_data <- qualtrics_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  filter(MTurkCode %in% turk_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-IPAddress, -ResponseId, -LocationLatitude, -LocationLongitude, -MTurkCode)

write_csv(de_identified_data, "022318implicit-generic-anonymized-data.csv")