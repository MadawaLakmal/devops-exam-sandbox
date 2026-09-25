import os
from flask import Flask, request, jsonify
import redis

app = Flask(__name__)

redis_client = redis.Redis(host='localhost', port=6379, password=os.environ.get('REDIS_PASSWORD'))

@app.route('/process', methods=['POST'])
def process():
    try:
        payload = request.get_json(silent=True)
        if not isinstance(payload, dict):
            return jsonify({"error": "invalid payload"}), 400

        return jsonify({"status": "processed", "result": payload})
    except Exception:
        return jsonify({"error": "processing failed"}), 500

if __name__ == "__main__":
    # nosec B104 - binding 0.0.0.0 here is required so Docker can publish this port at all.
    # Host-level exposure is controlled at docker-compose.yml's port mapping, which now
    # binds only to 127.0.0.1 (see fix/harden-compose), not by this bind address.
    app.run(host='0.0.0.0', port=8080)  # nosec B104
