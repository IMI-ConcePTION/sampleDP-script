###################################################################
# ASSIGN PARAMETERS DESCRIBING THE DATA MODEL OF THE INPUT FILES
# this file should not be modified
###################################################################

datasources_prescriptions <- c('CPRD',"PHARMO")
thisdatasource_has_prescriptions <- ifelse(thisdatasource %in% datasources_prescriptions,TRUE,FALSE)

# assign -files_ConcePTION_CDM_tables-: it is a 2-level list, listing the csv files where the tables of the local instance of the ConcePTION CDM are stored 
files_ConcePTION_CDM_tables <- vector(mode="list")

files <- sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^EVENTS")) {
    files_ConcePTION_CDM_tables[["EVENTS"]] <- c(files_ConcePTION_CDM_tables[["EVENTS"]],files[i])
  }
  if (str_detect(files[i],"^VISIT_OCCURRENCE")) {
    files_ConcePTION_CDM_tables[["VISIT_OCCURRENCE"]] <- c(files_ConcePTION_CDM_tables[["VISIT_OCCURRENCE"]],files[i])
  }
  if (str_detect(files[i],"^MEDICINES")) {
    files_ConcePTION_CDM_tables[["MEDICINES"]] <- c(files_ConcePTION_CDM_tables[["MEDICINES"]],files[i])
  }
  if (str_detect(files[i],"^PROCEDURES")) {
    files_ConcePTION_CDM_tables[["PROCEDURES"]] <- c(files_ConcePTION_CDM_tables[["PROCEDURES"]],files[i])
  }
  if (str_detect(files[i],"^MEDICAL_OBSERVATIONS")) {
    files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]] <- c(files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]],files[i])
  }
  if (str_detect(files[i],"^SURVEY_OBSERVATIONS")) {
    files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]] <- c(files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]],files[i])
  }
  if (str_detect(files[i],"^VACCINES")) {
    files_ConcePTION_CDM_tables[["VACCINES"]] <- c(files_ConcePTION_CDM_tables[["VACCINES"]],files[i])
  }
  if (str_detect(files[i],"^SURVEY_ID")) {
    files_ConcePTION_CDM_tables[["SURVEY_ID"]] <- c(files_ConcePTION_CDM_tables[["SURVEY_ID"]],files[i])
  }
  if (str_detect(files[i],"^PERSONS")) {
    files_ConcePTION_CDM_tables[["PERSONS"]] <- c(files_ConcePTION_CDM_tables[["PERSONS"]],files[i])
  }
  if (str_detect(files[i],"^OBSERVATION_PERIODS")) {
    files_ConcePTION_CDM_tables[["OBSERVATION_PERIODS"]] <- c(files_ConcePTION_CDM_tables[["OBSERVATION_PERIODS"]],files[i])
  }
}


#====================
# assign -ConcePTION_CDM_tables-: it is a 3-level list describing the ConcePTION CDM tables, and will enter CreateConceptsetDatasets and CreateItemsetDatasets as the first parameter. the first level is the data domain (e.g., 'Diagnosis' or 'Medicines') and the second level is the list of tables having a column pertaining to that data domain 

ConcePTION_CDM_tables <- vector(mode="list")

ConcePTION_CDM_tables[["VaccineATC"]] <- files_ConcePTION_CDM_tables[["VACCINES"]]
ConcePTION_CDM_tables[["Diagnosis"]] <- files_ConcePTION_CDM_tables[["EVENTS"]]
ConcePTION_CDM_tables[["Diagnosis_free_text"]] <- files_ConcePTION_CDM_tables[["EVENTS"]]
ConcePTION_CDM_tables[["Medicines"]] <- files_ConcePTION_CDM_tables[["MEDICINES"]]
ConcePTION_CDM_tables[["Procedures"]] <- files_ConcePTION_CDM_tables[["PROCEDURES"]]
ConcePTION_CDM_tables[["Results"]] <- files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]]

alldomain<-names(ConcePTION_CDM_tables)

# assign -EAV_table-: it is the list of the tables in the CDM where entity-attribute-value records are be retrieved

EAV_table <- c(files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]],files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]])

#-------------------------------------------------
# to be used in CreateItemesetDatasets: assign the list of the tables in the CDM where entity-attribute-value records are be retrieved, specifying the columns where the attributes for retrieval are stored; since such attributes may change per data source and/or itemsets, we create multiple parameters

