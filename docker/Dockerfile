# Imagen de la API de tareas (versión inicial, insegura a propósito)
FROM python:latest

RUN apt-get update
RUN apt-get install -y openssh-server curl

WORKDIR app
ADD https://raw.githubusercontent.com/pallets/flask/main/README.md /app/LEEME.md
COPY . .

RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
RUN curl -k -sSL https://install.python-poetry.org | python3 -

ENV PYTHONHTTPSVERIFY=0

EXPOSE 22 8000
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
