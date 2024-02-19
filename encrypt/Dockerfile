FROM --platform=linux/amd64 python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && apt update && apt install curl -y

COPY . .

CMD ["python", "app.py"]