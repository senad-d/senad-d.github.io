---
title: Run LLM locally with Ollama and Open WebUI
date: 2024-05-13 11:00:00
categories: [LLM]
tags: [ollama, stablediffusion]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/ollama.png?raw=true)
{: .shadow }

# How to install LLM on bare metal

## Install Ollama

Ollama is an advanced AI tool designed to enable users to set up and execute large language models like Llama 2 locally. This innovative tool caters to a broad spectrum of users, from seasoned AI professionals to enthusiasts eager to explore the realms of natural language processing without relying on cloud-based solutions.

[https://ollama.com/download](https://ollama.com/download)

```shell
curl -fsSL https://ollama.com/install.sh | sh
```

### Add a model to Ollama

```shell
ollama pull llama2
```

You can open a new terminal window to monitor GPU usage and confirm module utilization.

```shell
watch -n 0.5 nvidia-smi
```

## Run Open WebUi Docker Container

```shell
docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```

## Stable Diffusion Install

### Prereqs

#### Pyenv

```shell
#Install Pyenv prereqs
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git
```

### Install Pyenv

```shell
curl [https://pyenv.run](https://pyenv.run) | bash

pyenv install 3.10

pyenv global 3.10
```

### Install Stable Diffusion

```shell
wget -q [https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh](https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh)
chmod +x webui.sh
./webui.sh --listen --api
```

# How to run LLM in side of a Docker container

To enable sharing your Nvidia GPU with a docker container, you need to set up GPU passthrough.

```shell
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update
sudo apt install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

Create new Docker network
```shell
docker network create -d bridge lama
```

We need to create a docker-compose.yml file to run all required services.

```yaml
version: '3'
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: unless-stopped
    volumes:
      - ./backend/data:/app/backend/data
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    ports:
      - "8080:8080"
    networks:
      - lama
  
  ollama:
    image: ollama/ollama
    container_name: ollama
    restart: unless-stopped
    volumes:
      - ./ollama:/root/.ollama
    ports:
      - "11434:11434"
    runtime: nvidia
    networks:
      - lama

networks:
  lama:
    external: true
```

Run our new docker-compose.yml

```shell
docker-copose up -d
```

Go to the address `localhost:8080` to visit the newly started container. 
Once there, you can create the first user.