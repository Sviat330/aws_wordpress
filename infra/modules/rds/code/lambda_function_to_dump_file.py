import os
import boto3


AMI = 'ami-0cf14aecde598bc8f'
INSTANCE_TYPE = 't3.micro'
SUBNET_ID = os.environ["SUBNET_ID"]
DB_USERNAME = os.environ["DB_USERNAME"]
DB_PASS=os.environ["DB_PASS"]
DB_PORT=os.environ["DB_PORT"]
DB_NAME=os.environ["DB_NAME"]
REGION=os.environ["REGION"]
InstanceProfile=os.environ["InstanceProfile"]


ec2 = boto3.resource('ec2')
rds=boto3.client('rds')

def lambda_handler(event, context):
    db_id=event['DB_ID']
    response= rds.describe_db_instances(
        DBInstanceIdentifier=db_id
    )
    db_endpoint=response['DBInstances'][0]['Endpoint']['Address']
    
    data_source=f'''
#!/bin/bash
sudo yum -y update
sudo yum -y install mysql
sudo aws s3 cp s3://pekarini-s3-ecs-files/bloodbank.sql /bloodbank.sql
sudo mysql -u {DB_USERNAME} -P {DB_PORT} -h {db_endpoint} -p{DB_PASS} {DB_NAME} < /bloodbank.sql
sudo aws ec2 terminate-instances --instance-ids $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --region {REGION}
'''
    instance = ec2.create_instances(
        ImageId=AMI,
        InstanceType=INSTANCE_TYPE,
        MaxCount=1,
        MinCount=1,
        
        IamInstanceProfile={
            'Arn': InstanceProfile
        },
        NetworkInterfaces =[
            {
                'AssociatePublicIpAddress': True,
                'DeviceIndex': 0,
                'SubnetId': SUBNET_ID,
            }],
        UserData=data_source
        
        
    )
    print("New instance created:", instance[0].id)
    print(data_source)
    