#' generateCohorts
#'
#' @param connectionDetails (`ConnectionDetails`)
#' @param cdmDatabaseSchema (`character(1)`)
#' @param cohortDatabaseSchema (`character(1)`)
#' @param cohortTableName (`character(1)`)
#' @param cohortsFolder (`character(1)`)
#'
#' @return (`list`)
#' @export
generateCohorts <- function(
    connectionDetails,
    cdmDatabaseSchema,
    cohortDatabaseSchema,
    cohortTableName,
    tempEmulationSchema,
    cohortsFolder = system.file(package = "ONLTreatmentPatternsBreastCancer", "cohorts")) {
  cohortsToCreate <- CohortGenerator::createEmptyCohortDefinitionSet()

  cohortJsonFiles <- list.files(
    path = cohortsFolder,
    full.names = TRUE
  )

  for (cohortJsonFile in cohortJsonFiles) {
    id <- strsplit(basename(cohortJsonFile), "-")[[1]][1]
    cohortName <- tools::file_path_sans_ext(strsplit(basename(cohortJsonFile), "^\\d+-")[[1]][2])
    cohortJson <- readChar(cohortJsonFile, file.info(cohortJsonFile)$size)
    cohortExpression <- CirceR::cohortExpressionFromJson(cohortJson)
    cohortSql <- CirceR::buildCohortQuery(cohortExpression, options = CirceR::createGenerateOptions(generateStats = FALSE))

    cohortsToCreate <- rbind(
      cohortsToCreate,
      data.frame(
        cohortId = as.numeric(id),
        cohortName = cohortName,
        sql = cohortSql,
        json = cohortJson,
        stringsAsFactors = FALSE
      )
    )
  }

  cohortTableNames <- CohortGenerator::getCohortTableNames(
    cohortTable = cohortTableName
  )
  CohortGenerator::createCohortTables(
    connectionDetails = connectionDetails,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTableNames = cohortTableNames
  )
  # Generate the cohorts
  cohortsGenerated <- CohortGenerator::generateCohortSet(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDatabaseSchema = cohortDatabaseSchema,
    tempEmulationSchema = tempEmulationSchema,
    cohortTableNames = cohortTableNames,
    cohortDefinitionSet = cohortsToCreate
  )

  # Get the cohort counts
  cohortCounts <- CohortGenerator::getCohortCounts(
    connectionDetails = connectionDetails,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTable = cohortTableNames$cohortTable
  )

  return(list(
    cohortSet = cohortsToCreate,
    cohortsGenerated = cohortsGenerated,
    cohortCounts = cohortCounts
  ))
}
