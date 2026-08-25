# docker-my-tools

[![CI](https://github.com/diogopms/docker-my-tools/actions/workflows/ci.yml/badge.svg)](https://github.com/diogopms/docker-my-tools/actions/workflows/ci.yml)
[![Release](https://github.com/diogopms/docker-my-tools/actions/workflows/release.yml/badge.svg)](https://github.com/diogopms/docker-my-tools/actions/workflows/release.yml)

A small Debian-based debug toolbox image for Kubernetes clusters. Spin it up as
a throwaway pod to troubleshoot networking, databases, Kafka, and the cluster
itself without installing anything on the nodes.

## Included tools

| Tool | Purpose |
| --- | --- |
| `kubectl` | Kubernetes CLI |
| `helm` | Kubernetes package manager |
| `stern` | Multi-pod log tailing |
| `psql` (postgresql-client) | PostgreSQL client |
| `redis-cli` (redis-tools) | Redis client |
| `kcat` (alias `kafkacat`) | Kafka producer/consumer |
| `node` / `npm` | Node.js runtime |
| `curl`, `ping`, `telnet`, `dig`/`nslookup` | Network debugging |
| `htop` | Process viewer |

## Image

Published to the GitHub Container Registry, for `linux/amd64` and `linux/arm64`:

```
ghcr.io/diogopms/docker-my-tools
```

Tags: `latest`, plus a semver cascade per release (`X.Y.Z`, `X.Y`, `X`).

## Usage

Run an interactive debug shell in a cluster:

```sh
kubectl run internal-tools --restart=Never -i --tty \
  --image ghcr.io/diogopms/docker-my-tools:latest -- bash
```

Or use the provided manifests:

```sh
kubectl create -f pod.yaml
kubectl exec -it diogopms-my-tools -- bash
```

Run locally:

```sh
docker run --rm -it ghcr.io/diogopms/docker-my-tools:latest
```

## Building locally

```sh
docker build -t docker-my-tools .
```

Tool versions are pinned via build args (`KUBECTL_VERSION`, `HELM_VERSION`,
`STERN_VERSION`) and can be overridden with `--build-arg`.

## CI & releases

- **CI** (`.github/workflows/ci.yml`): every pull request and push to `main`
  lints the Dockerfile (hadolint), builds the image, and smoke-tests the
  bundled tools. Merging to `main` never publishes an image.
- **Release** (`.github/workflows/release.yml`): runs monthly (or manually via
  *Actions → Release → Run workflow*). The next version is derived from
  [Conventional Commits](https://www.conventionalcommits.org/) since the last
  tag (`feat!:`/`BREAKING CHANGE` → major, `feat:` → minor, `fix:` → patch;
  anything else skips the release). A release creates the git tag, pushes the
  multi-arch image to ghcr.io, and publishes a GitHub Release with a changelog.

## License

[MIT](LICENSE)
