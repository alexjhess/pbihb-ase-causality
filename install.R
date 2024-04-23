# install packages from CRAN
renv::install("bnlearn")
renv::install("GeneralisedCovarianceMeasure")
renv::install("CondIndTests")
renv::install("ipw")
renv::install("survey")
renv::install("DoubleML")
renv::install("mlr3")
renv::install("mlr3learners")
renv::install("ranger")

# packages from Bioconductor
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("Rgraphviz")
BiocManager::install("RBGL")


#_______________________________________________
# load installed packages
library(bnlearn)
library(GeneralisedCovarianceMeasure)
library(CondIndTests)
library(ipw)
library(survey)
library(DoubleML)
library(mlr3)
library(mlr3learners)
library(ranger)

