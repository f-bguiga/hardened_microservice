from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return {"message": "Secure Pipeline Active", "status": "Healthy"}

if __name__ == "__main__":
    # We use 8080 because ports under 1024 require root privileges
    app.run(host='0.0.0.0', port=8080)