# ConcePTION_CDM_EAV_tables_retrieve_source: so_source_tables and so_source_column in SO, and mo_source_table,mo_source_column in MO

ConcePTION_CDM_EAV_tables_retrieve_source <- vector(mode="list")
for (file in files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]]){
  ConcePTION_CDM_EAV_tables_retrieve_source[[file]] <- list("so_source_table", "so_source_column")
}
for (file in files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]]){
  ConcePTION_CDM_EAV_tables_retrieve_source[[file]] <- list( "mo_source_table", "mo_source_column")
}

# ConcePTION_CDM_EAV_tables_retrieve_meaning: so_origin and so_meaning in SO, and mo_origin,mo_meaning in MO

ConcePTION_CDM_EAV_tables_retrieve_meaning <- vector(mode="list")
for (file in files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]]){
  ConcePTION_CDM_EAV_tables_retrieve_meaning[[file]] <- list("so_origin", "so_meaning")
}
for (file in files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]]){
  ConcePTION_CDM_EAV_tables_retrieve_meaning[[file]] <- list( "mo_origin", "mo_meaning")
}

#====================
# assign -ConcePTION_CDM_codvar-: it is a 3-level list describing for each table and each data domain which column contains codes of that data domain, to be used in CreateConceptsetDatasets

person_id<- vector(mode="list")
date <- vector(mode="list")

ConcePTION_CDM_codvar <- vector(mode="list")

for (ds in ConcePTION_CDM_tables[["VaccineATC"]]) {
  ConcePTION_CDM_codvar[["VaccineATC"]][[ds]] <- "vx_atc"
  person_id[["VaccineATC"]][[ds]] <- "person_id"
  date[["VaccineATC"]][[ds]] <- "vx_admin_date"
}

for (ds in files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]]){
  ConcePTION_CDM_codvar[["Diagnosis"]][[ds]]="so_source_value"
}
for (ds in files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]]){
  ConcePTION_CDM_codvar[["Diagnosis"]][[ds]]="mo_source_value"
  ConcePTION_CDM_codvar[["Results"]][[ds]]="mo_code"
}
for (ds in files_ConcePTION_CDM_tables[["MEDICINES"]]){
  ConcePTION_CDM_codvar[["Medicines"]][[ds]]="medicinal_product_atc_code"
}
for (ds in files_ConcePTION_CDM_tables[["PROCEDURES"]]){
  ConcePTION_CDM_codvar[["Procedures"]][[ds]]="procedure_code"
}

for (ds in files_ConcePTION_CDM_tables[["EVENTS"]]){
  ConcePTION_CDM_codvar[["Diagnosis"]][[ds]]="event_code"
  ConcePTION_CDM_codvar[["Diagnosis_free_text"]][[ds]]="event_free_text"
}

#====================
# assign -ConcePTION_CDM_datevar-: it is a 3-level list describing for each table and each data domain which column contains dates, to be used in CreateConceptsetDatasets

ConcePTION_CDM_datevar <- vector(mode="list")

for (ds in ConcePTION_CDM_tables[["VaccineATC"]]) {
  ConcePTION_CDM_datevar[["VaccineATC"]][[ds]] <- "vx_admin_date"
}
for (ds in files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]]){
  ConcePTION_CDM_datevar[["Diagnosis"]][[ds]]="so_date"
}
for (ds in files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]]){
  ConcePTION_CDM_datevar[["Diagnosis"]][[ds]]="mo_date"
  ConcePTION_CDM_datevar[["Results"]][[ds]]="mo_date"
}
for (ds in files_ConcePTION_CDM_tables[["MEDICINES"]]){
  ConcePTION_CDM_datevar[["Medicines"]][[ds]]= list("date_dispensing","date_prescription")
}
for (ds in files_ConcePTION_CDM_tables[["EVENTS"]]){
  ConcePTION_CDM_datevar[["Diagnosis"]][[ds]]=list("start_date_record","end_date_record")
  ConcePTION_CDM_datevar[["Diagnosis_free_text"]][[ds]]=list("start_date_record","end_date_record")
}

