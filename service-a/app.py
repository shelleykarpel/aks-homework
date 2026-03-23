import requests
import time
import logging
from statistics import mean
from http.server import BaseHTTPRequestHandler, HTTPServer
import threading

# Setting up logs
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

prices = []

def fetch_bitcoin_price():
    url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
    while True:
        try:
            response = requests.get(url, timeout=10)
            data = response.json()
            price = data['bitcoin']['usd']
            prices.append(price)
            logging.info(f"Current Bitcoin Price: ${price}")

            # Every 10 minutes (when there are 10 samples), an average is calculated
            if len(prices) % 10 == 0 and len(prices) > 0:
                avg_price = mean(prices[-10:])
                logging.info(f"--- AVERAGE (Last 10 minutes): ${avg_price:.2f} ---")
            
            # Clear the list occasionally to avoid consuming too much memory.
            if len(prices) > 100:
                prices.pop(0)

        except Exception as e:
            logging.error(f"Error fetching price: {e}")
        
        time.sleep(60)

# Health Check Server for Kubernetes
class HealthCheckHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"OK")

def run_health_server():
    server = HTTPServer(('0.0.0.0', 8080), HealthCheckHandler)
    server.serve_forever()

if __name__ == "__main__":
    # Running the health server in a separate thread
    threading.Thread(target=run_health_server, daemon=True).start()
    logging.info("Service A started. Health check on port 8080.")
    fetch_bitcoin_price()