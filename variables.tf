##General variables##
variable "region" {
  description = "Region everything is executed in."
  default     = "us-east-1"
}

variable "account_number" {
  description = "Account number everything is executed in."
}

variable "environment" {
  description = "dtap environment (DEV/TST/MDL/ACC/PRD)"
}

variable "department" {
  description = "department that owns the environment"
}

variable "channel" {
  description = "channel tag"
}

variable "division" {
  description = "Division responsible for instance (tag based on cloud custodian)"
  default     = "transamerica"
}

variable "application" {
  description = "Application name"  
  type = string
}

variable "application_tag" {
  description = "Application number from CMDB"  
  type = string
}

variable "billing_cost_center" {
  description = "provide a cost center for billing reporting"
}

variable "resource_contact" {
  description = "Email address for the contact"
}

variable "resource_purpose" {
  description = "ResourcePurpose: Application Name"
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of additional tags to assign to the resource"
  default     = {}
}

variable "agt_managed" {
  description = "AGTManaged  - Valid Options: true, false. An AGT managed server (true) is one which has a saved state, backups, and patches and is also referred to as Stateful. On the other hand a non-AGT managed server (false) is considered stateless and requires no recovery if it were to crash as there is no custom state configurations."
  default     = false
  type        = bool
}

variable "bitbucket_repo" {
  description = "Bit Bucket repository URL"  
  type = string
}

variable "jenkins_job" {
  description = "Jenkins Job URL"  
  type = string
}

variable "primary_lob" {
  description = "Primary line of Business"  
  type = string
}

variable "secondary_lob" {
  description = "Secondary line of Business"
  type = string
}

variable "rts_initiative" {
  description = "RTS Initiative Number"  
  type = string
}

variable "initiative_type" {
  description = "initiative_type"
  type        = string
}

variable "initiative_id" {
  description = "initiative_id"
  type        = string
}



# IAM specific
variable "iam_role_name" {
  description = "AD Group Name"
}

variable "glue_iam_role_name" {
  description = "AD Group Name"
}

variable "iam_policy_template_paths" {
  description = "List of IAM Policy file paths as .json.tpl Files"
  type        = list(string)
  default     = []
}

variable "iam_trust_relationship_template_file" {
  description = <<EOF
    A template file to use for the trust relationship
    gets account_number variable passed automatically.
    account_number can be used in the template file if
    needed.
    EOF
}

variable "iam_additional_vars" {
  type        = map(string)
  description = "A mapping of additional vars to pass to the template_file for the policy"
  default     = {}
}

variable "iam_additional_trust_vars" {
  type        = map(string)
  description = "A mapping of additional vars to pass to the template_file for the trust"
  default     = {}
}

variable "iam_permissions_boundary" {
  description = "ARN for permission boundary policy"
  default     = ""
}

variable "iam_aws_managed_policy_list" {
  description = "List of aws managed policy names as strings"
  type        = list(string)
  default     = []
}

variable "iam_customer_managed_policy_list" {
  description = "List of customer managed policy names as strings"
  type        = list(string)
  default     = []
}

variable "iam_managed_policy_count" {
  description = "Number of Managed Policies"
  default     = 20
}

variable "iam_max_session_duration" {
  type        = number
  description = "The maximum session duration (in seconds) that you want to set for the specified role."
  default     = 3600
}

# Glue

   
variable "glue_connection_name" {
  description = "(Required) Connection Name"

}

variable "dashboard_y_offset" {
  type        = number
  description = "The Y offset for the Dashboard"
  default     = 0
}

variable "alert_topic_arn" {
  description = "Alert Topic ARN."
  type        = string
}


variable "unique_id" {
  description = "List nested Specifies a unique id"
  default     = []
  validation {
    condition     = length(var.unique_id) < 15
    error_message = "The unique_id should be less than 15 characters."
  }
}

variable "create_alerts" {
  description = "create volume flag - Valid Options: true, false."
  default     = true
  type        = bool
}
variable "glue_connection_connection_properties" {
  description = "(Required) A map of key-value pairs used as parameters for this connection."
  default     = {}
}

variable "glue_connection_description" {
  description = "(Optional) Description of the connection."
  default     = null
}

