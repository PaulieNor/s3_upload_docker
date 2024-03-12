import flask
from flask import Flask, flash, request, redirect
import logging
from werkzeug.utils import secure_filename
import boto3
from botocore.exceptions import ClientError


ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1000 * 1000



def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def post_to_s3_bucket(file, object_name):

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


        ssm_client = boto3.client('ssm')

        try:
            bucket_name = ssm_client.get_parameter("upload-bucket-name")
            
        except ClientError as e:
            logging.error(e)
            return None

        presigned_url = get_presigned_url(bucket_name, object_name)

        import requests

        files = {'file': (object_name, file)}
        http_response = requests.post(presigned_url['url'], data=presigned_url['fields'], files=files)
        logging.info(f'File upload HTTP status code: {http_response.status_code}')
    


@app.route('/upload', methods = ["POST"])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('Empty file')
            return redirect(request.url)
        file = request.files['file']
        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            output = post_to_s3_bucket(file, filename)
            if output:
                flash("File uploaded")
                return redirect(request.url)
            
        else:
            flash("Incorrect file type (Only accepted file types: 'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif')")
            return redirect(request.url)



if __name__ == "__name__":

    Flask(app)