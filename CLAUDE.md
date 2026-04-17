# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

GoStatic is a Docker-based GitHub Action that deploys static sites to the GoStatic cloud service (`https://www.gostaticapp.com`).

## How It Works

1. `action.yml` defines two inputs (`api-token`, `source-dir`) and two outputs (`url`, `deployment_id`)
2. The Docker container runs `entrypoint.sh`, which:
   - Warns if `index.html` is missing from the source directory
   - Creates a gzipped tar of the source directory
   - POSTs it to `https://www.gostaticapp.com/api/deploy/artifact` with Bearer token auth
   - Parses the JSON response with `jq` and sets GitHub Action outputs

## Local Development

```bash
# Build the Docker image locally
docker build -t gostatic:latest .

# Run the entrypoint directly (requires a real API token)
./entrypoint.sh "./example_output_directory" "YOUR_API_TOKEN"
```

There is no automated test suite. Manual testing requires a real GoStatic API token.

## Key Files

- [`entrypoint.sh`](entrypoint.sh) — core logic: tar, POST, parse response
- [`action.yml`](action.yml) — action interface (inputs/outputs/branding)
- [`Dockerfile`](Dockerfile) — Alpine 3.23 with `curl` and `jq`
- [`.github/workflows/example.yml`](.github/workflows/example.yml) — reference workflow showing how to use the action and post deployment URLs as PR comments
- [`example_output_directory/`](example_output_directory/) — sample static site for testing
