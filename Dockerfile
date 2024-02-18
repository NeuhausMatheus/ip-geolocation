FROM  --platform=linux/amd64  python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN apt update && apt install curl -y && pip install -r requirements.txt

COPY . .

CMD [ "python", "/app/app.py" ]