#====================
# assign -ConcePTION_CDM_datevar_retrieve-: it is a 2-level list describing for each table which column contains dates, to be used in CreateItemsetDatasets; since all tables used in CreateItemsetDatasets are in the domain Diagnosis, we re-use the previous parameter ConcePTION_CDM_datevar

ConcePTION_CDM_datevar_retrieve <- list()
ConcePTION_CDM_datevar_retrieve = ConcePTION_CDM_datevar[["Diagnosis"]]

#====================
# assign -person_id- and -date- and -meaning-: they are 2-levels lists, to be used in CreateItemsetDatasets, lo indicate which columns must be renamed

person_id_retrieve <- vector(mode="list")
date_retrieve <- vector(mode="list")
meaning_retrieve <- vector(mode="list")

for (ds in files_ConcePTION_CDM_tables[["EVENTS"]]){
  person_id_retrieve[[ds]] = "person_id"
  date_retrieve[[ds]] = "start_date_record"
  meaning_retrieve[[ds]] = "meaning_of_event"
}
for (ds in files_ConcePTION_CDM_tables[["MEDICINES"]]){
  person_id_retrieve[[ds]] = "person_id"
  date_retrieve[[ds]] = ifelse(thisdatasource %in% datasources_prescriptions,"date_prescription","date_dispensing")
  meaning_retrieve[[ds]] = "meaning_of_drug_record"
}
for (ds in files_ConcePTION_CDM_tables[["PROCEDURES"]]){
  person_id_retrieve[[ds]] = "person_id"
  date_retrieve[[ds]] = "procedure_date"
  meaning_retrieve[[ds]] = "meaning_of_procedure"
}
for (ds in files_ConcePTION_CDM_tables[["VACCINES"]]){
  person_id_retrieve[[ds]] = "person_id"
  date_retrieve[[ds]] = "vx_admin_date"
  meaning_retrieve[[ds]] = "meaning_of_vx_record"
}
for (ds in files_ConcePTION_CDM_tables[["MEDICAL_OBSERVATIONS"]]){
  person_id_retrieve[[ds]] = "person_id"
  date_retrieve[[ds]] = "mo_date"
  meaning_retrieve[[ds]] = "mo_meaning"
}
for (ds in files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]]){
  person_id_retrieve[[ds]] = "person_id"
  date_retrieve[[ds]] = "so_date"
  meaning_retrieve[[ds]] = "so_meaning"
}

#---------------------------------------
# for CreateConceptsetDataset, the columns to be renamed may change per domain, so we assign new parameters

person_id <- vector(mode="list")
date <- vector(mode="list")
meaning <- vector(mode="list")

for (tab in c("EVENTS","VACCINES","MEDICINES","PROCEDURES","MEDICAL_OBSERVATIONS","SURVEY_OBSERVATIONS")){
  for (dom in alldomain){
    for (ds in files_ConcePTION_CDM_tables[[tab]]) {
      person_id[[dom]][[ds]] <- person_id_retrieve[[ds]]
      date[[dom]][[ds]] <- date_retrieve[[ds]]
      meaning[[dom]][[ds]] <- meaning_retrieve[[ds]]
    }
  }
}

#-------------------------------
# coding system

#====================
# assign -ConcePTION_EAV_tables-: it is a 3-level list describing the tables in the CDM where entity-attribute-value records are be retrieved, associated with data domains ('Diagnosis', 'Medicines', ...)

ConcePTION_CDM_EAV_tables <- vector(mode="list")

for (file in files_ConcePTION_CDM_tables[["SURVEY_OBSERVATIONS"]]){
  ConcePTION_CDM_EAV_tables[["Diagnosis"]][[file]] <- list(list(file, "so_source_table", "so_source_column"))
  ConcePTION_CDM_EAV_tables[["Diagnosis_free_text"]][[file]] <- list(list(file,"so_source_table","so_source_column"))
}

