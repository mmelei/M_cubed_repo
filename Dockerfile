FROM rocker/tidyverse

WORKDIR /home/rstudio/M_cubed_repo

COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

ENV RENV_CONFIG_CACHE_SYMLINKS=FALSE

RUN Rscript -e "renv::restore(prompt = FALSE)"

RUN mkdir -p code data output report
COPY code code
COPY data data
COPY Makefile .
COPY report.Rmd .
COPY .gitignore .
COPY M_cubed_repo.Rproj .

CMD Rscript -e "rmarkdown::render('report.Rmd', output_file='/home/rstudio/M_cubed_repo/report/report.html')"