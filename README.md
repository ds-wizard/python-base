# python-base
Base Docker images for Python tools

## Images

| Tag                | Base                      | Contents                                              |
|--------------------|---------------------------|-------------------------------------------------------|
| `basic`            | `python:*-alpine`         | Python, libpq, libffi, OpenSSL, tzdata, `user` (10000) |
| `docworker`        | `python:*-alpine`         | `basic` + Pango/Cairo, fonts, Lua, Pandoc              |
| `docworker-lambda` | AWS Lambda `provided:al2023` | Python, document stack as `docworker`, Lambda runtime |

Published as `ghcr.io/ds-wizard/python-base:<tag>`.

## Tests

Each image has smoke tests in `tests/<tag>.sh`. CI runs them (amd64) before pushing. To run them locally:

```bash
./tests/run.sh docworker          # builds the image first
./tests/run.sh docworker my:image # tests an existing image
```

Expected Python and Pandoc versions are read from the Dockerfile.