ConcePTION_CDM_coding_system_cols <-vector(mode="list")
if (length(ConcePTION_CDM_EAV_tables)!=0){
  for (dom in alldomain) {
    for (i in 1:(length(ConcePTION_CDM_EAV_tables[["Diagnosis"]]))){
      for (ds in append(ConcePTION_CDM_tables[[dom]],ConcePTION_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]])) {
        if (ds==ConcePTION_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]]) {
          if (str_detect(ds,"^SURVEY_OB"))  ConcePTION_CDM_coding_system_cols[["Diagnosis"]][[ds]]="so_unit"
          if (str_detect(ds,"^MEDICAL_OB")) {   ConcePTION_CDM_coding_system_cols[["Diagnosis"]][[ds]]="mo_record_vocabulary"
  ConcePTION_CDM_coding_system_cols[["Results"]][[ds]]="mo_record_vocabulary"
        }
        }else{
          # if (dom=="Medicines") ConcePTION_CDM_coding_system_cols[[dom]][[ds]]="product_ATCcode"
          if (dom=="Diagnosis") ConcePTION_CDM_coding_system_cols[[dom]][[ds]]="event_record_vocabulary"
          if (dom=="Diagnosis_free_text") ConcePTION_CDM_coding_system_cols[[dom]][[ds]]="event_record_vocabulary"
          if (dom=="Procedures") ConcePTION_CDM_coding_system_cols[[dom]][[ds]]="procedure_code_vocabulary"
        }
      }
    }
  }
}else{
  for (dom in alldomain) {
    for (ds in ConcePTION_CDM_tables[[dom]]) {
      if (dom=="Diagnosis") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "event_record_vocabulary"
      if (dom=="Procedures") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "procedure_code_vocabulary"
      #    if (dom=="Medicines") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "code_indication_vocabulary"
      # 
      if (dom=="Diagnosis_free_text") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "event_record_vocabulary"
    
    if (dom=="Results")ConcePTION_CDM_coding_system_cols[[dom]][[ds]]="mo_record_vocabulary"
    
    }
  }
}

# are the next rows still needed...?

#coding system
for (dom in alldomain) {
  for (ds in ConcePTION_CDM_tables[[dom]]) {
    if (dom=="Diagnosis") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "event_record_vocabulary"
    if (dom=="Diagnosis_free_text") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "event_record_vocabulary"
    #    if (dom=="Medicines") ConcePTION_CDM_coding_system_cols[[dom]][[ds]] = "code_indication_vocabulary"
  }
}


# THE NEXT LINES OF CODES ARE TO BE REVISED - ARE THEY STILL NECESSARY?


files_par<-sub('\\.RData$', '', list.files(dirpargen))

