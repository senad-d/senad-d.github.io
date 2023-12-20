---
title: How to use Docker without Docker Desktop on MacOS (M2)
date: 2023-11-14 12:00:00
categories: [Software, Docker]
tags: [docker, cli]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/docker-banner.png?raw=true){: .shadow }

If you are facing challenges with Docker Desktop licensing for a large software team, this guide will assist you in easily utilizing Docker CLI on Mac machines with M2 chips.

> Licensing only affect the Docker Desktop product, the CLI interface remains free for all users.
{: .prompt-tip }

## Prerequisite
  - [Homebrew](https://brew.sh/)

# Setup Docker without Docker Desktop manually

1\. Install `Docker` and the `docker-credential-helper`. The credential helper allows you to use the macOS Keychain as the credential store for remote container repos instead of Docker Desktop.

```shell
brew install docker docker-credential-helper
```

- You may encounter an issue later on where the Docker CLI throws an error stating that 'docker-credential-desktop' is not installed. This error is likely caused by a misconfiguration, possibly from a `previous installation` of Docker Desktop. You can resolve this issue by following these steps.

```shell
nano ~/.docker/config.json

{
        "auths": {},
        "credsStore": "osxkeychain",
        "currentContext": "colima"
}
```

2\. `Colima` is a container runtime that supports Docker (and containerd) and needs to be installed.

```shell
brew install colima
```

3\. After installing, simply initiate the Colima VM to start using it.

```shell
colima start
docker context use colima
```

4\. Test the setup

```shell
docker run hello-world
```

# Installation script

If you are looking for a quick and easy method to set up the Docker CLI, use this script:

```shell
#!/bin/bash

SHELL_TYPE="$(basename "$SHELL")"

brew update && brew install docker docker-credential-helper colima

cat <<EOF > ~/.docker/config.json
{
        "auths": {},
        "credsStore": "osxkeychain",
        "currentContext": "colima"
}
EOF

colima start
docker context use colima

if [ "$SHELL_TYPE" = "bash" ]; then
    echo "alias docker-start='colima start'" >> ~/.bashrc
    echo "alias docker-stop='colima stop'" >> ~/.bashrc
    source ~/.bashrc
elif [ "$SHELL_TYPE" = "zsh" ]; then
    echo "alias docker-start='colima start'" >> ~/.zshrc
    echo "alias docker-stop='colima stop'" >> ~/.zshrc
    source ~/.zshrc
else
    echo "Unsupported shell: $SHELL_TYPE"
fi

```

- How to start or stop Docker runtime

```shell
docker-start
docker-stop
```

## Control Docker

If you're not comfortable with the Docker CLI, you can use the ***`Docker`*** [extension](https://github.com/microsoft/vscode-docker) in VSCode to easily manage containers, images, volumes, and networks.

![](https://github.com/microsoft/vscode-docker/blob/main/resources/readme/overview.gif?raw=true){: .shadow }
