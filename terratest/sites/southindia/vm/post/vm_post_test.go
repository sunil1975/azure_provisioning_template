package terratest

import (
	"os"
	"testing"

	"gotest.tools/v3/assert"
)

func TestVMPostChecks(t *testing.T) {
	filename := "/tmp/hi.txt"
	_, error := os.Stat(filename)
	assert.Equal(t, false, os.IsNotExist(error))

	b, err := os.ReadFile(filename)
	assert.NilError(t, err)

	content := string(b)
	assert.Equal(t, content, "Hello from foo, Terragrunt!")
}
