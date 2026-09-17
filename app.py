from flask import Flask, jsonify, Response
from Main import VillageState, get_uptime_and_build_village, village_from_uptime
from dataclasses import dataclass, asdict
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
import requests

app = Flask(__name__)

request_counter = Counter("app_request_total", "Total Requests Recieved")

@app.route("/test-prometheus")
def testprometheus():
    response = requests.get("http://prometheus:9090/api/v1/query", params={"query": "up"})
    data = response.json()
    return str(data)

@app.route("/village-state/<int:uptime>")
def village(uptime):
    request_counter.inc()
    return(asdict(village_from_uptime(uptime)))

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0")