#!/usr/bin/env bash
# Revisa las excepciones (checkov:skip y # noqa) de las carpetas de IaC.
# Falla si una excepción no trae aprobación o fecha de vencimiento, si ya venció,
# o si hay más de las permitidas. Checkov no revisa fechas, por eso existe esto.
set -euo pipefail

MAXIMO=1
hoy=$(date -u +%F)
fallas=0
total=0

excepciones=$(grep -rnE 'checkov:skip=|# noqa' infra ansible docker || true)

while IFS= read -r linea; do
  [ -z "$linea" ] && continue
  total=$((total + 1))
  archivo=$(echo "$linea" | cut -d: -f1)
  num=$(echo "$linea" | cut -d: -f2)
  vence=$(echo "$linea" | grep -oE 'Vence: [0-9]{4}-[0-9]{2}-[0-9]{2}' | cut -d' ' -f2 || true)

  if ! echo "$linea" | grep -q 'Aprobó:'; then
    echo "::error file=$archivo,line=$num::Excepción sin referencia de aprobación (falta 'Aprobó:')"
    fallas=1
  fi

  if [ -z "$vence" ]; then
    echo "::error file=$archivo,line=$num::Excepción sin fecha de vencimiento (falta 'Vence: AAAA-MM-DD')"
    fallas=1
  elif [[ "$vence" < "$hoy" ]]; then
    echo "::error file=$archivo,line=$num::Excepción vencida el $vence; hay que revisarla o corregir el hallazgo"
    fallas=1
  else
    echo "OK, vigente hasta $vence -> $archivo:$num"
  fi
done <<< "$excepciones"

echo "Excepciones encontradas: $total (máximo permitido: $MAXIMO)"
if [ "$total" -gt "$MAXIMO" ]; then
  echo "::error::Hay $total excepciones y el máximo es $MAXIMO"
  fallas=1
fi

exit $fallas
