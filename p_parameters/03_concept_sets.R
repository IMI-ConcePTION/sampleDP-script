#-----------------------------------------
# ASSIGN NAMES AND DOMAINS OF CONCEPTSETS
#
# in this file the names of the conceptsets are listed. 
# as a default they are divided in 6 lists, based on the domain (diagnosis, medicines etc). there are two lists for diagnostic conseptsets: one is the list of those with tag 'narrow' and 'possible', and the other is the list of 'plain' conceptsets
# according to the needs of the project the lists can be further subdivided, or some of them may be missing
# those lists are used to feed CreateConceptsetDatasets in step 01_1, and then may be further used in the next steps
# at the bottom of this file there is a call to a second file that assigns codes to each conceptsets. such file may either be assigned directly or be retrieved from a csv
# the codes assigned in this file are preliminary (concept_set_codes_our_study_pre) and may be further refined, possibly in  a datasource-specific manner, in the parameter step 06_algorithms 
#----------------------------------------- 

concept_set_domains<- vector(mode="list")

#-------------
# assign names of diagnosis conceptsets that have a narrow or possible tag 
NARROW_POSSIBLE_conceptsets <- c()
for (concept in c(NARROW_POSSIBLE_conceptsets)) {
  concept_set_domains[[paste0(concept,"_narrow")]] = "Diagnosis"
  concept_set_domains[[paste0(concept,"_possible")]] = "Diagnosis"
}

#-------------
# assign names of diagnosis conceptsets that don't have a narrow or possible tag 
DIAGNOSIS_conceptssets <- c()
for (concept in c(DIAGNOSIS_conceptsets)) {
  concept_set_domains[[concept]] = "Diagnosis"
}

#-------------
# assign names of drug conceptsets
DRUGS_conceptsets <- c()
for (concept in c(DRUGS_conceptsets)) {
  concept_set_domains[[concept]] = "Medicines"
}

#-------------
# assign names of procedure conceptsets
PROC_conceptsets <- c()
for (concept in c(PROC_conceptsets)) {
  concept_set_domains[[concept]] = "Procedures"
}

#-------------
# assign names of results conceptsets
RESULTS_conceptsets <- c()
for (concept in c(RESULTS_conceptsets)) {
  concept_set_domains[[concept]] = "Results"
}

#-------------
# assign names of vaccine conceptsets
vaccine_conceptssets <- c()
concept_set_domains[["Covid_vaccine"]] = "VaccineATC"


#-------------
# list all available conceptsets (do not change, to be used in CreateConceptsetDatasets)

concept_sets_of_our_study <- unique(c(DIAGNOSIS_conceptsets, NARROW_POSSIBLE_conceptsets, DRUGS_conceptsets, RESULTS_conceptsets,PROC_conceptsets,vaccine_conceptssets))


#-------------
# START assignment of codes to conceptsets (mostly to be done)
concept_set_codes_our_study_pre <- vector(mode="list")
concept_set_codes_our_study_pre_excl <- vector(mode="list")

source(paste0(thisdir,"/p_parameters/archive_parameters/parameters_including_listcodescsv.R"))
