import requests
import logging
import os
import mimetypes
from flask import Flask
from flask import jsonify
from flask import send_from_directory
from waitress import serve

go_app_address = os.environ.get('GO_APP_ADDRESS')
tmp_folder_path = os.environ.get('MYAPP_TMP_FOLDER')

logger = logging.getLogger('waitress')
logger.setLevel(logging.DEBUG)

app = Flask(__name__)

@app.route('/')
def welcome():
	return "Welcome"

@app.route("/health")
def health():
    response = jsonify("Health OK")
    response.status_code = 200
    
    return response

@app.route("/<int:value>")
def get_files(value):
    url = 'http://%s/' % go_app_address
    response = requests.get(url)

    if response.status_code == 200:
        extension = mimetypes.guess_extension(response.headers['Content-Type'])
        filename = 'serveMe'
        full_filename = '%s/%s%s' % (tmp_folder_path, filename, extension)
        os.makedirs(os.path.dirname(full_filename), exist_ok=True)
        with open(full_filename, 'wb') as file:
            file.write(response.content)
            app.logger.info("File downloaded successfully!")
    else:
        app.logger.info("Failed to download the file.")
    
    response.headers['Content-Type'] = response.headers['Content-Type']
    return send_from_directory(tmp_folder_path,filename+extension)

if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=8080)