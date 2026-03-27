#Identify location
here::i_am("code/01_table_1.R")

#upload data
data <- read_csv(
  file = here::here("data/M_Cubed_Cohort.csv")
)

#limit to only baseline observations
data<-data%>%dplyr::filter(surv==0)

#adjust look of variables
var_label(data) <- list(
  age_cat = "Age",
  race_table = "Race",
  site = "City",
  ins2 = "Insurance Status",
  risk_group = "Risk Group",
  baseline_hivtest_3m = "Recent HIV test", 
  baseline_prep_never_heard = "Ever heard of PrEP",
  stopnever = "Never/stopped PrEP use because unnecessary", 
  baseline_protect_prep = "Perceived protection from PrEP (1-100)",
  motivate_neg = "Distrust in healthcare workers (5 = highest)",
  likelystart = "Likely to start PrEP",
  likelytake = "Likely to take PrEP as prescribed",
  incometab = "Income Level",
  baseline_prevent_you = "Ranking of importance of personal control in prevention",
  baseline_rand_assign_text = "Control Trial assignment"
)

#create table
table<-data %>% 
  select(age_cat, race_table, inc_preplab, site, educ2, ins2,
         baseline_hivtest_3m, baseline_rand_assign_text, stopnever, baseline_protect_prep,
         motivate_neg, likelystart, likelytake, baseline_prevent_you) %>%
  tbl_summary(
    by = inc_preplab,
    type = list(baseline_prevent_you ~ "continuous")  # FORCE continuous
  ) %>%
  add_overall() %>%
  add_p()%>%
  modify_table_body(
    ~ filter(.x, label != "Unknown")
  ) %>%
  modify_caption("**Table 1**")

#save table
saveRDS(
  mod,
  file = here::here("output/table_one.rds")
)