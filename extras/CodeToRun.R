# Install Renv
# Specific version according to the renv.lock file
remotes::install_version(package = "renv", version = "1.0.7")

# Activate renv, if not already activated.
renv::activate()

# Restore the packages.
renv::restore()

# Build the Diagnostics package
devtools::install()

library(ONLTreatmentPatternsBreastCancer)

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = NULL,
  user = NULL,
  password = NULL,
  server = NULL,
  port = NULL,
  extraSettings = NULL,
  pathToDriver = NULL
)

# Output folder to write output to.
outputFolder <- "..."

# Schema where the CDM resides.
cdmSchema <- "..."

# Schema where the cohort table resides
resultSchema <- "..."

# Name of the genrated cohort table
cohortTableName <- "..."

# Schema to emulate temp tables (For i.e. Oracle)
tempEmulationSchema <- NULL

exportFolder <- "..."

# [!] Do not edit below ----
cohortsOutput <- generateCohorts(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmSchema,
  cohortDatabaseSchema = resultSchema,
  cohortTableName = cohortTableName,
  tempEmulationSchema = tempEmulationSchema
)

runTreatmentPatterns(
  connectinoDetails = connectionDetails,
  resultSchema = resultSchema,
  cdmSchema = cdmSchema,
  tempEmulationSchema = tempEmulationSchema,
  cohortTableName = cohortTableName,
  outputFolder = outputFolder
)
