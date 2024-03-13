main:
	export AWS_TFM_REMOTE_BUCKET_NAME = "s3-upload-tfm-{$RANDOM}"

	aws s3 create-bucket --bucket {$AWS_TFM_REMOTE_BUCKET_NAME} --region eu-west-2
	aws dynamodb --table s3-upload-tfm-lock --region eu-west-2
	aws ssm put-parameter \
    --name "aws-tfm-bucket-name" \
    --value "{$AWS_TFM_REMOTE_BUCKET_NAME}" \
    --type String 

	docker build s3-upload ./upload