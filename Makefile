report.html: render_report.R \
  report.Rmd data/M_Cubed_Cohort.rds
	Rscript	render_report.R
	

output/table_one.rds: data/M_Cubed_Cohort.rds
	Rscript code/01_table_1.R


output/survival_curve.png: data/M_Cubed_Cohort.rds
	Rscript code/02_figure_1.R
	
.PHONY: clean
clean:
	rm -f output/* && rm -f report.html