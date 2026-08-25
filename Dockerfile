# Two build targets:
#   base — slim debug toolbox (network, DB, Kafka, and Kubernetes CLI tools)
#   ai   — base plus Node.js and the Claude Code / Codex / opencode CLIs
FROM ubuntu:24.04 AS base

LABEL org.opencontainers.image.source="https://github.com/diogopms/docker-my-tools" \
      org.opencontainers.image.description="In-cluster debug toolbox: network, database, Kafka, and Kubernetes CLI tools" \
      org.opencontainers.image.licenses="MIT"

# Set automatically by buildx from --platform (amd64 / arm64).
ARG TARGETARCH
ARG KUBECTL_VERSION=1.36.4
ARG HELM_VERSION=3.21.4
ARG STERN_VERSION=1.34.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dnsutils \
        htop \
        iputils-ping \
        kcat \
        postgresql-client \
        redis-tools \
        telnet \
        tmux \
    # kafkacat was renamed to kcat; keep the old name working
    && ln -s /usr/bin/kcat /usr/local/bin/kafkacat \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
        -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" \
        | tar -xz -C /tmp \
    && mv "/tmp/linux-${TARGETARCH}/helm" /usr/local/bin/helm \
    && rm -rf "/tmp/linux-${TARGETARCH}"

RUN curl -fsSL "https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_${TARGETARCH}.tar.gz" \
        | tar -xz -C /usr/local/bin stern

CMD ["bash"]


FROM base AS ai

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code @openai/codex opencode-ai \
    && npm cache clean --force

CMD ["bash"]
