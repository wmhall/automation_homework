library(plyr)
library(dplyr)
library(ggplot2)
library(broom)

gapminder <- read.delim("gapminder_clean.tsv")

lm_model <- 
	gapminder %>% 
	group_by(continent) %>% 
	do(tidy(lm(lifeExp ~ 1 + I(year-1952),. ))) %>% 
	ungroup()

lm_model_2007 <- 
	gapminder %>% 
	group_by(continent) %>% 
	do(tidy(lm(lifeExp ~ 1 + I(year-2007),. ))) %>% 
	ungroup()

lm_continent_slopes <- lm_model %>% 
	filter(term != "(Intercept)") %>%
	rename(slope_estimate = estimate) %>% 
	select(continent,slope_estimate)

lm_continent_intercepts_1952 <- lm_model %>% 
	filter(term == "(Intercept)") %>% 
	rename(intercept_estimate_1952=estimate) %>% 
	select(continent,intercept_estimate_1952)

lm_continent_intercepts_2007 <- lm_model_2007 %>% 
	filter(term == "(Intercept)") %>% 
	rename(intercept_estimate_2007=estimate) %>% 
	select(continent,intercept_estimate_2007)

lm_continent_model_info <- gapminder %>% 
	group_by(continent) %>% 
	do(glance(lm(lifeExp ~ 1 + I(year-1952),. )))

df_rank_lifeExp <- 
	join_all(list(lm_continent_intercepts_1952,lm_continent_intercepts_2007, lm_continent_slopes,lm_continent_model_info)) %>% 
	select(continent, intercept_estimate_1952,intercept_estimate_2007, slope_estimate, adj.r.squared) %>% 
	arrange(desc(slope_estimate)) %>% 
	rename(mean_lifeExp_1952 = intercept_estimate_1952, mean_lifeExp_2007 = intercept_estimate_2007, average_increase_in_lifeExp_per_year = slope_estimate, effect_size = adj.r.squared)

# write data to file
write.table(lm_model, "linear_model_year_predicting_lifeExp.tsv")
write.table(df_rank_lifeExp, "rank_continent_by_increase_in_lifeExp.tsv", quote = FALSE, sep = "\t", row.names = FALSE)