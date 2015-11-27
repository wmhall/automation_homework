library(ggplot2)
library(dplyr)

#read in the data.
gapminder <- read.delim("gapminder.tsv")

#drop ociena from dataframe. 
gapminder_no_oceania <- 
	gapminder %>% 
	filter(continent != "Oceania") %>% 
	droplevels()


# write data to file
write.table(gapminder_no_oceania, 
						"gapminder_clean.tsv", quote = FALSE,
						sep = "\t", row.names = FALSE)
