PROJECTFILES = report.Rmd code/01_table_1.R code/02_figure_1.R Makefile
RENVFILES    = renv.lock renv/activate.R renv/settings.json

report/report.html: output/table_one.rds output/survival_curve.png report.Rmd data/M_Cubed_Cohort.csv
	docker pull irene5297/final
	docker run \
	  -v "$(PWD)/report":/home/rstudio/M_cubed_repo/report \
	  -v "$(PWD)/output":/home/rstudio/M_cubed_repo/output \
	  irene5297/final

output/table_one.rds: data/M_Cubed_Cohort.csv
	docker run \
	  -v "$(PWD)/output":/home/rstudio/M_cubed_repo/output \
	  irene5297/final \
	  Rscript code/01_table_1.R

output/survival_curve.png: data/M_Cubed_Cohort.csv
	docker run \
	  -v "$(PWD)/output":/home/rstudio/M_cubed_repo/output \
	  irene5297/final \
	  Rscript code/02_figure_1.R

.PHONY: clean
clean:
	rm -f report/report.html output/*

.PHONY: build
build: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t irene5297/final .