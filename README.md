# Seguridad IaC en el pipeline

Tarea del curso de Ciberseguridad (PDSS), Universidad Galileo. Pablo Pineda, carnet 21010478.

El repo tiene la infraestructura de una API de tareas pequeña (Flask + PostgreSQL en AWS)
escrita como código, y un pipeline de GitHub Actions que la escanea en cada PR. Si un cambio
mete una configuración insegura, el job falla y la protección de `main` no deja fusionar.

Nada de esto se despliega. No hay cuenta de AWS de por medio, solo se analiza el código.

## Qué hay en cada carpeta

| Carpeta | Qué tiene | Con qué se escanea |
|---|---|---|
| `infra/` | Terraform: grupos de seguridad, EC2, IAM, RDS | Checkov |
| `ansible/` | Playbook que configura el servidor web + `inventory.ini` | Checkov y ansible-lint (perfil production) |
| `docker/` | Dockerfile de la API | Checkov |
| `politicas/` | Política propia de Checkov (`CKV2_GAL_1`) y sus casos de prueba | Se carga con `--external-checks-dir` |
| `.github/workflows/iac-security.yml` | El pipeline | |
| `scripts/verificar_excepciones.sh` | Revisa que la excepción tenga aprobación y no esté vencida | Corre en el pipeline |
| `docs/` | `informe.pdf`, las capturas (`capturas/`) y las salidas de los escaneos locales antes y después (`evidencia/`) | |

## Correrlo en local

```bash
python3.13 -m venv .venv && source .venv/bin/activate
pip install checkov==3.4.5 ansible-core==2.22.0 ansible-lint==26.11.0

checkov -d . --compact
ansible-lint --profile production ansible/
```

## PR de la tarea

- [#2](https://github.com/PabloP150/iac-seguridad-pipeline/pull/2): remediación, fusionado con el job en verde.
- [#3](https://github.com/PabloP150/iac-seguridad-pipeline/pull/3): SSH abierto a propósito, bloqueado por el gate y cerrado sin fusionar.
- [Issue #1](https://github.com/PabloP150/iac-seguridad-pipeline/issues/1): aprobación de la única excepción (vence el 2027-05-31).
