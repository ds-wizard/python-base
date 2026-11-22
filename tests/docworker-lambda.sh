#!/bin/sh
# Smoke tests for the docworker-lambda image

. /tests/lib.sh

test_python
test_docworker
check "Lambda runtime libraries import" python -c "import awslambdaric, boto3, s3transfer"
check "aws-lambda-rie is removed" sh -c '[ ! -e /usr/local/bin/aws-lambda-rie ]'

finish
