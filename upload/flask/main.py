import flask
import logging






def post_to_s3_bucket(object_name):

    import boto3

    def get_presigned_url(bucket_name, object_name, fields = None, expiry = 3600, conditions = None):

        s3_client = boto3.client('s3')

        try:
            response = s3_client.generate_presigned_post(bucket_name,
                                                     object_name,
                                                     Fields = fields,
                                                     Conditions = conditions,
                                                     ExpiresIn = expiry)
        except ClientError as e:
            logging.error(e)
            return None
        return response


    ssm_client = boto.client('ssm')
    try:
        bucket_name = ssm_client.get_parameter("upload_bucket_name")
    except ClientError as e:
        logging.error(e)
        return None

    presigned_url = get_presigned_url(bucket_name, object_name)

    import requests

    with open(object_name, 'rb') as f:
        files = {'file': (object_name, f)}
        http_response = requests.post(presigned_url['url'], data=result['fields'], files=files)
    logging.info(f'File upload HTTP status code: {http_response.status_code}')