variable "glue_connection_catalog_id" {
  description = "(Optional) The ID of the Data Catalog in which to create the connection. If none is supplied, the AWS account ID is used by default."
  default     = null
}

variable "glue_connection_connection_type" {
  description = "(Optional) The type of the connection. Supported are: JDBC, MONGODB. Defaults to JDBC."
  default     = "JDBC"
}

variable "glue_connection_match_criteria" {
  description = "(Optional) A list of criteria that can be used in selecting this connection."
  default     = null
}

variable "glue_connection_physical_connection_requirements" {
  description = "(Optional) A map of physical connection requirements, such as VPC and SecurityGroup. "
  default     = []
}

#---------------------------------------------------
# AWS Glue trigger
#---------------------------------------------------
variable "enable_glue_trigger" {
  description = "Enable glue trigger usage"
  default     = false
}

variable "glue_trigger_name" {
  description = "The name of the trigger."
  default     = ""
}

variable "glue_job_name" {
  description = "The name of the gluejob."
  default     = ""
}

variable "job_name" {
  description = "List nested job names (job_name)"
  default     = []
}

variable "glue_crawler_name" {
  description = "The name of the gluejob."
  default     = ""
}

variable "jdbc_connection_url" {
  description = "JDBC connection url"
  type = string
  default = ""
}

variable "conn_unique_id" {
  description = "Specifies a unique id for data connection"
  type = string
  validation {
    condition     = length(var.conn_unique_id) < 15
    error_message = "The unique_id should be less than 15 characters."
  }
}

variable "glue_trigger_type" {
  description = "(Required) The type of trigger. Valid values are CONDITIONAL, ON_DEMAND, and SCHEDULED."
  default     = "ON_DEMAND"
}

variable "glue_trigger_description" {
  description = "(Optional) A description of the new trigger."
  default     = null
}

variable "glue_trigger_enabled" {
  description = "(Optional) Start the trigger. Defaults to true. Not valid to disable for ON_DEMAND type."
  default     = null
}

variable "glue_trigger_schedule" {
  description = "(Optional) A cron expression used to specify the schedule. Time-Based Schedules for Jobs and Crawlers"
  default     = null
}

variable "glue_trigger_workflow_name" {
  description = "(Optional) A workflow to which the trigger should be associated to. Every workflow graph (DAG) needs a starting trigger (ON_DEMAND or SCHEDULED type) and can contain multiple additional CONDITIONAL triggers."
  default     = null
}

variable "glue_trigger_actions" {
  description = "(Required) List of actions initiated by this trigger when it fires. "
  default     = []
}

variable "glue_trigger_timeouts" {
  description = "Set timeouts for glue trigger"
  default     = []
}

variable "glue_trigger_predicate" {
  description = "(Optional) A predicate to specify when the new trigger should fire. Required when trigger type is CONDITIONAL"
  default     = []
}

variable "py_files" {
  description = "List nested extra py files (py_files)"
  default     = []
}

################# Tag Variables End ######################################

#Don't change anything lower!!!
variable "environment_full" {
  default = {
    DEV = "Development"
    TST = "Test"
    MDL = "Model"
    ACC = "Acceptance"
    PRD = "Production"
  }
}

variable "glue_job_role_arn" {
  type = string
}
variable "input_table_name" {
  type = string
}

variable "s3_target_bucket_name" {
  type = string
}

variable "s3_target_bucket_prefix" {
  type = string
}

variable "continuous-log-logGroup" {
   type = string
}


variable "script_location" {
  description = "List nested target arguments (s3_path)"
  default     = []
}

variable "glue_job_connections" {
  type = list(string)
  default = null
}


################IAM##################################
variable "role_name" {
  description = "Name of IAM role"
  type        = string
}


variable "assume_role_policy" {
  description = "Trust policy for IAM role"
  type        = string
}

variable "permissions_boundary" {
  description = "Permissions Boundary to attach to IAM role"
  type        = string
}

variable "description" {
  description = "Description of IAM role"
  type        = string
  default     = ""
}

variable "role_policy_attachment_arns" {
  description = "List of Policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether or not to create an instance profile associated with this role."
  type        = bool
  default     = false
}

variable "jenkins_job_iam" {
  description = "Jenkins Job URL"  
  type = string
}

