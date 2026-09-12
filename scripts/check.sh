#!/usr/bin/env bash
set -euo pipefail

url="${1:-http://127.0.0.1:8081}"

content=$(curl --fail --silent --show-error --max-time 10 "$url")

if grep -Fq "Haseeb DevOps Lab" <<< "$content"; then
  echo "PASS: Website responds with the expected content."
else
  echo "FAIL: Expected website content was not found."
  exit 1
fi
