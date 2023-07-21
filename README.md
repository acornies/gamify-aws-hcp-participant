# gamify-aws-hcp-participant
The participant repository for gamify challenges.

## Setup Codespace

```shell
./setup/tool-setup.sh
```

## AWS Account Access

TBD

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

You're now ready to complete the challenges.