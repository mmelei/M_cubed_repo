report.html: render_report.R \
  report.Rmd data/M_Cubed_Cohort.csv output/table_one.rds output/survival_curve.png
	Rscript	render_report.R
	

output/table_one.rds: data/M_Cubed_Cohort.csv
	Rscript code/01_table_1.R


output/survival_curve.png: data/M_Cubed_Cohort.csv
	Rscript code/02_figure_1.R


.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"
	
.PHONY: clean
clean:
	rm -f output/* && rm -f report.html