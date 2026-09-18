from dataclasses import dataclass
import requests

@dataclass
class VillageState:
    weather: str
    mood: str
    crop_health: int

my_village = VillageState(weather="sunny", mood="happy", crop_health=100)

def village_from_uptime(uptime_percent: float) -> VillageState:
    if uptime_percent >= 90:
        return VillageState(weather="sunny", crop_health=100, mood="happy")
    elif uptime_percent >= 70:
        return VillageState(weather="cloudy", crop_health=50, mood="neutral")
    else:
        return VillageState(weather="rainy", crop_health=0, mood="sad")

def get_uptime_and_build_village():
    response = requests.get("https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m")
    data = response.json()
    temp = data["current"]["temperature_2m"]
    return village_from_uptime(temp)

def get_metric_from_prometheus(query):
    response = requests.get("http://prometheus:9090/api/v1/query", params={"query": query})
    data = response.json()
    return float(data["data"]["result"][0]["value"][1])

village = get_uptime_and_build_village()
print(village) 