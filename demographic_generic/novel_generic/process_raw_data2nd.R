library(tidyverse)
library(lubridate)

raw_data <- read_csv('data/qualtrics_2nd_demographic_novel_generic_200.csv') 
turk_200_data <- read_csv('data/mturk_2nd_demographic_novel_generic_200.csv')

de_identified_data <- raw_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  filter(MTurkCode %in% turk_200_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-IPAddress, -ResponseId, -LocationLatitude, -LocationLongitude, -MTurkCode)


write_csv(de_identified_data, "data/05082018_novel_anonymized_data.csv")
