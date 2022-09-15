# Cycloid

- What have you done?
    
    provision IAC on AWS with [ `Terrafrom`, `Packer`, `Ansible`] for `Wordpress` using `ECS and RDS`
    
- How did you run your project?
    1. First run `Packer` with `Ansible` to create `Golden image` of  `EC2 Wordpress`
    2. Run `Terrafrom` to launch and release service.
- What are the components interacting with each other?
    1. `Ansible` interacting between `Packer` and `Terrafrom` for this topology.
- What problems did you encounter?
    1. no previous experience on `Terrafrom` and `Packer`, so I took courses for both tool and based on that I created the `IaC`  for this repo.
- How would you have done things to have the best HA/automated architecture?
    - Share with us any ideas you have in mind to improve this kind of infrastructure.
        
        if the final goal to use `Wordpress` as static site, I prefer to convert the `wordpress` to static website using plugin or script, then upload it to `S3`
        
        If the WordPress will be used as main website or all the operations, I will create auto scale group with two node behand  load balancer with `EFS` between nodes. and maybe if required creating `lambda function` with `event bridge` to to advance health-check and based on the result it will take action to guaranty the availability


Tomorrow we want to put this project into production. What would be your advice and choices to achieve that?
1. For the high avaliablty ECS will automatically recover unhealthy containers to ensure from desired number of containers.
2. monitoring: by using newrelic to monitor the app health and performance without complex configration, and for the logs cloudwatch.
3. Database should be Aroura Mysql DB.
4. Add EFS for shared media.


## instruction Terraform 
To apply the infrasture follow the below command

```
#Make sure to update variables.tf
cd Terrafrom
terraform init
terraform fmt . 
terraform validate
terraform plan
terraform apply --auto-approve

```

## instruction Packer

```
cd WP
packer init .
packer build .
#Make to to update var -> variables.pkr.hcl

```