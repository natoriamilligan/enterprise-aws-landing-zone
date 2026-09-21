from flask import Flask

app = Flask(__name__)

@app.route("/")
def health():
    return "<h1>Payments VPC reached!</h1>"
