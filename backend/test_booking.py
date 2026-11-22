import urllib.request
import json

# 1. جيب التوكن - حط الباسورد يلي انت حافظو هون
login_data = json.dumps({"username": "ali", "password": "313ali"}).encode('utf-8')
login_req = urllib.request.Request(
    "http://127.0.0.1:8000/api/token/",
    data=login_data,
    headers={"Content-Type": "application/json"}
)
with urllib.request.urlopen(login_req) as res:
    token = json.loads(res.read())["access"]
    print("Token OK!")

# 2. ابعت الحجز
booking_data = json.dumps({
    "service_id": 1,
    "customer_name": "Ahmed Test",
    "customer_phone": "3130000000",
    "note": "from API"
}).encode('utf-8')

booking_req = urllib.request.Request(
    "http://127.0.0.1:8000/api/booking",
    data=booking_data,
    headers={
        "Content-Type": "application/json",
        "Authorization": f"Bearer {token}"
    },
    method="POST"
)
with urllib.request.urlopen(booking_req) as res:
    print(res.read().decode('utf-8'))