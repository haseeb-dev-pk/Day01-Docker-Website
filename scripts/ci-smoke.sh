#!/usr/bin/env bash
set -euo pipefail

image="${1:?Pass the image tag}"
expected="${EXPECTED_TEXT:-Haseeb DevOps Lab}"

mkdir -p artifacts
rm -f artifacts/response.html artifacts/check.txt artifacts/container.log
cid=''

cleanup() {
  rc=$?
  trap - EXIT
  if [ -n "$cid" ]; then
    docker logs "$cid" > artifacts/container.log 2>&1 || true
    docker rm -f "$cid" >/dev/null 2>&1 || true
  fi
  printf 'exit_code=%s\n' "$rc" >> artifacts/check.txt
  exit "$rc"
}

trap cleanup EXIT

cid=$(docker run -d -p 127.0.0.1::80 "$image")
port=$(docker port "$cid" 80/tcp | awk -F: 'NR==1 {print $NF}')
url="http://127.0.0.1:$port"

ready=false
for attempt in $(seq 1 15); do
  if curl -fsS --max-time 2 "$url" -o artifacts/response.html; then
    ready=true
    break
  fi
  sleep 1
done

if [ "$ready" != true ]; then
  echo 'FAIL: HTTP endpoint unavailable' | tee artifacts/check.txt
  exit 1
fi

if grep -Fq -- "$expected" artifacts/response.html; then
  echo 'PASS: Expected page content found' | tee artifacts/check.txt
else
  echo 'FAIL: Page content mismatch' | tee artifacts/check.txt
  exit 1
fi
