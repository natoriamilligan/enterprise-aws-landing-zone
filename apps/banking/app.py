import os
import requests
from flask import Flask

app = Flask(__name__)

PAYMENTS_URL = os.environ["PAYMENTS_URL"]

@app.route("/")
def home():
    response = requests.get(PAYMENTS_URL, timeout=5)

    return f"""
    <h1>Banking Service</h1>
    <p>{response.text}</p>
    """
