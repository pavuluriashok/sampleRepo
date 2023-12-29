#######################IAM####################
 module "execution_iam" {
  source                           = "git::http://bitbucket.us.aegon.com/scm/twcm/transamerica.workplace.cloud.module.execution_iam.git?ref=V1.0.2"
  role_name                        = var.iam_role_name
  customer_managed_policy_list     = var.iam_customer_managed_policy_list
  additional_trust_vars            = var.iam_additional_trust_vars
  managed_policy_count             = var.iam_managed_policy_count
  max_session_duration             = var.iam_max_session_duration
  description                      = "Role for ${var.application} resources"
  team_name                        = "Role for ${var.application} resources"
  initiative_id                    = var.initiative_id
  initiative_type                  = var.initiative_type
  additional_vars                  = {"account_number" = var.account_number, "environment" = var.environment}
  permissions_boundary             = "arn:aws:iam::${var.account_number}:policy/AGT-IAM-BOUNDARY-BASE"
  trust_relationship_template_file = "./iam/glue-trust.json.tpl"
  aws_managed_policy_list          = [
    "AWSCloudTrail_ReadOnlyAccess",
    "service-role/AWSGlueServiceRole"
  ]
    policy_template_paths            = [
    "./iam/kms_cloudwatch1.json.tpl",
    "./iam/ta-wpdata-datalake-glue-glue.json.tpl",
    "./iam/ta-wpdata-datalake-glue-glue-s3.json.tpl",
    "./iam/KMSKeypermission_SSE_to_kms.json.tpl"
  ]
  division                         = var.division
  application                      = var.application
  account_number                   = var.account_number
  resource_purpose                 = var.resource_purpose
  department                       = var.department
  billing_cost_center              = var.billing_cost_center
  resource_contact                 = var.resource_contact
  environment                      = var.environment
  channel                          = var.channel
  agt_managed                       = var.agt_managed
  application_tag                  = var.application_tag
  additional_tags                  = {"DigitalPlatform" = "true"}
  primary_lob                      = var.primary_lob
  secondary_lob                    = var.secondary_lob
  bitbucket_repo                   = var.bitbucket_repo
  jenkins_job                      = var.jenkins_job_iam
}


################Glue Job###################
 module "py-glue-job" {
  source               = "git::http://bitbucket.us.aegon.com/scm/twcm/transamerica.workplace.cloud.module.glue_job.git"
  count = "${length(var.script_location)}"
  glue_job_name        = "qsdashboard"
  alert_topic_arn = var.alert_topic_arn
  create_alerts = var.create_alerts
  glue_job_role_arn    = var.glue_job_role_arn
  glue_job_connections = var.glue_job_connections
  glue_job_version = "1.0"
  glue_job_max_retries = 2

  glue_job_execution_property = [{
    max_concurrent_runs = 1
  }]

  glue_job_default_arguments = {
    #"--s3_target_bucket_name"          = "${var.department}-daca-app-codefiles-${lower(var.environment)}"
    #"--s3_target_bucket_name"          = "ta-wpdata-772658258567-us-east-1-dev-curated-retirement"
    #"--s3_target_bucket_prefix" 		= "dc/curated_model/apavul/qs_clogs1/"
    "--s3_target_bucket_name"          = "${var.s3_target_bucket_name}"
    "--s3_target_bucket_prefix" 		= "${var.s3_target_bucket_prefix}"
    "--job-bookmark-option"     = "job-bookmark-disable"
    "--job-language"            = "python"
    "--enable-metrics"          = "true"
    "--encryption-type"         = "sse-s3"
    "--continuous-log-logGroup"    = var.continuous-log-logGroup
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--max-capacity" = "1.0"
  }

  glue_job_command = [{
    name            = "pythonshell"
    #script_location = "s3://ta-wpdata-foundational-${var.account_number}-codedeployment-${lower(var.environment)}/transamerica.cloud.workplace.dataplatform.qsstats/py/qsdashboard.py"
    script_location = "s3://ta-wpdata-${var.account_number}-us-east-1-${var.environment}-landing-retirement/deploy/transamerica.cloud.workplace.dataplatform.qsstats/py/qsdashboard.py"
    python_version  = "3.9"
  }]
  additional_tags     = var.additional_tags
  agt_managed         = var.agt_managed
  application         = var.application
  application_tag     = var.application_tag
  bitbucket_repo      = var.bitbucket_repo
  environment         = var.environment
  jenkins_job         = var.jenkins_job
  primary_lob         = var.primary_lob
  resource_contact    = var.resource_contact
  resource_purpose    = var.resource_purpose
  initiative_id       = var.initiative_id
  initiative_type     = var.initiative_type
  department          = var.department
  unique_id           = "qs-metric"
}

