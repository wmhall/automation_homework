all: 04_make_report.html
	
clean:
	rm -f gapminder.tsv gapminder_clean.tsv rank_continent_by_increase_in_lifeExp.tsv linear_model_year_predicting_lifeExp.tsv *.png *.html

gapminder.tsv:
	curl -O https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv

gapminder_clean.tsv: gapminder.tsv 01_filter_reorder_plot.R
	Rscript 01_filter_reorder_plot.R
	
rank_continent_by_increase_in_lifeExp.tsv: gapminder_clean.tsv 02_do_analyses.R
	Rscript 02_do_analyses.R
	
linear_model_year_predicting_lifeExp.tsv: gapminder_clean.tsv 02_do_analyses.R
	Rscript 02_do_analyses.R
	
plot_for_average_increase_in_lifeExp_per_year.png: rank_continent_by_increase_in_lifeExp.tsv 03_create_plots.R
	Rscript 03_create_plots.R
	rm Rplots.pdf

04_make_report.html: 04_make_report.Rmd gapminder.tsv rank_continent_by_increase_in_lifeExp.tsv linear_model_year_predicting_lifeExp.tsv plot_for_average_increase_in_lifeExp_per_year.png
	Rscript -e "rmarkdown::render('$<')"

