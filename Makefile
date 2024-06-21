main:
	export AWS_TFM_REMOTE_BUCKET_NAME = "s3-upload-tfm-{$RANDOM}"
	
	# Terraform resources
	aws s3 create-bucket --bucket {$AWS_TFM_REMOTE_BUCKET_NAME} --region eu-west-2
	aws dynamodb create-table --table-name dev-s3-upload-tfm-lock --region eu-west-2 \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

	docker build s3-upload ./upload



	cd ./tfm/dev
	
	terraform plan

	terraform apply