This repo here has all the necessary code in Terraform required to implement Jenkins on an EC2 instance in AWS.

It also contains network configuration aspects to implement the following:
1. VPC
2. IGW
3. Public Subnet
4. Route table with association to the public subnet
5. Security group for the EC2 instance

An S3 backend block is added within the provider.tf file to configure remote backend. You will have to create the s3 bucket separately (either through the management console or through another resource block)


Further, following updates will be added:
1. Jenkins worker nodes
2. Improved security (SG hardening)
3. Separate subnet for the worker nodes (preferably private)
4. An eip association to the Jenkins controller instance to maintain a constant IP address
