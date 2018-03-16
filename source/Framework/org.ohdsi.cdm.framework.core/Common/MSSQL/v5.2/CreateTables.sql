CREATE TABLE {sc}.PERSON 
    (
     PERSON_ID						BIGINT		NOT NULL, 
     GENDER_CONCEPT_ID				BIGINT		NOT NULL , 
     YEAR_OF_BIRTH					INTEGER		NOT NULL , 
     MONTH_OF_BIRTH					INTEGER		NULL, 
     DAY_OF_BIRTH					INTEGER		NULL, 
	 BIRTH_DATETIME					VARCHAR(10)	NULL,
     RACE_CONCEPT_ID				BIGINT		NOT NULL, 
     ETHNICITY_CONCEPT_ID			BIGINT		NOT NULL, 
     LOCATION_ID					BIGINT		NULL, 
     PROVIDER_ID					BIGINT		NULL, 
     CARE_SITE_ID					BIGINT		NULL, 
     PERSON_SOURCE_VALUE			VARCHAR(250) NULL, 
     GENDER_SOURCE_VALUE			VARCHAR(250) NULL,
	 GENDER_SOURCE_CONCEPT_ID		BIGINT		NULL, 
     RACE_SOURCE_VALUE				VARCHAR(250) NULL, 
	 RACE_SOURCE_CONCEPT_ID			BIGINT		NULL, 
     ETHNICITY_SOURCE_VALUE			VARCHAR(250) NULL,
	 ETHNICITY_SOURCE_CONCEPT_ID	BIGINT		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.OBSERVATION_PERIOD 
    ( 
     OBSERVATION_PERIOD_ID				BIGINT		NOT NULL,
     PERSON_ID							BIGINT		NOT NULL, 
     OBSERVATION_PERIOD_START_DATE		DATE		NOT NULL ,
	 OBSERVATION_PERIOD_START_DATETIME	VARCHAR(10)	NOT NULL ,
	 OBSERVATION_PERIOD_END_DATE		DATE		NOT NULL ,
     OBSERVATION_PERIOD_END_DATETIME	VARCHAR(10)	NOT NULL ,
	 PERIOD_TYPE_CONCEPT_ID				BIGINT		NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);




CREATE TABLE {sc}.SPECIMEN
    ( 
     SPECIMEN_ID						BIGINT			NOT NULL ,
	 PERSON_ID							BIGINT			NOT NULL,
	 SPECIMEN_CONCEPT_ID				BIGINT			NOT NULL ,
	 SPECIMEN_TYPE_CONCEPT_ID			BIGINT			NOT NULL ,
	 SPECIMEN_DATE						DATE			NOT NULL ,
	 SPECIMEN_DATETIME					VARCHAR(10)		NULL ,
	 QUANTITY							FLOAT			NULL ,
	 UNIT_CONCEPT_ID					BIGINT			NULL ,
	 ANATOMIC_SITE_CONCEPT_ID			BIGINT			NULL ,
	 DISEASE_STATUS_CONCEPT_ID			BIGINT			NULL ,
	 SPECIMEN_SOURCE_ID					VARCHAR(250)		NULL ,
	 SPECIMEN_SOURCE_VALUE				VARCHAR(250)		NULL ,
	 UNIT_SOURCE_VALUE					VARCHAR(250)		NULL ,
	 ANATOMIC_SITE_SOURCE_VALUE			VARCHAR(250)		NULL ,
	 DISEASE_STATUS_SOURCE_VALUE		VARCHAR(250)		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.DEATH 
    ( 
     PERSON_ID							BIGINT			NOT NULL, 
     DEATH_DATE							DATE			NOT NULL , 
	 DEATH_DATETIME						VARCHAR(10)		NULL ,
     DEATH_TYPE_CONCEPT_ID				BIGINT			NOT NULL , 
     CAUSE_CONCEPT_ID					BIGINT			NULL , 
     CAUSE_SOURCE_VALUE					VARCHAR(250)		NULL,
	 CAUSE_SOURCE_CONCEPT_ID			BIGINT			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);




CREATE TABLE {sc}.VISIT_OCCURRENCE 
    ( 
     VISIT_OCCURRENCE_ID			BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     VISIT_CONCEPT_ID				BIGINT			NOT NULL , 
	 VISIT_START_DATE				DATE			NOT NULL ,
	 VISIT_START_DATETIME			VARCHAR(10)		NULL ,
	 VISIT_END_DATE					DATE			NOT NULL ,
	 VISIT_END_DATETIME				VARCHAR(10)		NULL ,
	 VISIT_TYPE_CONCEPT_ID			BIGINT			NOT NULL ,
	 PROVIDER_ID					BIGINT			NULL,
     CARE_SITE_ID					BIGINT			NULL, 
     VISIT_SOURCE_VALUE				VARCHAR(250)		NULL,
	 VISIT_SOURCE_CONCEPT_ID		BIGINT			NULL,
	 ADMITTING_SOURCE_CONCEPT_ID	INTEGER			NULL,
	 ADMITTING_SOURCE_VALUE			VARCHAR(250)		NULL,
	 DISCHARGE_TO_CONCEPT_ID		INTEGER			NULL,
	 DISCHARGE_TO_SOURCE_VALUE		VARCHAR(250)		NULL,
	 PRECEDING_VISIT_OCCURRENCE_ID	BIGINT			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.PROCEDURE_OCCURRENCE 
    ( 
     PROCEDURE_OCCURRENCE_ID		BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     PROCEDURE_CONCEPT_ID			BIGINT			NOT NULL , 
     PROCEDURE_DATE					DATE			NOT NULL , 
	 PROCEDURE_DATETIME				VARCHAR(10)		NOT NULL ,
     PROCEDURE_TYPE_CONCEPT_ID		BIGINT			NOT NULL ,
	 MODIFIER_CONCEPT_ID			BIGINT			NULL ,
	 QUANTITY						INTEGER			NULL , 
     PROVIDER_ID					BIGINT			NULL , 
     VISIT_OCCURRENCE_ID			BIGINT			NULL , 
     PROCEDURE_SOURCE_VALUE			VARCHAR(250)	NULL ,
	 PROCEDURE_SOURCE_CONCEPT_ID	BIGINT			NULL ,
	 QUALIFIER_SOURCE_VALUE			VARCHAR(250)		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);




CREATE TABLE {sc}.DRUG_EXPOSURE 
    ( 
     DRUG_EXPOSURE_ID				BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     DRUG_CONCEPT_ID				BIGINT			NOT NULL , 
     DRUG_EXPOSURE_START_DATE		DATE			NOT NULL ,
	 DRUG_EXPOSURE_START_DATETIME	VARCHAR(10)		NOT NULL ,
	 DRUG_EXPOSURE_END_DATE			DATE			NULL ,
	 DRUG_EXPOSURE_END_DATETIME		VARCHAR(10)		NULL ,
	 VERBATIM_END_DATE				DATE			NULL,
     DRUG_TYPE_CONCEPT_ID			BIGINT			NOT NULL , 
     STOP_REASON					VARCHAR(20)		NULL , 
     REFILLS						INTEGER			NULL , 
     QUANTITY						FLOAT			NULL , 
     DAYS_SUPPLY					INTEGER			NULL , 
     SIG							VARCHAR(8000)	NULL , 
	 ROUTE_CONCEPT_ID				BIGINT			NULL ,
	 LOT_NUMBER						VARCHAR(250)		NULL ,
     PROVIDER_ID					BIGINT			NULL , 
     VISIT_OCCURRENCE_ID			BIGINT			NULL , 
     DRUG_SOURCE_VALUE				VARCHAR(250)	NULL ,
	 DRUG_SOURCE_CONCEPT_ID			BIGINT			NULL ,
	 ROUTE_SOURCE_VALUE				VARCHAR(250)		NULL ,
	 DOSE_UNIT_SOURCE_VALUE			VARCHAR(250)		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.DEVICE_EXPOSURE 
    ( 
     DEVICE_EXPOSURE_ID				BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     DEVICE_CONCEPT_ID				BIGINT			NOT NULL , 
     DEVICE_EXPOSURE_START_DATE		DATE			NOT NULL ,
	 DEVICE_EXPOSURE_START_DATETIME	VARCHAR(10)		NOT NULL ,
	 DEVICE_EXPOSURE_END_DATE		DATE			NULL ,
	 DEVICE_EXPOSURE_END_DATETIME	VARCHAR(10)		NULL ,
     DEVICE_TYPE_CONCEPT_ID			BIGINT			NOT NULL , 
	 UNIQUE_DEVICE_ID				VARCHAR(250)		NULL ,
	 QUANTITY						INTEGER			NULL ,
     PROVIDER_ID					BIGINT			NULL , 
     VISIT_OCCURRENCE_ID			BIGINT			NULL , 
     DEVICE_SOURCE_VALUE			VARCHAR(100)	NULL ,
	 DEVICE_SOURCE_CONCEPT_ID		BIGINT			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.CONDITION_OCCURRENCE 
    ( 
     CONDITION_OCCURRENCE_ID		BIGINT			 NOT NULL,
     PERSON_ID						BIGINT			NOT NULL, 
     CONDITION_CONCEPT_ID			BIGINT			NOT NULL , 
     CONDITION_START_DATE			DATE			NOT NULL ,
	 CONDITION_START_DATETIME		VARCHAR(10)		NOT NULL ,
	 CONDITION_END_DATE				DATE			NULL ,
	 CONDITION_END_DATETIME			VARCHAR(10)		NULL ,
     CONDITION_TYPE_CONCEPT_ID		BIGINT			NOT NULL , 
     STOP_REASON					VARCHAR(20)		NULL , 
     PROVIDER_ID					BIGINT			NULL , 
     VISIT_OCCURRENCE_ID			BIGINT			NULL ,
	 CONDITION_STATUS_CONCEPT_ID	BIGINT			NULL ,
     CONDITION_SOURCE_VALUE			VARCHAR(250)		NULL ,
	 CONDITION_SOURCE_CONCEPT_ID	BIGINT			NULL,
	 CONDITION_STATUS_SOURCE_VALUE	VARCHAR(250)		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);




CREATE TABLE {sc}.MEASUREMENT 
    ( 
     MEASUREMENT_ID					BIGINT			 NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     MEASUREMENT_CONCEPT_ID			BIGINT			NOT NULL , 
     MEASUREMENT_DATE				DATE			NOT NULL , 
     MEASUREMENT_DATETIME			VARCHAR(10)		NULL ,
	 MEASUREMENT_TYPE_CONCEPT_ID	BIGINT			NOT NULL ,
	 OPERATOR_CONCEPT_ID			BIGINT			NULL , 
     VALUE_AS_NUMBER				FLOAT			NULL , 
     VALUE_AS_CONCEPT_ID			BIGINT			NULL , 
     UNIT_CONCEPT_ID				BIGINT			NULL , 
     RANGE_LOW						FLOAT			NULL , 
     RANGE_HIGH						FLOAT			NULL , 
     PROVIDER_ID					BIGINT			NULL , 
     VISIT_OCCURRENCE_ID			BIGINT			NULL ,  
     MEASUREMENT_SOURCE_VALUE		VARCHAR(250)	NULL , 
	 MEASUREMENT_SOURCE_CONCEPT_ID	BIGINT			NULL ,
     UNIT_SOURCE_VALUE				VARCHAR(250)		NULL ,
	 VALUE_SOURCE_VALUE				VARCHAR(500)	NULL
)ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.NOTE 
    ( 
     NOTE_ID						BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     NOTE_DATE						DATE			NOT NULL ,
	 NOTE_DATETIME					VARCHAR(10)		NULL ,
	 NOTE_TYPE_CONCEPT_ID			BIGINT			NOT NULL ,
	 NOTE_TEXT						VARCHAR(8000)	NOT NULL ,
     PROVIDER_ID					BIGINT			NULL ,
	 VISIT_OCCURRENCE_ID			BIGINT			NULL ,
	 NOTE_SOURCE_VALUE				VARCHAR(250)	NULL,
	 NOTE_CLASS_CONCEPT_ID			INTEGER			NOT NULL,
	 NOTE_TITLE						VARCHAR(250)	NULL,
	 ENCODING_CONCEPT_ID			INTEGER			NOT NULL,
	 LANGUAGE_CONCEPT_ID			INTEGER			NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);

CREATE TABLE {sc}.NOTE_NLP
(
  NOTE_NLP_ID					BIGINT			NOT NULL ,
  NOTE_ID						INTEGER			NOT NULL ,
  SECTION_CONCEPT_ID			INTEGER			NULL ,
  SNIPPET						VARCHAR(250)	NULL ,
  OFFSET						VARCHAR(250)	NULL ,
  LEXICAL_VARIANT				VARCHAR(250)	NOT NULL ,
  NOTE_NLP_CONCEPT_ID			INTEGER			NULL ,
  NOTE_NLP_SOURCE_CONCEPT_ID	INTEGER			NULL ,
  NLP_SYSTEM					VARCHAR(250)	NULL ,
  NLP_DATE						DATE			NOT NULL ,
  NLP_DATETIME					VARCHAR(10)		NULL ,
  TERM_EXISTS					CHAR(1)		NULL ,
  TERM_TEMPORAL					VARCHAR(50)		NULL ,
  TERM_MODIFIERS				VARCHAR(2000)	NULL
)ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.OBSERVATION 
    ( 
     OBSERVATION_ID                 BIGINT			 NOT NULL,
     PERSON_ID						BIGINT			NOT NULL, 
     OBSERVATION_CONCEPT_ID			BIGINT			NOT NULL , 
     OBSERVATION_DATE				DATE			NOT NULL , 
     OBSERVATION_DATETIME			VARCHAR(10)		NULL ,
     OBSERVATION_TYPE_CONCEPT_ID	BIGINT			NOT NULL , 
	 VALUE_AS_NUMBER				FLOAT			NULL , 
     VALUE_AS_STRING				VARCHAR(500)	NULL , 
     VALUE_AS_CONCEPT_ID			BIGINT			NULL , 
	 QUALIFIER_CONCEPT_ID			BIGINT			NULL ,
     UNIT_CONCEPT_ID				BIGINT			NULL , 
     PROVIDER_ID					BIGINT			NULL , 
     VISIT_OCCURRENCE_ID			BIGINT			NULL , 
     OBSERVATION_SOURCE_VALUE		VARCHAR(250)	NULL ,
	 OBSERVATION_SOURCE_CONCEPT_ID	BIGINT			NULL , 
     UNIT_SOURCE_VALUE				VARCHAR(250)		NULL ,
	 QUALIFIER_SOURCE_VALUE			VARCHAR(250)		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.FACT_RELATIONSHIP 
    ( 
     DOMAIN_CONCEPT_ID_1			BIGINT			NOT NULL , 
	 FACT_ID_1						BIGINT			NOT NULL ,
	 DOMAIN_CONCEPT_ID_2			BIGINT			NOT NULL ,
	 FACT_ID_2						BIGINT			NOT NULL ,
	 RELATIONSHIP_CONCEPT_ID		BIGINT			NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.LOCATION 
    ( 
     LOCATION_ID					BIGINT			NOT NULL , 
     ADDRESS_1						VARCHAR(250)		NULL , 
     ADDRESS_2						VARCHAR(250)		NULL , 
     CITY							VARCHAR(250)		NULL , 
     STATE							VARCHAR(2)		NULL , 
     ZIP							VARCHAR(9)		NULL , 
     COUNTY							VARCHAR(250)		NULL , 
     LOCATION_SOURCE_VALUE			VARCHAR(250)		NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.CARE_SITE 
    ( 
     CARE_SITE_ID						BIGINT			NOT NULL , 
	 CARE_SITE_NAME						VARCHAR(255)	NULL ,
     PLACE_OF_SERVICE_CONCEPT_ID		BIGINT			NULL ,
     LOCATION_ID						BIGINT			NULL , 
     CARE_SITE_SOURCE_VALUE				VARCHAR(250)		NULL , 
     PLACE_OF_SERVICE_SOURCE_VALUE		VARCHAR(250)		NULL
)ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);

	
CREATE TABLE {sc}.PROVIDER 
    ( 
     PROVIDER_ID					BIGINT			NOT NULL ,
	 PROVIDER_NAME					VARCHAR(255)	NULL , 
     NPI							VARCHAR(20)		NULL , 
     DEA							VARCHAR(20)		NULL , 
     SPECIALTY_CONCEPT_ID			BIGINT			NULL , 
     CARE_SITE_ID					BIGINT			NULL , 
	 YEAR_OF_BIRTH					INTEGER			NULL ,
	 GENDER_CONCEPT_ID				BIGINT			NULL ,
     PROVIDER_SOURCE_VALUE			VARCHAR(250)		NULL , 
     SPECIALTY_SOURCE_VALUE			VARCHAR(250)		NULL ,
	 SPECIALTY_SOURCE_CONCEPT_ID	BIGINT			NULL , 
	 GENDER_SOURCE_VALUE			VARCHAR(250)		NULL ,
	 GENDER_SOURCE_CONCEPT_ID		BIGINT			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.PAYER_PLAN_PERIOD 
    ( 
     PAYER_PLAN_PERIOD_ID			BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     PAYER_PLAN_PERIOD_START_DATE	DATE			NOT NULL , 
     PAYER_PLAN_PERIOD_END_DATE		DATE			NOT NULL , 
     PAYER_SOURCE_VALUE				VARCHAR (50)	NULL , 
     PLAN_SOURCE_VALUE				VARCHAR (50)	NULL , 
     FAMILY_SOURCE_VALUE			VARCHAR (50)	NULL 
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.COST 
(
    cost_id bigint NOT NULL, 
    cost_event_id bigint NOT NULL, 
    cost_domain_id varchar(20) NOT NULL, 
    cost_type_concept_id int NOT NULL, 
    currency_concept_id int NULL, 
    total_charge float NULL, 
    total_cost float NULL, 
    total_paid float NULL, 
    paid_by_payer float NULL, 
    paid_by_patient float NULL, 
    paid_patient_copay float NULL, 
    paid_patient_coinsurance float NULL, 
    paid_patient_deductible float NULL, 
    paid_by_primary float NULL, 
    paid_ingredient_cost float NULL, 
    paid_dispensing_fee float NULL, 
    payer_plan_period_id int NULL, 
    amount_allowed float NULL, 
    revenue_code_concept_id int NULL, 
    revenue_code_source_value  varchar(50)		null ,
	drg_concept_id			integer			null,
	drg_source_value			char(3)		null
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);



CREATE TABLE {sc}.COHORT 
    ( 
	 COHORT_DEFINITION_ID			BIGINT			NOT NULL, 
     SUBJECT_ID						BIGINT			NOT NULL,
	 COHORT_START_DATE				DATE			NOT NULL , 
     COHORT_END_DATE				DATE			NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);

CREATE TABLE {sc}.COHORT_ATTRIBUTE 
    ( 
	 COHORT_DEFINITION_ID			BIGINT			NOT NULL , 
     COHORT_START_DATE				DATE			NOT NULL , 
     COHORT_END_DATE				DATE			NOT NULL , 
     SUBJECT_ID						BIGINT			NOT NULL, 
     ATTRIBUTE_DEFINITION_ID		BIGINT			NOT NULL ,
	 VALUE_AS_NUMBER				FLOAT			NULL ,
	 VALUE_AS_CONCEPT_ID			BIGINT			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);




CREATE TABLE {sc}.DRUG_ERA 
    ( 
     DRUG_ERA_ID					BIGINT			 NOT NULL,
     PERSON_ID						BIGINT			NOT NULL, 
     DRUG_CONCEPT_ID				BIGINT			NOT NULL , 
     DRUG_ERA_START_DATE			DATE			NOT NULL , 
     DRUG_ERA_END_DATE				DATE			NOT NULL , 
     DRUG_EXPOSURE_COUNT			INTEGER			NULL ,
	 GAP_DAYS						INTEGER			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.DOSE_ERA 
    (
     DOSE_ERA_ID					BIGINT			NOT NULL , 
     PERSON_ID						BIGINT			NOT NULL, 
     DRUG_CONCEPT_ID				BIGINT			NOT NULL , 
	 UNIT_CONCEPT_ID				BIGINT			NOT NULL ,
	 DOSE_VALUE						FLOAT			NOT NULL ,
     DOSE_ERA_START_DATE			DATE			NOT NULL , 
     DOSE_ERA_END_DATE				DATE			NOT NULL 
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);




CREATE TABLE {sc}.CONDITION_ERA 
    ( 
     CONDITION_ERA_ID				BIGINT			 NOT NULL,
     PERSON_ID						BIGINT			NOT NULL, 
     CONDITION_CONCEPT_ID			BIGINT			NOT NULL , 
     CONDITION_ERA_START_DATE		DATE			NOT NULL , 
     CONDITION_ERA_END_DATE			DATE			NOT NULL , 
     CONDITION_OCCURRENCE_COUNT		INTEGER			NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);

CREATE TABLE {sc}.CDM_SOURCE(
	CDM_SOURCE_NAME varchar(250) NOT NULL,
	CDM_SOURCE_ABBREVIATION VARCHAR(250) NOT NULL,
	CDM_HOLDER VARCHAR(250) NOT NULL,
	SOURCE_DESCRIPTION varchar(max) NOT NULL,
	SOURCE_DOCUMENTATION_REFERENCE varchar(250) NOT NULL,
	CDM_ETL_REFERENCE varchar(250) NOT NULL,
	SOURCE_RELEASE_DATE varchar(10) NOT NULL,
	CDM_RELEASE_DATE varchar(10) NOT NULL,
	CDM_VERSION VARCHAR(250) NOT NULL,
	VOCABULARY_VERSION VARCHAR(250) NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);

CREATE TABLE {sc}.COHORT_DEFINITION(
	COHORT_DEFINITION_ID bigint NOT NULL,
	COHORT_DEFINITION_NAME varchar(250) NOT NULL,
	COHORT_DEFINITION_DESCRIPTION varchar(max) NOT NULL,
	DEFINITION_TYPE_CONCEPT_ID bigint NULL,
	COHORT_DEFINITION_SYNTAX varchar(250) NULL,
	SUBJECT_CONCEPT_ID bigint NULL,
	COHORT_INITIATION_DATE date NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);


CREATE TABLE {sc}.CDM_DOMAIN_META (
DOMAIN_ID varchar(20),
DESCRIPTION varchar(4000)
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
);
