from flask import Flask, request
import os
import psycopg2
from datetime import datetime

app = Flask(__name__)

# Retrieve environment variables for database connection
db_host = os.getenv("DB_HOST")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_name = os.getenv("DB_NAME")

# Connect to PostgreSQL database
conn = psycopg2.connect(
    host=db_host,
    user=db_user,
    password=db_password,
    database=db_name
)
cur = conn.cursor()

# Function to reverse IP address
def reverse_ip(ip):
    return '.'.join(reversed(ip.split('.')))

# Create table if not exists
cur.execute("""
    CREATE TABLE IF NOT EXISTS ipgeolocation (
        id SERIAL PRIMARY KEY,
        ip VARCHAR(45) NOT NULL,
        timestamp TIMESTAMP NOT NULL
    )
""")
conn.commit()

# Route to handle incoming requests
@app.route('/')
def index():
    try:
        ip_address = request.headers.get('X-Forwarded-For')
        if ip_address is None:
            ip_address = request.remote_addr
        else:
            # If there are multiple IPs, get the first one (client IP)
            ip_address = ip_address.split(',')[0].strip()
        reversed_ip = reverse_ip(ip_address)
        print("Reversed IP:", reversed_ip)

        # Get current timestamp
        current_time = datetime.now()

        # Insert IP and timestamp into PostgreSQL database
        cur.execute("INSERT INTO ipgeolocation (ip, timestamp) VALUES (%s, %s)", (reversed_ip, current_time))
        conn.commit()

        return "Received IP: " + ip_address + ", Timestamp: " + str(current_time)
    except psycopg2.Error as e:
        # If an error occurs, rollback the transaction
        conn.rollback()
        print("Error executing SQL query:", e)
        return "Error executing SQL query"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