if(length(files_par)>0){
  for (i in 1:length(files_par)) {
    if (str_detect(files_par[i],"^ConcePTION_CDM_EAV_attributes")) { 
      load(paste0(dirpargen,files_par[i],".RData")) 
      load(paste0(dirpargen,"ConcePTION_CDM_coding_system_list.RData")) 
      print("upload existing EAV_attributes")
    } else {
      print("create EAV_attributes")
      
      ConcePTION_CDM_coding_system_list<-vector(mode="list")
      METADATA<-fread(paste0(dirinput,"METADATA.csv"))
      ConcePTION_CDM_coding_system_list<-unique(unlist(str_split(unique(METADATA[type_of_metadata=="list_of_values" & (columnname=="so_unit" | columnname=="mo_record_vocabulary"),values])," ")))
      
      ConcePTION_CDM_EAV_attributes<-vector(mode="list")
      
      if (length(ConcePTION_CDM_EAV_tables)!=0 ){
        for (i in 1:(length(ConcePTION_CDM_EAV_tables[["Diagnosis"]]))){
          for (ds in ConcePTION_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]]) {
            temp <- fread(paste0(dirinput,ds,".csv"))
            for( cod_syst in ConcePTION_CDM_coding_system_list) {
              if ("mo_source_table" %in% names(temp) ) {
                temp1<-unique(temp[mo_record_vocabulary %in% cod_syst,.(mo_source_table,mo_source_column)])
                if (nrow(temp1)!=0) ConcePTION_CDM_EAV_attributes[["Diagnosis"]][[ds]][[thisdatasource]][[cod_syst]]<-as.list(as.data.table(t(temp1)))
              } else{
                temp1<-unique(temp[so_unit %in% cod_syst,.(so_source_table,so_source_column)])
                if (nrow(temp1)!=0) ConcePTION_CDM_EAV_attributes[["Diagnosis"]][[ds]][[thisdatasource]][[cod_syst]]<-as.list(as.data.table(t(temp1)))
              }
              
            }
          }
        }
      }
      
      ConcePTION_CDM_EAV_attributes_this_datasource<-vector(mode="list")
      
      if (length(ConcePTION_CDM_EAV_attributes)!=0 ){
        for (t in  names(ConcePTION_CDM_EAV_attributes)) {
          for (f in names(ConcePTION_CDM_EAV_attributes[[t]])) {
            for (s in names(ConcePTION_CDM_EAV_attributes[[t]][[f]])) {
              if (s==thisdatasource ){
                ConcePTION_CDM_EAV_attributes_this_datasource[[t]][[f]]<-ConcePTION_CDM_EAV_attributes[[t]][[f]][[s]]
              }
            }
          }
        }
      }
      
      save(ConcePTION_CDM_EAV_attributes_this_datasource, file = paste0(dirpargen,"ConcePTION_CDM_EAV_attributes.RData"))
      save(ConcePTION_CDM_coding_system_list, file = paste0(dirpargen,"ConcePTION_CDM_coding_system_list.RData"))
      
    }
  }
} else {
  
  print("create EAV_attributes")
  
  ConcePTION_CDM_coding_system_list<-vector(mode="list")
  METADATA<-fread(paste0(dirinput,"METADATA.csv"))
  ConcePTION_CDM_coding_system_list<-unique(unlist(str_split(unique(METADATA[type_of_metadata=="list_of_values" & (columnname=="so_unit" | columnname=="mo_record_vocabulary"),values])," ")))
  
  ConcePTION_CDM_EAV_attributes<-vector(mode="list")
  
  if (length(ConcePTION_CDM_EAV_tables)!=0 ){
    for (i in 1:(length(ConcePTION_CDM_EAV_tables[["Diagnosis"]]))){
      for (ds in ConcePTION_CDM_EAV_tables[["Diagnosis"]][[i]][[1]][[1]]) {
        temp <- fread(paste0(dirinput,ds,".csv"))
        for( cod_syst in ConcePTION_CDM_coding_system_list) {
          if ("mo_source_table" %in% names(temp) ) {
            temp1<-unique(temp[mo_record_vocabulary %in% cod_syst,.(mo_source_table,mo_source_column)])
            if (nrow(temp1)!=0) ConcePTION_CDM_EAV_attributes[["Diagnosis"]][[ds]][[thisdatasource]][[cod_syst]]<-as.list(as.data.table(t(temp1)))
          } else{
            temp1<-unique(temp[so_unit %in% cod_syst,.(so_source_table,so_source_column)])
            if (nrow(temp1)!=0) ConcePTION_CDM_EAV_attributes[["Diagnosis"]][[ds]][[thisdatasource]][[cod_syst]]<-as.list(as.data.table(t(temp1)))
          }
          
        }
      }
    }
  }
  
  ConcePTION_CDM_EAV_attributes_this_datasource<-vector(mode="list")
  
  if (length(ConcePTION_CDM_EAV_attributes)!=0 ){
    for (t in  names(ConcePTION_CDM_EAV_attributes)) {
      for (f in names(ConcePTION_CDM_EAV_attributes[[t]])) {
        for (s in names(ConcePTION_CDM_EAV_attributes[[t]][[f]])) {
          if (s==thisdatasource ){
            ConcePTION_CDM_EAV_attributes_this_datasource[[t]][[f]]<-ConcePTION_CDM_EAV_attributes[[t]][[f]][[s]]
          }
        }
      }
    }
  }
  
  save(ConcePTION_CDM_EAV_attributes_this_datasource, file = paste0(dirpargen,"ConcePTION_CDM_EAV_attributes.RData"))
  save(ConcePTION_CDM_coding_system_list, file = paste0(dirpargen,"ConcePTION_CDM_coding_system_list.RData"))
  
}

ConcePTION_CDM_EAV_attributes_this_datasource<-vector(mode="list")

if (length(ConcePTION_CDM_EAV_attributes)!=0 ){
  for (t in  names(ConcePTION_CDM_EAV_attributes)) {
    for (f in names(ConcePTION_CDM_EAV_attributes[[t]])) {
      for (s in names(ConcePTION_CDM_EAV_attributes[[t]][[f]])) {
        if (s==thisdatasource ){
          ConcePTION_CDM_EAV_attributes_this_datasource[[t]][[f]]<-ConcePTION_CDM_EAV_attributes[[t]][[f]][[s]]
        }
      }
    }
  }
}



rm(temp,temp1)