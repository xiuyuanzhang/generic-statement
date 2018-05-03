library(tidyverse)
library(lubridate)

raw_data <- read_csv('data/qualtrics_1st_demographic_novel_generic_200.csv') 
#turk_5_data <- read_csv('data/mturk_1st_demographic_novel_generic_5.csv')
turk_195_data <- read_csv('data/mturk_1st_demographic_novel_generic_195.csv')

de_identified_data <- raw_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  filter(MTurkCode %in% turk_195_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-IPAddress, -ResponseId, -LocationLatitude, -LocationLongitude, -MTurkCode)

write_csv(de_identified_data, "data/05022018_novel_wrong_anonymized_data.csv")
