#!/bin/sh
#
# Shared helpers for image smoke tests (POSIX sh, runs inside the image)

FAILED=0

# check <description> <command...>
check() {
    desc="$1"
    shift
    if out="$("$@" 2>&1)"; then
        echo "ok   $desc"
    else
        echo "FAIL $desc"
        printf '%s\n' "$out" | sed 's/^/     /'
        FAILED=$((FAILED + 1))
    fi
}

finish() {
    if [ "$FAILED" -gt 0 ]; then
        echo "$FAILED check(s) failed"
        exit 1
    fi
    echo "All checks passed"
}

# Run a command as the non-root user if the image has one
as_user() {
    if id user >/dev/null 2>&1; then
        su user -s /bin/sh -c "$1"
    else
        sh -c "$1"
    fi
}

python_version_matches() {
    actual="$(python -c 'import platform; print(platform.python_version())')"
    case "$actual" in
        "$EXPECTED_PYTHON" | "$EXPECTED_PYTHON".*) ;;
        *) echo "expected $EXPECTED_PYTHON, got $actual"; return 1 ;;
    esac
}

test_python() {
    check "Python version is $EXPECTED_PYTHON" python_version_matches
    check "pip works" python -m pip --version
    check "TLS context loads CA bundle" python -c \
        "import ssl; assert ssl.create_default_context().cert_store_stats()['x509_ca'] > 0"
    check "ctypes and zoneinfo work" python -c \
        "import ctypes, zoneinfo; zoneinfo.ZoneInfo('Europe/Prague')"
    check "libpq and libffi are installed" sh -c \
        'ls /usr/lib*/libpq.so* && ls /usr/lib*/libffi.so*'
    check "pip cache is empty and writable" sh -c \
        '[ -z "$(ls -A "$PIP_CACHE_DIR")" ] && [ -w "$PIP_CACHE_DIR" ]'
}

test_user() {
    check "user is 10000:10001" sh -c \
        '[ "$(id -u user)" = 10000 ] && [ "$(id -g user)" = 10001 ]'
    check "user has no usable password" grep -q '^user:\*:' /etc/shadow
}

pandoc_version_matches() {
    actual="$(pandoc --version | head -n 1)"
    [ "$actual" = "pandoc $EXPECTED_PANDOC" ] || { echo "expected $EXPECTED_PANDOC, got $actual"; return 1; }
}

test_docworker() {
    check "Pandoc version is $EXPECTED_PANDOC" pandoc_version_matches
    check "Pandoc converts Markdown to HTML" sh -c \
        "printf '# Hello\n' | pandoc -f markdown -t html | grep -q '<h1 id=\"hello\">Hello</h1>'"
    check "Lua runs" lua -v
    check "Pandoc directories exist" sh -c '[ -d /pandoc/templates ] && [ -d /pandoc/filters/pandocker ]'
    check "MS core fonts installed" sh -c 'fc-list | grep -q Arial'
    check "Droid fonts installed" sh -c 'fc-list | grep -q "Droid Sans"'
    check "Noto Color Emoji installed" sh -c 'fc-list | grep -q "Noto Color Emoji"'
    check "WeasyPrint renders a PDF" as_user '
        set -e
        python -m venv /tmp/wp
        /tmp/wp/bin/pip install -q weasyprint
        printf "<h1>Hello 👋</h1><p style=\"font-family: Arial\">Smoke test</p>" > /tmp/t.html
        /tmp/wp/bin/weasyprint /tmp/t.html /tmp/t.pdf
        head -c 5 /tmp/t.pdf | grep -q "%PDF-"
        rm -rf /tmp/wp /tmp/t.html /tmp/t.pdf'
}