################Glue Triggers For PyShell Job###################
module "trg-py-shell-job" {
  source                    = "git::http://bitbucket.us.aegon.com/scm/twcm/transamerica.workplace.cloud.module.glue_trigger.git" 
  glue_trigger_name          = "trg-load-csv"
  glue_trigger_schedule      = "cron(35 4 * * ? *)"
  glue_trigger_type          = "SCHEDULED"
  enable_glue_trigger		= true 
  glue_job_name             = "ta-wpdata-${lower(var.environment)}-qs-metric-ap-tg-apm0001899-workplace-data-platform"
  #glue_job_name             = module.py-glue-job.id
  unique_id                 = "qs-metric-trg"
  
  glue_trigger_actions = [{
    glue_job_name = "ta-wpdata-${lower(var.environment)}-qs-metric-ap-tg-apm0001899-workplace-data-platform"
    
    arguments= {
      "--job-bookmark-option"     = "job-bookmark-disable"
        }
    }]

  additional_tags     = var.additional_tags
  agt_managed         = var.agt_managed
  application_tag     = var.application_tag
  application         = var.application
  bitbucket_repo      = var.bitbucket_repo
  environment         = var.environment
  jenkins_job         = var.jenkins_job
  primary_lob         = var.primary_lob
  resource_contact    = var.resource_contact
  resource_purpose    = var.resource_purpose
  initiative_id       = var.initiative_id
  initiative_type     = var.initiative_type
  department          = var.department
 }


################Glue Crawler###################
 module "glue_crawler" {
 source               = "git::http://bitbucket.us.aegon.com/scm/twcm/transamerica.workplace.cloud.module.glue_crawler.git"
  glue_crawler_database_name = "wp_datalake"
  glue_crawler_name          = substr(replace("${var.department}-${var.environment}-qs-crawler-AP-TG-${var.application_tag}","/[ :]/","-"),0,255)
  glue_crawler_role          = var.glue_job_role_arn

  glue_crawler_s3_target = [{
    #path = "ta-wpdata-772658258567-us-east-1-dev-curated-retirement/dc/curated_model/apavul/qs_clogs/"
    path = "${var.s3_target_bucket_name}/${var.s3_target_bucket_prefix}"
    exclusions = []
  }]
  
  additional_tags     = var.additional_tags
  agt_managed         = var.agt_managed
  application_tag     = var.application_tag
  bitbucket_repo      = var.bitbucket_repo
  environment         = var.environment
  jenkins_job         = var.jenkins_job
  primary_lob         = var.primary_lob
  resource_contact    = var.resource_contact
  resource_purpose    = var.resource_purpose
  initiative_id        = var.initiative_id
  initiative_type      = var.initiative_type
  unique_id            = "qs-metric"
  department          = var.department
}


################Glue Triggers For Crawler###################
module "trg-crawler-qs" {
  source                    = "git::http://bitbucket.us.aegon.com/scm/twcm/transamerica.workplace.cloud.module.glue_trigger.git" 
  #glue_trigger_name          = "trg-load-csv"
  glue_trigger_schedule      = "cron(15 5 * * ? *)"
  glue_trigger_type          = "SCHEDULED"
  enable_glue_trigger		= true 
  glue_crawler_name          = substr(replace("${var.department}-${var.environment}-qs-crawler-AP-TG-${var.application_tag}","/[ :]/","-"),0,255)
  unique_id                 = "qs-metric"
  
    glue_trigger_actions = [{
        crawler_name = substr(replace("${var.department}-${var.environment}-qs-crawler-AP-TG-${var.application_tag}","/[ :]/","-"),0,255)
    }]

  additional_tags     = var.additional_tags
  agt_managed         = var.agt_managed
  application_tag     = var.application_tag
  application         = var.application
  bitbucket_repo      = var.bitbucket_repo
  environment         = var.environment
  jenkins_job         = var.jenkins_job
  primary_lob         = var.primary_lob
  resource_contact    = var.resource_contact
  resource_purpose    = var.resource_purpose
  initiative_id       = var.initiative_id
  initiative_type     = var.initiative_type
  department          = var.department
 }


 