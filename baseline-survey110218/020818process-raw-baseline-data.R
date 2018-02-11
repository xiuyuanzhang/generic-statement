library(tidyverse)
library(lubridate)

qualtrics_data <- read_csv('qualtrics-baseline020818.csv') 
turk_data <- read_csv('mturk-baseline020818.csv')

de_identified_data <- qualtrics_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  filter(MTurkCode %in% turk_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-IPAddress, -ResponseId, -LocationLatitude, -LocationLongitude, -MTurkCode)

write_csv(de_identified_data, "020818baseline-anonymized-data.csv")