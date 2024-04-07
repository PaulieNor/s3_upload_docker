import flask
from flask import Flask, flash, request, redirect, render_template, url_for
import logging
from werkzeug.utils import secure_filename
import boto3
from botocore.exceptions import ClientError
import os


ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1000 * 1000
app.config['SECRET_KEY'] = os.urandom(12).hex()



def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def post_to_s3_bucket(file, object_name):

        def get_presigned_url(bucket_name, object_name, fields = None, expiry = 3600, conditions = None):

            s3_client = boto3.client('s3')

            try:
                response = s3_client.generate_presigned_post(bucket_name,
                                                            object_name,
                                                            fields = fields
                                                            conditions = conditions
                                                            ExpiresIn = expiry)
                
                app.logger.info(f"Get presigned url response: {response}")
                
            except ClientError as e:
                app.logger.error(e)
                return None
            
            return response


        ssm_client = boto3.client('ssm')

        try:
            bucket_name = ssm_client.get_parameter(Name = "upload-bucket-name")['Parameter']['Name']
            
        except ClientError as e:
            logging.error(e)
            return None

        presigned_url = get_presigned_url(bucket_name, object_name)

        import requests

        files = {'file': (object_name, file)}



        http_response = requests.post(presigned_url['url'], data=presigned_url['fields'], files=files)
        message = f"File upload HTTP response: {http_response}"
        app.logger.info(message)
        return str(message)
    

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload_file', methods = ["POST", "GET"])
def upload_file():
    app.logger.info("Uploading file.")
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('Empty file')
            return 'Empty file'
        file = request.files['file']
        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            flash('No selected file')
            return 'No selected file'
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            output = post_to_s3_bucket(file, filename)
            if output:
                flash("File uploaded")
                return 'File uploaded'
            else:
                return 'Bad upload to S3.'
            
        else:
            app.logger.warning("Incorrect file type.")
            flash("Incorrect file type (Only accepted file types: 'png', 'jpg', 'jpeg', 'gif')")
            return 'No selected file'



if __name__ == "__main__":

    from logging.config import dictConfig

    dictConfig({
        'version': 1,
        'formatters': {'default': {
            'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
        }},
        'handlers': {'wsgi': {
            'class': 'logging.StreamHandler',
            'stream': 'ext://flask.logging.wsgi_errors_stream',
            'formatter': 'default'
        }},
        'root': {
            'level': 'INFO',
            'handlers': ['wsgi']
        }
    })


    #from waitress import serve

    #serve(app, host="127.0.0.1", port=8080)
    logging.info("Starting app.")
    app.run(host = '0.0.0.0', port = 8080)

