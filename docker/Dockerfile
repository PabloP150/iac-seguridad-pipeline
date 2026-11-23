# Imagen de la API de tareas
# Versión fija y digest: si alguien cambia la imagen en Docker Hub, el build no la toma
FROM python:3.13.18-slim-bookworm@sha256:a5a7017efc5969e00ae2b91c8eb0631049a569652aa4ffc4501769049ae45c72

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Usuario sin privilegios: si alguien compromete la app, no es root dentro del contenedor
RUN useradd --system --uid 10001 --no-create-home app
USER app

EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/salud', timeout=2)"]

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
