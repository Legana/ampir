# create precision recall probability curve plot for ampir paper

library(tidyverse)

#read the predicted probabilities from the test set
test_pred_prob <- readRDS("tmpdata/test_pred_prob_svmtuned98.rds")
#read the test set
features98Test <- readRDS("tmpdata/features98Test.rds")

#add the true predictions from the test set to the predicted probabilities dataset
prob_curve_prep <- test_pred_prob %>% add_column(actual = features98Test$Label)

#function to calculate metrics from confusion matrix for a given probability threshold
calc_cm_metrics <- function(p_threshold, df) {

  TP <- df %>% filter((actual=="Tg")) %>% filter(Tg > p_threshold) %>% n_distinct()
  FP <- df %>% filter((actual=="Bg")) %>% filter(Tg > p_threshold) %>% n_distinct()
  TN <- df %>% filter((actual=="Bg")) %>% filter(Tg < p_threshold) %>% n_distinct()
  FN <- df %>% filter((actual=="Tg")) %>% filter(Tg < p_threshold) %>% n_distinct()

  Specificity <- round(TN / (TN + FP), digits = 3)
  Recall <- round(TP / (TP + FN), digits = 3)
  Precision <- round(TP/ (TP + FP), digits = 3)

  cm <- c(TP, FP, TN, FN, Specificity, Recall, Precision, p_threshold)
  names(cm) <-c("TP", "FP", "TN", "FN", "Specificity", "Recall", "Precision", "p_threshold")
  cm
}


#using function for a range of p_thresholds
roc_data <- as.data.frame(t(sapply(seq(0.01, 0.99, 0.01), calc_cm_metrics, prob_curve_prep)))


#recalculate the Recall and Precision for any alpha
calc_precision_recall <- function(df,alpha) {
  df %>%
    mutate(Recall = Recall) %>%
    mutate(Precision = TP*alpha / (TP*alpha+FP*(1-alpha))) %>%
    select(Recall,Precision,p_threshold)
}

#use the function to calculate alpha as 1%
pr_alpha1 <- calc_precision_recall(roc_data, 0.01) %>% add_column(alpha = 0.01)

#convert to long format
pr_alpha1_long <- pr_alpha1[,1:3] %>% gather("metric","value", 1:2)


#plot
ggplot(pr_alpha1_long, aes(x=p_threshold, y=value)) +
  geom_line(aes(linetype = metric), size = 1) +
  theme(panel.grid.minor = element_blank()) +
  theme(legend.title = element_blank()) +
  theme(legend.position = c(0.23, 0.53)) +
  #theme(legend.position = "left") +
  theme(legend.text = element_text(size=8)) +
  theme(legend.background = element_blank()) +
  theme(axis.title.x = element_text(size = 8)) +
  theme(axis.title.y = element_text(size = 8)) +
  xlim(0.5,1) +
  ylab("") +
  xlab("probability threshold")

ggsave("data-raw/fig1.png", height=4, width=7, units='cm', dpi=350)

#ggsave("data-raw/fig1.tiff", height=4, width=7, units='cm', dpi=350)


