import os
import requests
from flask import Flask

app = Flask(__name__)

PAYMENTS_URL = os.environ["PAYMENTS_URL"]

@app.route("/")
def home():
    return "<h1>Banking Service</h1>", 200
