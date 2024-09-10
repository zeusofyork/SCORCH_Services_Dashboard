# app.py
from flask import Flask, jsonify, render_template
import status_checker  # Import the status checking module

app = Flask(__name__)

# Route to serve the dashboard
@app.route('/')
def index():
    return render_template('index.html')

# Route to fetch the status data (servers + services)
@app.route('/status')
def status():
    status_results = status_checker.get_status()  # Call the function to check statuses
    return jsonify(status_results)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)  # Make the server accessible on the local network
