package testimpl

import (
	"context"
	"fmt"
	"reflect"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/firehose"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

var standardTags = map[string]string{
	"provisioner": "Terraform",
}

func TestFireHoseComplete(t *testing.T, ctx types.TestContext) {
	streamName := terraform.Output(t, ctx.TerratestTerraformOptions(), "name")
	fmt.Println(streamName)

	t.Run("TestARNAndIDPatternMatches", func(t *testing.T) {
		checkARNFormat(t, ctx)
	})

	t.Run("TestingValidTags", func(t *testing.T) {
		checkTagsMatch(t, ctx)
	})
}

func checkARNFormat(t *testing.T, ctx types.TestContext) {
	expectedPatternARN := "^arn:aws:firehose:[a-z0-9-]+:[0-9]{12}:[a-z0-9-]+/.+$"

	actualARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "arn")
	assert.NotEmpty(t, actualARN, "ARN is empty")
	assert.Regexp(t, expectedPatternARN, actualARN, "ARN does not match expected pattern")
}

func checkTagsMatch(t *testing.T, ctx types.TestContext) {
	expectedTags := terraform.OutputMap(t, ctx.TerratestTerraformOptions(), "tags_all")
	client := GetFireHoseClient(t)

	limit := int32(len(expectedTags))

	input := &firehose.ListTagsForDeliveryStreamInput{
		DeliveryStreamName:   aws.String(terraform.Output(t, ctx.TerratestTerraformOptions(), "name")),
		ExclusiveStartTagKey: aws.String("provicioner"),
		Limit:                aws.Int32(limit),
	}
	result, err := client.ListTagsForDeliveryStream(context.TODO(), input)
	assert.NoError(t, err, "Failed to retrieve tags from AWS")

	actualTags := map[string]string{}
	for _, tag := range result.Tags {
		actualTags[*tag.Key] = *tag.Value
	}

	for k, v := range standardTags {
		expectedTags[k] = v
	}

	assert.True(t, reflect.DeepEqual(actualTags, expectedTags), fmt.Sprintf("tags did not match, expected: %v\nactual: %v", expectedTags, actualTags))
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetFireHoseClient(t *testing.T) *firehose.Client {
	fireHoseClient := firehose.NewFromConfig(GetAWSConfig(t))
	return fireHoseClient
}
