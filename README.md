# aws_resource_list

Shell Script that will connect to a Cloud Provider(mainly AWS) and will fetch the active number of resources.

- Validate that the user is actually giving 2 command line arguments.
$#- indicates command line arguments
$0- represents your script name - like ./abc.sh

- Shell Script can talk to AWS in two ways-
1 - API - but with this method we might need a lot of code as we will have to write curl commands for each AWS Service and make sure authentication is correct
2- AWS CLI - Using this shell script can talk to AWS CLI and AWS CLI will talk to AWS.Indirectly AWS CLI will make API calls only to AWS but on our behalf. SO our work of autheticating writing all curl commands will be reduced.

- If we were using python for this we would have used boto3