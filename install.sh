#!/bin/bash
set -Eeuo pipefail

LATAM_INSTALLER_URL="https://187.127.53.57/install.sh"
TMP="$(mktemp /tmp/script-latam-installer.XXXXXX)"

cleanup() {
    rm -f "$TMP"
}
trap cleanup EXIT

echo "SCRIPT LATAM V2.5"
echo "Cargando instalador seguro..."

curl -4 -fsSL \
    --connect-timeout 10 \
    --max-time 30 \
    "$LATAM_INSTALLER_URL" \
    -o "$TMP"

[[ -s "$TMP" ]] || {
    echo "ERROR: instalador vacio"
    exit 1
}

SIZE="$(wc -c < "$TMP")"

[[ "$SIZE" -ge 3000 ]] || {
    echo "ERROR: respuesta de instalacion invalida"
    exit 1
}

bash -n "$TMP" || {
    echo "ERROR: instalador recibido tiene sintaxis invalida"
    exit 1
}

chmod 700 "$TMP"

exec /bin/bash "$TMP" "$@"
