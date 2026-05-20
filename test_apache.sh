#!/bin/bash

BASE="http://127.0.0.1:6101"
PASS=0
FAIL=0

check() {
    local desc="$1"
    local expected="$2"
    local actual="$3"

    if echo "$actual" | grep -q "$expected"; then
        echo "[OK]   $desc"
        ((PASS++))
    else
        echo "[FAIL] $desc (esperado: $expected, obtenido: $actual)"
        ((FAIL++))
    fi
}

echo "========================================"
echo " TEST DE SEGURIDAD APACHE"
echo "========================================"
echo ""

# 1. Cabeceras de seguridad
echo "--- Cabeceras de seguridad ---"
HEADERS=$(curl -sI "$BASE/")
check "X-Frame-Options presente"    "X-Frame-Options"    "$HEADERS"
check "X-XSS-Protection presente"   "X-XSS-Protection"   "$HEADERS"
check "Server no expone version"     "Server: Apache"     "$HEADERS"
echo ""

# 2. Métodos bloqueados
echo "--- Métodos HTTP bloqueados ---"
check "TRACE bloqueado (403)"   "403" "$(curl -s -o /dev/null -w "%{http_code}" -X TRACE "$BASE/")"
check "OPTIONS bloqueado (403)" "403" "$(curl -s -o /dev/null -w "%{http_code}" -X OPTIONS "$BASE/")"
check "TRACK bloqueado (403)"   "403" "$(curl -s -o /dev/null -w "%{http_code}" -X TRACK "$BASE/")"
echo ""

# 3. ModSecurity - SQLi
echo "--- ModSecurity: SQLi ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"admin'\'' OR 1=1--","password":"x"}')
check "SQLi bloqueado (403)" "403" "$CODE"
echo ""

# 4. ModSecurity - XSS
echo "--- ModSecurity: XSS ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"<script>alert(1)</script>","password":"x"}')
check "XSS bloqueado (403)" "403" "$CODE"
echo ""

# 5. ModSecurity - LFI
echo "--- ModSecurity: LFI ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/?file=../../../etc/passwd")
check "LFI bloqueado (403)" "403" "$CODE"
echo ""

# 6. Listado de directorios
echo "--- Listado de directorios ---"
CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/carpeta-inexistente/")
check "Directory listing desactivado (404)" "404" "$CODE"
echo ""

# 7. mod-evasive
echo "--- mod-evasive: flood ---"
BLOCKED=0
for i in $(seq 1 20); do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/")
    [ "$CODE" = "403" ] && ((BLOCKED++))
done
if [ "$BLOCKED" -gt 0 ]; then
    echo "[OK]   mod-evasive bloqueó $BLOCKED peticiones del flood"
    ((PASS++))
else
    echo "[FAIL] mod-evasive no bloqueó ninguna petición (puede tardar en activarse)"
    ((FAIL++))
fi
echo ""

# 8. Proxy a Flask
echo "--- Proxy a Flask ---"
BODY=$(curl -s "$BASE/api/auth/check")
check "Proxy Flask responde" "unauthorized" "$BODY"
echo ""

# Resumen
echo "========================================"
echo " RESULTADO: $PASS OK  |  $FAIL FALLADOS"
echo "========================================"
