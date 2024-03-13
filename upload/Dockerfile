FROM python:3.8-slim-buster
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

EXPOSE 5000
RUN pip install .

ENTRYPOINT ["python ./app.py"]