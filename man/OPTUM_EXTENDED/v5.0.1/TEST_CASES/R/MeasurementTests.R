createMeasurementTests <- function()
{
  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has lab_result with both loinc_cd and proc_cd values that map to a Measurement record based on loinc_cd", 
              source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, pat_planid = patient$patid, patid = patient$patid, fst_dt = '2013-07-01', loinc_cd = '22962-5', proc_cd = '87517')
  expect_measurement(person_id = patient$person_id, measurement_source_value = '22962-5')
  expect_no_measurement(person_id = patient$person_id, measurement_source_value = '87517')


  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has diag1-5 source codes mapping to domain Measurement and visit_place_of_service of IP; does not get mapped to Condition", 
              source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_medical_claims(clmid = claim$clmid, clmseq = '001', diag1 = '78322', lst_dt = '2013-07-01', rvnu_cd = '0100', pos = '20',
                     icd_flag = '9', pat_planid = patient$patid, patid = patient$patid, fst_dt = '2013-07-01', prov = '111111', provcat = '5678')
  expect_no_condition_occurrence(person_id = patient$person_id, condition_source_value = '78322')
  expect_measurement(person_id = patient$person_id, measurement_source_value = '78322')
  expect_visit_occurrence(person_id = patient$person_id, visit_concept_id = 9201)


  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has diag1-5 source codes mapping to domain Measurement and visit_place_of_service of OP; does not get mapped to Condition", 
              source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_medical_claims(clmid = claim$clmid, clmseq = '001', diag1 = '78322', lst_dt = '2013-07-01',
                     icd_flag = '9', pat_planid = patient$patid, patid = patient$patid, fst_dt = '2013-07-01', prov = '111111', provcat = '5678')
  expect_no_condition_occurrence(person_id = patient$person_id, condition_source_value = '78322')
  expect_measurement(person_id = patient$person_id, measurement_source_value = '78322')
  expect_visit_occurrence(person_id = patient$person_id, visit_concept_id = 9202)
  
  
  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has measurement value (sourced from lab_result rslt_nbr)", source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', rslt_nbr = 1000)
  expect_measurement(person_id = patient$person_id, value_as_number = 1000, measurement_concept_id = 3012939)
  
  
  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has measurement value (sourced from temp_medical units)", source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_medical_claims(clmid = claim$clmid, clmseq = '001', diag1 = '78322', lst_dt = '2013-07-01',
                     icd_flag = '9', pat_planid = patient$patid, patid = patient$patid, fst_dt = '2013-07-01', prov = '111111', provcat = '5678',
                     units = 1000)
  expect_measurement(person_id = patient$person_id, value_as_number = 1000)
  
  
  patient <- createPatient();
  claim <- createClaim();
  operator <- '>'
  declareTest(paste0("Patient has ", operator, " operator_concept_id"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = operator)
  expect_measurement(person_id = patient$person_id, operator_concept_id = 4172704)
  
  
  patient <- createPatient();
  claim <- createClaim();
  operator <- '<'
  declareTest(paste0("Patient has ", operator, " operator_concept_id"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = '<')
  expect_measurement(person_id = patient$person_id, operator_concept_id = 4171756)
  
  
  patient <- createPatient();
  claim <- createClaim();
  operator <- '='
  declareTest(paste0("Patient has ", operator, " operator_concept_id"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = operator)
  expect_measurement(person_id = patient$person_id, operator_concept_id = 4172703)
  
  
  patient <- createPatient();
  claim <- createClaim();
  operator <- '>='
  declareTest(paste0("Patient has ", operator, " operator_concept_id"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = operator)
  expect_measurement(person_id = patient$person_id, operator_concept_id = 4171755)
  
  
  patient <- createPatient();
  claim <- createClaim();
  operator <- '<='
  declareTest(paste0("Patient has ", operator, " operator_concept_id"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = operator)
  expect_measurement(person_id = patient$person_id, operator_concept_id = 4171754)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'LOW'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4267416)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'HIGH'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4328749)
  
  
  patient <- createPatient();
  claim <- createClaim();
  abnormal <- 'H'
  declareTest(paste0("Patient has ", result_text, " abnormal code"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, abnl_cd = abnormal)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4328749)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'NORMAL'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4069590)
  
  
  patient <- createPatient();
  claim <- createClaim();
  abnormal <- 'N'
  declareTest(paste0("Patient has ", result_text, " abnormal code"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, abnl_cd = abnormal)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4069590)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'ABNORMAL'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4135493)
  
  
  patient <- createPatient();
  claim <- createClaim();
  abnormal <- 'A'
  declareTest(paste0("Patient has ", result_text, " abnormal code"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, abnl_cd = abnormal)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4135493)
  
  
  patient <- createPatient();
  claim <- createClaim();
  abnormal <- 'AB'
  declareTest(paste0("Patient has ", result_text, " abnormal code"))
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, abnl_cd = abnormal)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4135493)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'ABSENT'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4132135)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'PRESENT'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 4181412)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'POSITIVE'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 9191)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'NEGATIVE'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 9189)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'FINAL'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 9188)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'FINAL REPORT'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 9188)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'NOT FOUND'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 9190)
  
  
  patient <- createPatient();
  claim <- createClaim();
  result_text <- 'TRACE'
  declareTest(paste0("Patient has ", result_text, " result text"), source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_txt = result_text)
  expect_measurement(person_id = patient$person_id, value_as_concept_id = 9192)
  
  
  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has unit of measurement", source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, rslt_unit_nm = 'cal')
  expect_measurement(person_id = patient$person_id, unit_concept_id = 9472)
  
  
  patient <- createPatient();
  claim <- createClaim();
  declareTest("Patient has normal range values", source_pid = patient$patid, cdm_pid = patient$person_id)
  add_member_detail(aso = 'N', bus = 'COM', cdhp = 3, eligeff = '2010-05-01', eligend = '2013-10-31',
                    gdr_cd = 'F', patid = patient$patid, pat_planid = patient$patid, product = 'HMO', yrdob = 1969)
  add_lab_results(labclmid = claim$clmid, fst_dt = '2013-07-01', pat_planid = patient$patid, patid = patient$patid, loinc_cd = '22962-5', 
                  rslt_nbr = 1000, low_nrml = 10, hi_nrml = 100)
  expect_measurement(person_id = patient$person_id, range_low = 10, range_high = 100)
  
}
