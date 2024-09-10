from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/status')
def status():
    # Get the status from your Python script
    status_results = check_services_and_servers()  # Add your script logic here
    return jsonify(status_results)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
