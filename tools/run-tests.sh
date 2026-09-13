#!/bin/sh
# Run Dr. Pach's public test object against src/code.c the way the GitHub Actions workflow
# does: 32-bit x86 build on Ubuntu with gcc-multilib. The csci232-gcc image cannot link
# 32-bit x86 objects, so this uses an emulated amd64 Ubuntu container instead. Debugging
# under emulation does not work (no ptrace), but running the tests does.
#
#   tools/run-tests.sh          # downloads the current tests02.o, builds, runs
#
# Unity reports PASS or FAIL per challenge; it does not print the expected value.
set -eu
cd "$(dirname "$0")/.."
num=$(basename "$PWD" | sed -n 's/.*ass\([0-9][0-9]*\).*/\1/p')
[ -n "$num" ] || num=02
mkdir -p tests
curl -sSL -o tests/tests.o "https://raw.githubusercontent.com/jpach-cs/232-all-public-tests/main/tests${num}.o"
[ -s tests/tests.o ] || { echo "download of tests${num}.o failed" >&2; exit 1; }
exec docker run --rm --platform linux/amd64 -v "$PWD:/w" -w /w ubuntu:24.04 bash -c '
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq >/dev/null 2>&1
    apt-get install -y -qq gcc-multilib >/dev/null 2>&1
    gcc -Wall -m32 -Isrc src/code.c lib/unity.o tests/tests.o -o /tmp/run_tests 2>&1 | grep -v "unused variable" | grep -v "^ *|" | grep -v "^ *\^" | grep -v "In function" || true
    /tmp/run_tests'
