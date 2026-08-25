# docker-my-tools

[![CI](https://github.com/diogopms/docker-my-tools/actions/workflows/ci.yml/badge.svg)](https://github.com/diogopms/docker-my-tools/actions/workflows/ci.yml)
[![Release](https://github.com/diogopms/docker-my-tools/actions/workflows/release.yml/badge.svg)](https://github.com/diogopms/docker-my-tools/actions/workflows/release.yml)

A debug toolbox image for Kubernetes clusters, based on Ubuntu LTS (24.04).
Spin it up as a throwaway pod to troubleshoot networking, databases, Kafka,
and the cluster itself without installing anything on the nodes.

## Variants

| Variant | Tags | Contents |
| --- | --- | --- |
| **base** | `latest`, `X.Y.Z`, `X.Y`, `X` | Slim debug toolbox (tools below) |
| **ai** | `latest-ai`, `X.Y.Z-ai`, `X.Y-ai`, `X-ai` | base + Node.js + Claude Code, Codex, and opencode CLIs |

## Included tools

| Tool | Purpose | Variant |
| --- | --- | --- |
| `kubectl` | Kubernetes CLI | base |
| `helm` | Kubernetes package manager | base |
| `stern` | Multi-pod log tailing | base |
| `psql` (postgresql-client) | PostgreSQL client | base |
| `redis-cli` (redis-tools) | Redis client | base |
| `kcat` (alias `kafkacat`) | Kafka producer/consumer | base |
| `tmux` | Terminal multiplexer | base |
| `curl`, `ping`, `telnet`, `dig`/`nslookup` | Network debugging | base |
| `htop` | Process viewer | base |
| `node` / `npm` | Node.js runtime | ai |
| `claude` | Claude Code CLI | ai |
| `codex` | OpenAI Codex CLI | ai |
| `opencode` | opencode CLI | ai |

## Image

Published to the GitHub Container Registry, for `linux/amd64` and `linux/arm64`:

```
ghcr.io/diogopms/docker-my-tools          # base
ghcr.io/diogopms/docker-my-tools:latest-ai # ai variant
```

## Usage

### One-off interactive shell in a cluster

The pod is created, attached to your terminal, and deleted when you exit:

```sh
kubectl run internal-tools --rm --restart=Never -i --tty \
  --image ghcr.io/diogopms/docker-my-tools:latest -- bash
```

### Long-running pod (keeps running, exec in when needed)

Deploy it once and keep it available for troubleshooting. The included
[`deployment.yaml`](deployment.yaml) runs `sleep infinity` so the container
stays alive and gets rescheduled/restarted automatically if the node or pod
dies:

```sh
kubectl apply -f deployment.yaml
kubectl exec -it deploy/diogopms-my-tools -- bash
```

Since `tmux` is included, you can also keep sessions alive inside the pod
across disconnects:

```sh
kubectl exec -it deploy/diogopms-my-tools -- tmux new -A -s debug
```

Deploy to a specific namespace and clean up when done:

```sh
kubectl apply -f deployment.yaml -n ops
kubectl exec -it deploy/diogopms-my-tools -n ops -- bash
kubectl delete -f deployment.yaml -n ops
```

### Single pod (no Deployment controller)

[`pod.yaml`](pod.yaml) starts one interactive pod (not restarted if it dies):

```sh
kubectl create -f pod.yaml
kubectl exec -it diogopms-my-tools -- bash
```

### Run locally

```sh
docker run --rm -it ghcr.io/diogopms/docker-my-tools:latest
```

## Building locally

```sh
docker build --target base -t docker-my-tools .
docker build --target ai -t docker-my-tools:ai .
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
