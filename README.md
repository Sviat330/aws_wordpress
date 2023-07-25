## WordPress Deployment on AWS ##

## Project Overview: ##
The "WordPress Deployment on AWS" project aimed to deploy a fully functional WordPress website on Amazon Web Services (AWS) cloud infrastructure using terraform. By utilizing AWS services, the project achieved high availability, scalability, and security for the WordPress application.

## Technologies Used: ##

AWS (Amazon Web Services) for cloud infrastructure
WordPress for content management and website creation
Auto Scaling Groups with EC2 for hosting WordPress application
Amazon RDS for the database tier
Amazon ALB for load balancing
Amazon EFS for media and asset storage

## Key Features: ##

Auto Scaling: To accommodate fluctuating traffic, the application servers were configured with auto-scaling, dynamically adjusting the number of instances based on demand.

High Availability: The project deployed WordPress on multiple Amazon EC2 instances spread across different availability zones, ensuring high availability and minimizing downtime.

Auto Scaling: By configuring an Auto Scaling Group, the WordPress application automatically scaled based on traffic load, optimizing resource utilization.

Load Balancing: An Application Load Balancer (ALB) was implemented to distribute incoming traffic across multiple wordpress  instances.

Database Management: Amazon RDS was used to manage the MySQL database, providing automated backups, scalability, and easy management.

Media and Asset Storage: Amazon EFS was utilized to store media files and assets, offloading the server's storage and enhancing performance.

Security: AWS security groups and IAM roles were employed to control access to instances and resources, ensuring a secure WordPress deployment.

## Design and Architecture: ##
The architecture involved the following components:

WordPress Application Layer: Multiple Amazon EC2 instances hosted the WordPress application, with an Elastic Load Balancer (ELB) distributing traffic among them.
Database Layer: Amazon RDS hosted the MySQL database, providing a reliable and scalable backend for WordPress data.
Media Storage: Amazon EFS stored uploaded media files, providing durability and reducing the load on the application servers.


## Deployment Process: ##
The deployment process was automated using Terraform. The configuration files defined the necessary AWS resources and configurations, making it easy to replicate the infrastructure across different environments.


## Challenges and Learnings: ##
The main  challenge was implementing the storage that multiple instances could use for storing content. For was used an Elastic File System and mount it to multiple instances using EC2 user data. 

## Usage ##

Change files in infra/prod/ to set your variables
Setup aws credentials.
Depends on OS you are using.
On Linux:
```
export AWS_ACCESS_KEY=YOUR_VALUE
export AWS_SECRET_KEY=YOUR_VALUE
```
On Windows:
```
set AWS_ACCESS_KEY=YOUR_VALUE
set AWS_SECRET_KEY=YOUR_VALUE
```
Now go to the directory infra/prod and run below commands<br />
```
terraform init
terraform plan
terraform apply
```
Your wordpress site is ready to go.


## Conclusion: ##
The "WordPress Deployment on AWS" project successfully demonstrated the deployment of a scalable, highly available, and secure WordPress website on AWS infrastructure. Through this project, I gained hands-on experience in architecting cloud-based solutions, managing AWS resources, and optimizing web application performance.

