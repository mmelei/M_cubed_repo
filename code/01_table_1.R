library(tidyverse)
library(here)
#Identify location
here::i_am("code/01_table_1.R")

#upload data
data <- read_csv(
  file = here::here("data/M_Cubed_Cohort.csv")
)

data<- data%>%
  dplyr::group_by(PT_NEW)%>%
  dplyr::mutate(inc_preplab = case_when(any(prep==1) ~ "initiated PrEP",
         TRUE ~ "Didn't initiate PrEP"))%>%
  dplyr::ungroup()

#limit to only baseline observations
data<-data%>%dplyr::filter(surv==0)

#adjust look of variables
labelled::var_label(data) <- list(
  age_cat = "Age",
  race_table = "Race",
  site = "City",
  ins2 = "Insurance Status",
  risk_group = "Risk Group",
  hivtest_3m = "Recent HIV test", 
  prep_never_heard = "Ever heard of PrEP",
  stopnever = "Never/stopped PrEP use because unnecessary", 
  protect_prep = "Perceived protection from PrEP (1-100)",
  motivate_neg = "Distrust in healthcare workers (5 = highest)",
  likelystart = "Likely to start PrEP",
  likelytake = "Likely to take PrEP as prescribed",
  prevent_you = "Ranking of importance of personal control in prevention",
  rand_assign_text = "Control Trial assignment"
)

#create table
table<-data %>% 
  dplyr::select(age_cat, race_table, inc_preplab, site, educ2, ins2,
         hivtest_3m, rand_assign_text, stopnever, protect_prep,
         motivate_neg, likelystart, likelytake, prevent_you) %>%
  gtsummary::tbl_summary(
    by = inc_preplab,
    type = list(prevent_you ~ "continuous")  # FORCE continuous
  ) %>%
  gtsummary::add_overall() %>%
  gtsummary::add_p()%>%
  gtsummary::modify_table_body(
    ~ filter(.x, label != "Unknown")
  ) %>%
  gtsummary::modify_caption("**Table 1**")

#save table
saveRDS(
  table,
  file = here::here("output/table_one.rds")
)