#!/bin/bash
export PATH=$PATH:/usr/local/bin
# This script lists all AWS resources in the current account and region.
########################
# Usage: ./aws_resource_list.sh
# Author : Krati
# Date   : 2024-06-01
# version: 1.0

# Following are the supported AWS Services by the script:
# 1. EC2 Instances
# 2. S3 Buckets
# 3. RDS Instances
# 4. Lambda Functions
# 5. CloudFormation Stacks
# 6. IAM Users
# 7. VPCs
# 8. EBS Volumes
# 9. CloudWatch Alarms
# 10. SNS Topics
# 11. SQS Queues
# 12. DynamoDB Tables
# 13. CloudFront Distributions
########################

# Check if user is giving two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <AWS_REGION> <SERVICE_NAME>"
    exit 1
fi

 # Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install it and configure your credentials."
    exit 1
fi

# check if AWS CLI is configured
if [ ! -f ~/.aws/credentials ]; then
    echo "AWS CLI is not configured. Please configure your credentials."
    exit 1
fi

# Execute the AWS CLI command based on the service name
case "$2" in
    "ec2")
        echo "ec2 instances -----"
        aws ec2 describe-instances --region "$1" --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,Type:InstanceType,LaunchTime:LaunchTime}' --output table
        ;;
    "s3")
        aws s3api list-buckets --query 'Buckets[].Name' --output table
        ;;
    "rds")
        aws rds describe-db-instances --region "$1" --query 'DBInstances[].{DBInstanceIdentifier:DBInstanceIdentifier,DBInstanceClass:DBInstanceClass,Engine:Engine,DBInstanceStatus:DBInstanceStatus}' --output table
        ;;
    "lambda")
        aws lambda list-functions --region "$1" --query 'Functions[].{FunctionName:FunctionName,Runtime:Runtime,LastModified:LastModified}' --output table
        ;;
    "cloudformation")
        aws cloudformation describe-stacks --region "$1" --query 'Stacks[].{StackName:StackName,StackStatus:StackStatus,CreationTime:CreationTime}' --output table
        ;;
    "iam")
        aws iam list-users --query 'Users[].{UserName:UserName,UserId:UserId,CreateDate:CreateDate}' --output table
        ;;
    "vpc")
        aws ec2 describe-vpcs --region "$1" --query 'Vpcs[].{VpcId:VpcId,CidrBlock:CidrBlock,State:State}' --output table
        ;;
    "ebs")
        aws ec2 describe-volumes --region "$1" --query 'Volumes[].{VolumeId:VolumeId,Size:Size,State:State}' --output table
        ;;
    "cloudwatch")
        aws cloudwatch describe-alarms --region "$1" --query 'MetricAlarms[].{AlarmName:AlarmName,StateValue:StateValue,MetricName:MetricName}' --output table
        ;;
    "sns")
        aws sns list-topics --region "$1" --query 'Topics[].TopicArn' --output table
        ;;
    "sqs")
        aws sqs list-queues --region "$1" --query 'QueueUrls[]' --output table
        ;;
    "dynamodb")
        aws dynamodb list-tables --region "$1" --query 'TableNames[]' --output table
        ;;
    "cloudfront")
        aws cloudfront list-distributions --query 'DistributionList.Items[].{Id:Id,DomainName:DomainName,Status:Status}' --output table
        ;;
    *)
        echo "Unsupported service. Supported services are: ec2, s3, rds, lambda, cloudformation, iam, vpc, ebs, cloudwatch, sns, sqs, dynamodb, cloudfront."
        exit 1
        ;;
esac