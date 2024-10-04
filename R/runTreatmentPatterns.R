runTreatmentPatterns <- function(connectinoDetails, resultSchema, cdmSchema, tempEmulationSchema, cohortTableName, outputFolder) {
  cohortsBreastCancer <- data.frame(
    cohortId = c(1790368, 1790362, 1790367, 1790366, 1790365, 1790364),
    cohortName = c("Breast Cancer", "Targeted Drug Therapy", "Chemotherapy", "Surgery", "Radiotherapy", "Immunotherapy"),
    type = c("target", "event", "event", "event", "event", "event")
  )

  cohortsMalignantTumor <- data.frame(
    cohortId = c(1790446, 1790362, 1790367, 1790366, 1790365, 1790364),
    cohortName = c("Breast Cancer Malignant Tumor", "Targeted Drug Therapy", "Chemotherapy", "Surgery", "Radiotherapy", "Immunotherapy"),
    type = c("target", "event", "event", "event", "event", "event")
  )

  cohortsList <- list(
    `Breast-Cancer` = cohortsBreastCancer,
    `Breast-Cancer-Malignant-Tumor` = cohortsMalignantTumor
  )

  for (i in length(cohortsList)) {
    label <- names(cohortsList[[i]])

    outputEnv <- TreatmentPatterns::computePathways(
      cohorts = cohortsList[[i]],
      cohortTableName = cohortTableName,
      connectionDetails = connectionDetails,
      resultSchema = resultSchema,
      cdmSchema = cdmSchema,
      tempEmulationSchema = tempEmulationSchema,
      minEraDuration = 0,
      combinationWindow = 0,
      minPostCombinationDuration = 0
    )

    TreatmentPatterns::export(
      andromeda = outputEnv,
      outputPath = file.path(outputFolder, label),
      minCellCount = 5
    )
  }
}
