# NodeboxHQ Meta

This repository contains cool scripts and configuration files that powers NodeboxHQ.

## Dashboard Initializer

```bash
command -v curl &>/dev/null && curl -s https://raw.githubusercontent.com/NodeBoxHQ/meta/main/dashboard/initialize.sh | bash || { command -v wget &>/dev/null && wget -qO- https://raw.githubusercontent.com/NodeBoxHQ/meta/main/dashboard/initialize.sh | bash || echo "Neither curl nor wget is available, install one to continue."; }
```
