package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureExample(t *testing.T) {
	t.Parallel()

	requiredEnvVars := []string{
        "ARM_SUBSCRIPTION_ID",
        "ARM_TENANT_ID",
		"ARM_CLIENT_ID",
    }

    for _, envVar := range requiredEnvVars {
        if os.Getenv(envVar) == "" {
            t.Fatalf("Required environment variable %s is not set", envVar)
        }
    }

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/complete",
		Reconfigure: true,
		BackendConfig: map[string]interface{}{
			"resource_group_name": "tfstate",
			"storage_account_name": "tfstatea2x4g",
			"container_name":"tfstate",
			"key":"module-template/template.tfstate",
		},
	}


	// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	database_name := terraform.Output(t, terraformOptions, "database_name")
	mssql_server_name := terraform.Output(t, terraformOptions, "mssql_server_name")
	mssql_server_fqdn := terraform.Output(t, terraformOptions, "mssql_server_fqdn")
	assert.Contains(t, database_name, "test-sqldb-module")
	assert.Contains(t, mssql_server_name, "test-sql-module")
	assert.Contains(t, mssql_server_fqdn, "test-sql-module.database.windows.net")
}
