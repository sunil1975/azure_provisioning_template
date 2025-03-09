package terratest

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"gotest.tools/v3/assert"
)

func TestParameterValidations(t *testing.T) {
	contentStr := os.Getenv("TF_VAR_content")

	assert.Equal(t, true, strings.Contains(contentStr, "Hello"))
	assert.Equal(t, true, len(contentStr) > 10)
}

func TestVMPlan(t *testing.T) {
	contentStr := os.Getenv("TF_VAR_content")
	planFilePath := filepath.Join("./", "plan.out")
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../../../../modules/azure/infrastructure/vm",
		Vars: map[string]interface{}{
			"content": contentStr,
		},
		PlanFilePath: planFilePath,
	})
	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)
	local_file_resource := plan.ResourcePlannedValuesMap["local_file.file"]
	content := local_file_resource.AttributeValues["content"]
	filename := local_file_resource.AttributeValues["filename"]

	assert.Equal(t, content, contentStr)
	assert.Equal(t, filename, "/tmp/hi.txt")
}
