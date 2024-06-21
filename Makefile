main:
	export AWS_TFM_REMOTE_BUCKET_NAME = "s3-upload-tfm-{$RANDOM}"
	export AWS_ACCOUNT_ID = {$aws sts get-caller-identity --query Account --output text}
	
	# Terraform resources
	aws s3 create-bucket --bucket {$AWS_TFM_REMOTE_BUCKET_NAME} --region eu-west-2
	aws dynamodb create-table --table-name dev-s3-upload-tfm-lock --region eu-west-2 \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

	docker build s3-upload ./upload



	cd ./tfm/dev
	
	terraform plan -var="upload_bucket_name=dev-s3-upload" -var="account_id={$AWS_ACCOUNT_ID}"

	terraform apply -var="upload_bucket_name=dev-s3-upload" -var="account_id={$AWS_ACCOUNT_ID}"

	cd ../../helm

	helm install s3 . --set awsAccountID={$AWS_ACCOUNT_ID}
