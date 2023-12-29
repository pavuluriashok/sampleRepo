This repository creates AWS resources defined in main_*.tf files.

If you need to create multiple resources of same type, lets say if you need 2 S3 buckets -> open main_s3.tf file, make a copy of the existing module, give the module a different name and pass appropriate parameters to the module. This would create 2 S3 buckets as part of this repository.

You can start the deployment from Bitbucket Build in jenkins menu, available next your branch. Alternatively you can trigger a deploy from jenkins, here is the job info<br />
https://jenkins.shared-dev.tanonprod.aegon.io/job/self-service/job/infrastructure/job/workplace/job/DEV_com.transamerica.mw.pipeline-terraform/<br />
This a parameterized job which will take below parameters<br />
ROOT_MODULE: TWCM<br />
PROJECT: WORKPLACECLOUD<br />
REPOSITORY: Your terraform code repository name<br />
BRANCH NAME: develop<br />
ENVIRONMENT: dev or tst<br />
### Necessary changes for DMS Creation.
DMS module expects the dms_source_database_password and dms_target_database_password in the AWS Secret Manager. Please use the jenkins job https://jenkins.shared-dev.tanonprod.aegon.io/job/self-service/job/Bitbucket-Self-Service/job/DEV_com.transamerica.mw.platform.secrets-manager/ to put password in the secret manager before deploying the terraform and use the Name of the secret with the variables below
*.tfvars.json
```
{
    ...
    "dms_source_engine_name": "<dms_source_engine_name>",
    "dms_source_database_name": "<dms_source_database_name>",
    "dms_source_database_username": "<dms_source_database_username>",
    "dms_source_database_password": "<secret_name_in_secret_manager>",
    "dms_source_database_host": "<dms_source_database_host>",
    "dms_source_engine_port": "<dms_source_engine_port>",
    "dms_source_connection_attr": "<dms_source_connection_attr>",
    "dms_target_engine_name": "<dms_target_engine_name>",
    "dms_target_database_name": "<dms_target_database_name>",
    "dms_target_database_username": "<dms_target_database_username>",
    "dms_target_database_password": "<secret_name_in_secret_manager>",
    "dms_target_database_host": "<dms_target_database_host>",
    "dms_target_engine_port": "<dms_target_engine_port>",
    "dms_target_connection_attr": "<dms_target_connection_attr>"
}
```
### Necessary changes for DYNAMODB Creation.
*.tfvars.json
```
{
  "dynamodb_hash_key"     : "<Test_key">,
  "dynamodb_hash_key_type": "<must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data>",
  "dynamodb_unique_id": "<uniquely identifies the table name, should be within 15 characters>"
}
```

### Necessary changes for EBS creation
The below variables are necessary for EBS to a create a volume successfully. 

*.tfvars.json
```
{
  "ebs_availability_zone": "<The AZ where the EBS volume will exist>",
  
}
```

### No necessary changes for EFS creation

### Necessary changes for ELASTICACHE_REDIS creation.
*.tfvars.json
```
{
  "elasticache_redis_cluster_name"        : "test_cluster",
  "elasticache_redis_engine_version"      : "<engine_version>",
  "elasticache_redis_node_type"           : "<node_type>",
  "elasticache_redis_parameter_group_name": "<name of the parameter group to associate with this cache cluster>",
} 
```

### No necessary changes for IAM creation except for the policy permissions

### Necessary changes for LINUX_AMI creation
The below variables are necessary for LINUX_AMI creation.

*.tfvars.json
```
{
    "linuxami_iam_role_ec2": "<instance_profile_name>",
    ...
    "linuxami_specific_ami": "<custom_ami_name>",
    ...
}
```

### Necessary changes for NLB creation
The below variables are necessary for NLB creation.

*.tfvars.json
```
{
    "nlb_tg_port": "<nlb_tg_port>",
    "nlb_tg_protocol": "<nlb_tg_protocol>",
    "nlb_tg_health_check_path": "<nlb_tg_health_check_path>",
    "nlb_tg_attachment_port": "<nlb_tg_attachment_port>",
    "nlb_listener_protocol": "<nlb_listener_protocol>",
    "nlb_route53_alias": "<nlb_route53_alias>"
}
```

### Necessary changes for RDS_AURORA_POSTGRESQL creation
 - Update the `rds_database_name` variable. It defaults to "testpostgres".
 - Update the `rds_master_username`. It defaults to "testpostgresadmin".

If you are deploying to the workplace-data-platform account, update the `rds_db_subnet_group_name` variable. Valid values are in the table below.

|Environment|Workplace           |Workplace Data Platform            |
|-----------|--------------------|-----------------------------------|
|Dev        |`workplace_non_prod`|`ta-workplace-dev-rds-subnet-group`|
|Test       |`workplace_tst`     |`ta-workplace-tst-rds-subnet-group`|
|Model      |`workplace_mdl`     |`ta-workplace-mdl-rds-subnet-group`|
|Production |`workplace_prd`     |`ta-workplace-prd-rds-subnet-group`|

*.tfvars.json
```
{
    ...
    "rds_database_name": "<your_database_name>",
    "rds_master_username": "<your_master_username>",
    ...
    "rds_db_subnet_group_name": "<see table above>",
}
```
### No necessary changes for RDS_MSSQL creation

### Necessary changes for REDSHIFT creation
The below variables are necessary for creating redshift.

*.tfvars.json
```
{
  "cluster_identifier"      : "<Must be a lower case string>",
  "redshift_cluster_name"   : "<your_cluster_name>",
  "redshift_node_type"      : "<The node type to be provisioned for the cluster>",
  "redshift_master_username": "<Required unless a snapshot_identifier is provided>",
  "redshift_master_password": "<(Required unless a snapshot_identifier is provided>",

}
```

### No necessary changes for S3 creation

### Necessary changes for SMB_FILESHARE creation
The below variables are necessary for SMB_FILESHARE creation.

*.tfvars.json
```
{
    ...
    "smbfileshare_s3_arn": "<s3_arn>",
    "smbfileshare_s3_name": "<s3_name>",
    ...
}
```

### Necessary changes for SNS creation
The below variables are necessary for SNS topic to subscribe to a service successfully. Let's say your SNS topic is subscribing to a SQS queue, you need to add subscribtion protocol and endpoint info in tfvars.json file

*.tfvars.json
```
{
    ...
    "sns_protocol": "sqs",
    "sns_endpoint": "arn:aws:sqs:us-east-1:754708396807:ta-wp-sqs-eng-test-dev",
    ...
}
```
If you are creating the SQS as part of this repository, then get the sqs arn as output from SQS module and point the endpoint like below in main_sns.tf. sns_protocol can still be set in tfvars.json like above.
```
module "sns_topic" {
    ...
    sns_endpoint   = module.sqs.sqs_arn
    ...
}
```

### Necessary changes for SQS creation
The below variables are necessary for SQS queue creation.

*.tfvars.json
```
{
    "sqs_fifo_queue": <true or false>,
    ...
    "sqs_queue_name": "<your_sqs_queue_name>",
    "sqs_queue_name_deadletter": "<your_deadletter_queue_name>",
    ...
}
```
If you set "sqs_fifo_queue": "true", you queue name should end with .fifo

### Necessary changes for WIN_AMI creation
The below variables are necessary for WIN_AMI creation.

*.tfvars.json
```
{
    ...
    "winami_specific_ami" : "<Replace Me>",
    ...
}
```
