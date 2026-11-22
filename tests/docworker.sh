#!/bin/sh
# Smoke tests for the docworker image

. /tests/lib.sh

test_python
test_user
test_docworker
check "/pandoc belongs to user" sh -c '[ "$(stat -c %U /pandoc)" = user ]'

finish
