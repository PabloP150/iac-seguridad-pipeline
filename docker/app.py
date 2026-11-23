"""API mínima de tareas. Solo existe para que el Dockerfile tenga algo que empaquetar."""

from flask import Flask, jsonify

app = Flask(__name__)

TAREAS = [
    {"id": 1, "titulo": "Configurar el pipeline de IaC", "hecha": True},
    {"id": 2, "titulo": "Corregir hallazgos de Checkov", "hecha": False},
]


@app.get("/salud")
def salud():
    return jsonify(estado="ok")


@app.get("/tareas")
def tareas():
    return jsonify(TAREAS)
