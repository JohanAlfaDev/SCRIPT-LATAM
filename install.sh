#!/bin/bash
set -Eeuo pipefail

PRODUCT="SCRIPT LATAM"
VERSION="V2.5"
AUTHOR="Dev JOHAN ALFA PRO"

DISCOVERY_BASE="https://raw.githubusercontent.com/JohanAlfaDev/SCRIPT-LATAM/main"

PUBLIC_KEY_DER_B64="MCowBQYDK2VwAyEAeGkRYXn5cajdawhjpkzF+GmuLThzD6vit+huADywpLc="

TMP="$(mktemp -d /tmp/script-latam-bootstrap.XXXXXX)"

cleanup() {
    rm -rf "$TMP"
}

trap cleanup EXIT

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

clear 2>/dev/null || true
RED='\033[1;31m'
WHITE='\033[1;37m'
NC='\033[0m'

printf "${RED}╔══════════════════════════════════════════════════════════╗${NC}\n"
printf "${RED}║${NC}                                                          ${RED}║${NC}\n"
printf "${RED}║${NC}                       ${WHITE}SCRIPT LATAM${NC}                       ${RED}║${NC}\n"
printf "${RED}║${NC}                          ${WHITE}V2.5${NC}                            ${RED}║${NC}\n"
printf "${RED}║${NC}                                                          ${RED}║${NC}\n"
printf "${RED}║${NC}                    ${WHITE}Dev JOHAN ALFA PRO${NC}                    ${RED}║${NC}\n"
printf "${RED}║${NC}                                                          ${RED}║${NC}\n"
printf "${RED}╚══════════════════════════════════════════════════════════╝${NC}\n"
sleep 4

command -v curl >/dev/null 2>&1 ||
    fail "curl no esta instalado"

command -v openssl >/dev/null 2>&1 ||
    fail "openssl no esta instalado"

command -v python3 >/dev/null 2>&1 ||
    fail "python3 no esta instalado"

curl -fsSL     --connect-timeout 10     --max-time 30     "${DISCOVERY_BASE}/backend.json"     -o "$TMP/backend.json" ||
    fail "no se pudo obtener backend.json"

curl -fsSL     --connect-timeout 10     --max-time 30     "${DISCOVERY_BASE}/backend.sig"     -o "$TMP/backend.sig" ||
    fail "no se pudo obtener backend.sig"

printf '%s' "$PUBLIC_KEY_DER_B64" |
    base64 -d > "$TMP/public.der" ||
    fail "public key invalida"

openssl pkey     -pubin     -inform DER     -in "$TMP/public.der"     -out "$TMP/public.pem"     >/dev/null 2>&1 ||
    fail "public key no aceptada"

openssl pkeyutl     -verify     -pubin     -inkey "$TMP/public.pem"     -rawin     -in "$TMP/backend.json"     -sigfile "$TMP/backend.sig"     >/dev/null 2>&1 ||
    fail "firma del backend invalida"

BACKEND="$(
    python3 - "$TMP/backend.json" <<'PY'
import json
import re
import sys

with open(sys.argv[1], "r", encoding="utf-8") as f:
    d = json.load(f)

if d.get("schema") != 1:
    raise SystemExit(1)

if d.get("product") != "SCRIPT LATAM":
    raise SystemExit(1)

if d.get("channel") != "stable":
    raise SystemExit(1)

backend = d.get("backend")

if not isinstance(backend, str):
    raise SystemExit(1)

if not re.fullmatch(
    r"https://(?:[A-Za-z0-9.-]+|[0-9]{1,3}(?:\.[0-9]{1,3}){3})(?::[0-9]{1,5})?",
    backend
):
    raise SystemExit(1)

print(backend)
PY
)" || fail "backend.json rechazado"

[[ -n "$BACKEND" ]] ||
    fail "backend vacio"


curl -4 -fsSL     --connect-timeout 10     --max-time 30     "${BACKEND}/install.sh"     -o "$TMP/installer.sh" ||
    fail "no se pudo obtener el instalador"

[[ -s "$TMP/installer.sh" ]] ||
    fail "instalador vacio"

SIZE="$(wc -c < "$TMP/installer.sh")"

[[ "$SIZE" -ge 3000 ]] ||
    fail "respuesta de instalacion invalida"

bash -n "$TMP/installer.sh" ||
    fail "instalador recibido tiene sintaxis invalida"

chmod 700 "$TMP/installer.sh"


clear 2>/dev/null || true
exec /bin/bash "$TMP/installer.sh" "$@"
