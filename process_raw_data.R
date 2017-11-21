library(tidyverse)
library(lubridate)

raw_data <- read_csv('data/qualtrics_data.csv') 

de_identified_data <- raw_data %>%
  slice(-1:-2) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(MTurkCode, StartDate) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  mutate(id = 1:n()) %>%
  select(-IPAddress, -ResponseId, -LocationLatitude, -LocationLongitude, -MTurkCode)

write_csv(de_identified_data, "data/anonymized_data.csv")