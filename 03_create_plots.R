library(plyr)
library(dplyr)
library(ggplot2)


gapminder <- read.delim("rank_continent_by_increase_in_lifeExp.tsv")

gapminder <- gapminder %>% 
	mutate(continent = reorder(continent, average_increase_in_lifeExp_per_year))

p1 <- ggplot(gapminder, aes(x=continent, y=average_increase_in_lifeExp_per_year, fill = continent)) + 
	geom_point(aes(size=effect_size), pch=21) + ylab("Average increase in \n life expectancy per year") +
	xlab("Continent")

#save plots
ggsave("plot_for_average_increase_in_lifeExp_per_year.png", p1)
