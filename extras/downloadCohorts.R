library(ROhdsiWebApi)
library(dplyr)

baseUrl <- "https://atlas-demo.ohdsi.org/WebAPI"

cohortIds <- c(
  1790368, 1790363, 1790362, 1790367, 1790366, 1790365, 1790364, 1790446
)

for (id in cohortIds) {
  object <- ROhdsiWebApi::getCohortDefinition(
    cohortId = id,
    baseUrl = baseUrl
  )

  json <- RJSONIO::toJSON(object$expression, digits = 23, pretty = TRUE)

  outPath <- file.path(sprintf("./inst/cohorts/%s-%s.json", object$id, object$name))

  message(sprintf("Wrote cohort %s to:\n  %s\n", object$name, outPath))
  writeLines(
    text = json,
    con = outPath
  )
}
