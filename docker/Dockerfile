# Imagen de la API de tareas
# Versión fija y digest: si alguien cambia la imagen en Docker Hub, el build no la toma
FROM python:3.13.18-slim-bookworm@sha256:a5a7017efc5969e00ae2b91c8eb0631049a569652aa4ffc4501769049ae45c72

RUN apt-get update
RUN apt-get install -y openssh-server curl

WORKDIR app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 22 8000
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
