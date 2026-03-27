here::i_am(
  "render_report.R"
)

library(rmarkdown)

render(
  "report.Rmd",
  knit_root_dir = here::here()
)
