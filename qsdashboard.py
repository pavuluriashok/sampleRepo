import boto3
import json
from datetime import datetime, timedelta
import io
import time 
from operator import attrgetter
from awsglue.utils import getResolvedOptions
import sys

args = getResolvedOptions(sys.argv,['s3_target_bucket_name','s3_target_bucket_prefix'])

# AWS S3 bucket path
s3_bucketName = args['s3_target_bucket_name']
s3_key = args['s3_target_bucket_prefix']
s3_path = f"s3://{args['s3_target_bucket_name']}/{args['s3_target_bucket_prefix']}"
print("s3_path: ", s3_path)

# Define the job interval
default_end_time = datetime.utcnow()
default_start_time = default_end_time - timedelta(hours=100)
file_latest_timestamp = default_start_time #default value
print("default_start_time:{}, default_end_time:{} ".format(default_start_time,default_end_time))

#Element lookup in dict
def element_in_dict(d, key):
    return key in d
    
def getGetSortedObjList(bucketName,bucketKey):
    s3 = boto3.resource("s3")
    objs = s3.Bucket(bucketName).objects.filter(Prefix=bucketKey)
    sorted_objs = sorted(objs, key=attrgetter('last_modified'),reverse=False)
    return sorted_objs 
    
def getLastModifiedDate(bucketName,bucketKey):
    sorted_objs = getGetSortedObjList(bucketName,bucketKey)
    if(len(sorted_objs)<1):
        print("sorted object length is zero")
        return file_latest_timestamp
    # The latest version of the file (the last one in the list)
    latest = sorted_objs.pop()
    print("recent file",latest)
    print("last_modified date:{} ".format(latest.last_modified))
    return latest.last_modified.replace(tzinfo=None)


file_latest_timestamp = getLastModifiedDate(s3_bucketName,s3_key) 
#print("file_latest_timestamp:", file_latest_timestamp)
#file_latest_timestamp = default_start_time #default value
print("actual_start_time:{}, actual_end_time:{} ".format(file_latest_timestamp,default_end_time))

get_dashboard_events = []
next_token = None
cloudtrail = boto3.client('cloudtrail')

# Make the request to lookup events
while True:
    if next_token:
        response = cloudtrail.lookup_events(
            LookupAttributes=[
                {
                    'AttributeKey': 'EventName',
                    'AttributeValue': 'GetDashboard'
                },
            ],
            StartTime=file_latest_timestamp,
            EndTime=default_end_time,
            #MaxResults = 10,
            NextToken=next_token
        )
    else:
         response = cloudtrail.lookup_events(
            LookupAttributes=[
                {
                    'AttributeKey': 'EventName',
                    'AttributeValue': 'GetDashboard'
                },
            ],
            StartTime=file_latest_timestamp,
            EndTime=default_end_time
            #MaxResults = 10
        )
    
    # Retrieve the events
    for event in response["Events"]:
        response_elements = json.loads(event["CloudTrailEvent"])
        
        if element_in_dict(response_elements, "serviceEventDetails"):
            val = {
                    "UserName": event["Username"],
                    "EventID": event["EventId"],
                    "EventName": event["EventName"],
                    "DashboardName": response_elements["serviceEventDetails"]["eventResponseDetails"]["dashboardDetails"]["dashboardName"],
                    "EventDate": event["EventTime"].strftime("%Y-%m-%d")
                }
            get_dashboard_events.append(val)
    next_token = response.get('NextToken')
    if next_token is None: break    
    print("NextToken is : ",response.get('NextToken'))


#Create Pandas dataframe from list_dict
import pandas as pd
clog_df = pd.DataFrame.from_dict(get_dashboard_events)
print("Size of dataframe:{} ".format(len(clog_df)))

#Write dataframe into parquet file if its size > 0 only
if len(clog_df)>0:
    clog_df.to_parquet(s3_path, index=None, 
        partition_cols = ['EventDate'], compression='snappy')
print("job has been completed")