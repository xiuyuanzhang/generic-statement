library(tidyverse)
library(lubridate)

raw_data <- read_csv('data/10312018_qualtrics_people_habits.csv') 
#turk_data <- read_csv('data/10092018mturk_baseline_people_habits.csv')

# post-registration: the first three rows of data are filtered out because they are
# from preview and testing stage
de_identified_data <- raw_data %>%
  slice(-1:-5) %>%
  filter(!is.na(MTurkCode)) %>%
  mutate(StartDate = ymd_hms(StartDate)) %>%
  arrange(StartDate, MTurkCode) %>%
  distinct(MTurkCode, .keep_all = TRUE) %>%
  #filter(MTurkCode %in% turk_data$Answer.surveycode) %>%
  mutate(id = 1:n()) %>%
  select(-ResponseId, -MTurkCode, -IPAddress, -Status, -ResponseId, -RecipientEmail,
         -RecipientLastName, -RecipientFirstName, -LocationLatitude, -LocationLongitude)


write_csv(de_identified_data, "data/10312018_people_habit_anonymized_data.csv")
