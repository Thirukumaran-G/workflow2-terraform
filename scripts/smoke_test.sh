#!/bin/bash
set -e

SERVICE_URL=$1
MAX_RETRIES=10
RETRY_INTERVAL=15
PASS=0
FAIL=0

check() {
  local endpoint=$1
  local expected=$2
  local desc=$3

  actual=$(curl -sf -o /dev/null -w "%{http_code}" \
    --max-time 10 "$SERVICE_URL$endpoint" || echo "000")

  if [ "$actual" = "$expected" ]; then
    echo "PASS ✓ $desc → $actual"
    PASS=$((PASS + 1))
  else
    echo "FAIL ✗ $desc → expected $expected got $actual"
    FAIL=$((FAIL + 1))
  fi
}

# wait for service
echo "Waiting for service..."
for i in $(seq 1 $MAX_RETRIES); do
  status=$(curl -sf -o /dev/null -w "%{http_code}" \
    --max-time 10 "$SERVICE_URL/health" || echo "000")
  [ "$status" = "200" ] && break
  [ "$i" = "$MAX_RETRIES" ] && echo "Service not ready" && exit 1
  echo "Attempt $i/$MAX_RETRIES — waiting ${RETRY_INTERVAL}s..."
  sleep $RETRY_INTERVAL
done

# run tests
echo "Running smoke tests against $SERVICE_URL"
check "/"          "200" "Root"
check "/health"    "200" "Health"
check "/items"     "200" "Get all items"
check "/items/1"   "200" "Get item by ID"
check "/items/999" "404" "Non-existent item"
check "/docs"      "200" "Swagger docs"

echo "Results: $PASS passed $FAIL failed"
[ "$FAIL" -gt 0 ] && echo "SMOKE TESTS FAILED" && exit 1
echo "ALL SMOKE TESTS PASSED"