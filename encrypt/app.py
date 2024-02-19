import os
from flask import Flask

app = Flask(__name__)

challenge_string = os.environ.get('ACME_CHALLENGE_STRING')

@app.route('/')
def acme_challenge():
    return challenge_string or 'Challenge string not found in environment variable.', 200

@app.errorhandler(404)
def page_not_found(error):
    return challenge_string or 'Challenge string not found in environment variable.', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
