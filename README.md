### Description
- I created this project while learning awscli. Hope you find it useful 😍
- This Projects aims to create a basic infrastructure on an ec2 instance using aws cli.
- It will host a static site using nginx web server which can be accessed using the public ip of the instance. 
- This project also deletes the whole infrastructure if we wish to do so.
  
### Deliverables
1. A key pair to ssh into instance if required
2. A Security group allowing ssh at your ip and http from anywhere
3. An ec2 instance of type t2.micro in the default vpc and default subnet hosting a static site at port 80
4. A automated script to delete the entire infrastructure

### Pre-requisite
- awscli must be installed and configured correctly for creating and deleting resources in our account
```
region: us-east-2
output: json
```
If you wish to change the region, change the ami_id accordingly

- run `aws --version` for checking whether awscli is installed or not
- run `aws sts get-caller-identity` to verify that aws is configured correctly
- Check if the user has `AdministrationAccess` policy attached, if not attach this policy 

### Creating the EC2 resources
- The script `create_ec2_resources.sh` will create all the resources and store the id's of all created resources in file named id.txt in the same directory. 
```sh
# to run the create_ec2_resources.sh 
chmod +x create_ec2_resources.sh
./create_ec2_resources.sh
```
- Once we've successfully executed the above script. We'll extract the public ip of the instance stored in the id.txt file and wait for some time for the instance to host the website using the `usrdata.sh` script.
```sh
public_ip="$(awk '{ print $6 }' FS='[:,]' id.txt)"
echo $public_ip
# copy the generated ip 
# after some time, paste the ip in a browser at http protocol, ideally we should see a site hosted at this ip 
```
### Deleting the resources 
- We'll execute the `delete_ec2_resources.sh` to delete the entire infrastructure.
```sh
# to run the delete_ec2_resources.sh 
chmod +x delete_ec2_resources.sh
./delete_ec2_resources.sh
```

### Future Improvement
- We would first create a entire VPC infrastructure including multiple public and private subnets with route table and internet gateway across multiple availability zone, and launch our instance in a public subnet of this vpc instead of default. 
- It will give us more resilient and secure infrastructure.
- Setting up NAT gateways and bastion hosts would also be considered if we do need to keep some resources very private.
- We could also setup a ssh-key-pair to automate the ssh into the instance, if required.


