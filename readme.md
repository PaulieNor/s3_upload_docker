A basic app which uploads images to an S3 bucket. This was mainly created to test out functionalities for another, more complex project.

Main goals were:

- Create a basic app which could use AWS services via IAM from within a kubernetes cluster, using Service Accounts.
- Use Github actions to automate CI/CD to multiple environments via PRs.
- Full IaC implementation of AWS resources, for immediate windup/teardown of environments.
