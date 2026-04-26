library(here)
library(tidyverse)
library(survival)
#Identify location
here::i_am("code/01_table_1.R")

#upload data
data <- read_csv(
  file = here::here("data/M_Cubed_Cohort.csv")
)

data$perc_protect <- factor(data$perc_protect) #treat as factor
fit <- coxph(Surv(timestart, timestop, prep) ~ perc_protect, data = data) #PH for groups
km  <- survfit(fit, newdata = data.frame(perc_protect = levels(data$perc_protect))) #create survival curve
drop1(fit, test = "Chisq")
summary(fit)$coefficients 
summary(fit)
km_df <- data.frame(
  time     = rep(km$time, times = ncol(km$surv)), #alter formatting of timing
  cum_prob = 1 - c(km$surv), # calculate cummulative probability by inverting prob not starting PrEP
  lower    = 1 - c(km$upper), #invert lower to become upper
  upper    = 1 - c(km$lower),#invert upper to become lower
  group    = rep(levels(data$perc_protect), each = nrow(km$surv)) #assigns group levels
)

#create plot
curves<-ggplot(km_df, aes(x = time, y = cum_prob, colour = group, fill = group)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.2, color=NA) + #add CI
  geom_step() + #makes so not smooth and directly representative of time changes
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) + #forces to % and 100% max
  labs(x      = "Time (days)",
       y      = "PrEP initiation Probability",
       colour = "PrEP Protection Perception",
       fill   = "PrEP Protection Perception") +
  scale_colour_discrete(labels = c("Higher","Lower")) +
  scale_fill_discrete(labels   = c("Higher","Lower")) +
  theme_bw()+
  theme(legend.position = "bottom")

#save plot
ggsave(
  file = here::here("output/survival_curve.png"),
  plot = curves,
  device = "png"
)
