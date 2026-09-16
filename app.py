from flask import Flask, jsonify
from Main import VillageState, get_uptime_and_build_village, village_from_uptime
from dataclasses import dataclass, asdict



app = Flask(__name__)

@app.route("/village-state/<int:uptime>")
def village(uptime):
    return(asdict(village_from_uptime(uptime)))

if __name__ == "__main__":
    app.run(debug=True)