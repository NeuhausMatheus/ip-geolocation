# Use official Python image
FROM  --platform=linux/amd64  python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install dependencies
RUN apt update && apt install curl -y && pip install -r requirements.txt

# Copy the content of the local src directory to the working directory
COPY . .

# Command to run on container start
CMD [ "python", "/app/app.py" ]
