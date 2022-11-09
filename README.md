# CyberArk Exam
---

This repository holds Terraform configuration that will provision the following infrastructure:

1. VPC
2. 2 subnets - private and public
3. 2 EC2 instances with Nginx installed
4. Application Load Balancer to load-balance traffic between the instances.


## Usage

First, export the following variables:
```
$ export AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID>
$ export AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>
$ export AWS_REGION=<REGION>
```

Then, create a public SSH key for the instances
```
$ ssh-keygen -f aws
```

Now, run:
```
$ ./run_tf.sh apply -auto-approve
```

To destroy:
```
$ ./run_tf.sh destroy -auto-approve
```

## Test
The creation of the infrastrucutre will output the DNS name of the load balancer, copy it and run

```
$ curl <load-balancer-dns>
```


