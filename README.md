# gamify-aws-hcp-participant
The participant repository for gamify challenges.

## Setup Codespace

```shell
./setup/tool-setup.sh
```

## AWS Account Access

Refer to your facilitator's AWS Workshop Studio event link.

## HCP Vault Access

Setup the Vault CLI with your provided HCP Vault endpoint and namespace:
```
export VAULT_ADDR=<hcp-vault-endpoint-here>
export VAULT_NAMESPACE=admin/<your-namespace-here>
```

Login to your HCP Vault namespace using a [GitHub personal access token](https://github.com/settings/tokens):
```shell
vault login -method github
```

You should now be able to list your kv secrets using this command:
```shell
vault kv get -format=json kv/terraform
```

## Terraform Cloud Access

Next, connect to your codespace with a Terraform Cloud workspace. In order to authenticate with Terraform Cloud, you will need an API team token. Your facilitator has supplied this token in your respective HCP Vault namespace. Please verify that you have access to:

- A Terraform Cloud organization and project (UI)
- An HCP Vault namespace (UI)

Once ready, open the file `terraform.tf` and replace the organization and workspace name values accordingly.

Now that we have the remote backend defined, copy & paste the Terraform team token value and use it in the login prompt.

```shell
vault kv get -format=json kv/terraform | jq -r .data.data.team_token
```

Copy the above token and use it in the following prompt:
```shell
terraform login
```

Assuming you're successfully authenticated, initialize the repository with:

```shell
terraform init
```

## The Challenge

Build and deploy an AWS Lambda function that receives messages from a specified SQS queue. The function is built to use the Vault Lambda Extension to secure the Postgres database connection using a dynamic database credential. Once your function starts receiving and processing messages from the queue, your team will start to receive points for very message processed. The team with the highest amount of points wins the challenge. Additional points will be awarded for:

- Did you use Terraform deploy it?
- Did you use your Terraform Cloud workspace?
- Terraform coding style - Show your work!

## Suggested Steps

1. 📝 Launch a Github Codespace from this repository, run `./setup/tool-setup.sh`
   1. Hook up your Terraform code/workspace to Terraform Cloud (team token provided)
2. ☁️ Add AWS credentials to your Terraform Cloud workspace variables
3. 🐳 Build and tag the Docker container using the supplied Dockerfile
4. 📙 Create an ECR repository for the image in AWS
   1. Push the Docker container to the ECR repository
5. 🐘 Create a RDS Postgres database instance
   1. Think about a security group for the RDS instance
6. 🚀 Create a Lambda function with package type "image"
   1. Think about an IAM policy and role needed for the Vault integration
7. 📄 Configure the Lambda with the image url from the ECR repository
   1. Provide further config needed for the Vault Lambda Extension
8. 📬 Map the SQS event source to your Lambda
9.  🔒 Configure your Vault namespace for the Lambda to fetch a dynamic database credential
    1. The AWS auth method is needed
    2. An AWS auth role is also needed for the Lambda
    3. Think about a suitable Vault policy to assign to the role
    4. A database secrets engine of type Postgres is needed
    5. A database engine role is also needed to vend Postgres accounts
10. 🎉 Test your Lambda function!

Don't forget to commit and push your code the repository!

## Debugging

In order debug your function code, add the `AWSLambdaBasicExecutionRole` managed policy to your Lambda execution role to view AWS Cloud Watch logs.

## References to help

- [The AWS Terraform provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Introduction to the Vault AWS Lambda extension](https://developer.hashicorp.com/vault/tutorials/app-integration/intro-vault-aws-lambda-extension)
- [Learn Vault Lambda Extension Github](https://github.com/hashicorp-education/learn-vault-lambda-extension)