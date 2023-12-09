---
title: Run your GitHub Actions locally
date: 2023-08-11 12:00:00
categories: [GitHub]
tags: [github, actions, locally]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

Why would you want to do this? Two reasons:

-   **Fast Feedback** - Rather than having to commit/push every time you want to test out the changes you are making to your `.github/workflows/` files (or for any changes to embedded GitHub actions), you can use `act` to run the actions locally. The [environment variables](https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables) and [filesystem](https://help.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners#filesystems-on-github-hosted-runners) are all configured to match what GitHub provides.
-   **Local Task Runner** - I love [make](https://en.wikipedia.org/wiki/Make_(software)). However, I also hate repeating myself. With `act`, you can use the GitHub Actions defined in your `.github/workflows/` to replace your `Makefile`!

# How Does It Work?

When you run `act` it reads in your GitHub Actions from `.github/workflows/` and determines the set of actions that need to be run. It uses the Docker API to either pull or build the necessary images, as defined in your workflow files and finally determines the execution path based on the dependencies that were defined. Once it has the execution path, it then uses the Docker API to run containers for each action based on the images prepared earlier. The [environment variables](https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables) and [filesystem](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#file-systems) are all configured to match what GitHub provides.

Let's see it in action with a simple demo

 [![Demo](https://github.com/nektos/act/wiki/quickstart/act-quickstart-2.gif)](https://github.com/nektos/act/wiki/quickstart/act-quickstart-2.gif)

# Act User Guide

Please look at the [act user guide](https://nektosact.com) for more documentation.

# Installation

`act` depends on `docker` to run workflows.

### [](https://github.com/nektos/act#homebrew-linuxmacos)[Homebrew](https://brew.sh/) (macOS)

```shell
brew install act
```

or if you want to install version based on latest commit, you can run below (it requires compiler to be installed but Homebrew will suggest you how to install it, if you don't have it):

```shell
brew install act --HEAD
```
## Installation as GitHub CLI extension

Act can be installed as a [GitHub CLI](https://cli.github.com/) extension:

```shell
gh extension install https://github.com/nektos/gh-act
```

## Other install options

### Bash script

Run this command in your terminal:

```shell
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

### Manual download

Download the [latest release](https://github.com/nektos/act/releases/latest) and add the path to your binary into your PATH.

# Example commands

```shell
# Command structure:
act [<event>] [options]
If no event name passed, will default to "on: push"
If actions handles only one event it will be used as default instead of "on: push"

# List all actions for all events:
act -l

# List the actions for a specific event:
act workflow_dispatch -l

# List the actions for a specific job:
act -j test -l

# Run the default (`push`) event:
act

# Run a specific event:
act pull_request

# Run a specific job:
act -j test

# Collect artifacts to the /tmp/artifacts folder:
act --artifact-server-path /tmp/artifacts

# Run a job in a specific workflow (useful if you have duplicate job names)
act -j lint -W .github/workflows/checks.yml

# Run in dry-run mode:
act -n

# Enable verbose-logging (can be used with any of the above commands)
act -v
```

## First `act` run

When running `act` for the first time, it will ask you to choose image to be used as default. It will save that information to `~/.actrc`, please refer to [Configuration](https://github.com/nektos/act#configuration) for more information about `.actrc` and to [Runners](https://github.com/nektos/act#runners) for information about used/available Docker images.

## GITHUB_TOKEN

GitHub [automatically provides](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#about-the-github_token-secret) a `GITHUB_TOKEN` secret when running workflows inside GitHub.

If your workflow depends on this token, you need to create a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) and pass it to `act` as a secret:

```shell
act -s GITHUB_TOKEN=[insert token or leave blank and omit equals for secure input]
```

If [GitHub CLI](https://cli.github.com/) is installed, the [`gh auth token`](https://cli.github.com/manual/gh_auth_token) command can be used to automatically pass the token to act

```shell
act -s GITHUB_TOKEN="$(gh auth token)"
```

**WARNING**: `GITHUB_TOKEN` will be logged in shell history if not inserted through secure input or (depending on your shell config) the command is prefixed with a whitespace.

## Docker context support

The current `docker context` isn't respected ([#583](https://github.com/nektos/act/issues/583)).

You can work around this by setting `DOCKER_HOST` before running `act`, with e.g:

```shell
export DOCKER_HOST=$(docker context inspect --format '\{\{.Endpoints.docker.Host}}')
```

# Runners

GitHub Actions offers managed [virtual environments](https://help.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners) for running workflows. In order for `act` to run your workflows locally, it must run a container for the runner defined in your workflow file. Here are the images that `act` uses for each runner type and size:

| GitHub Runner | Micro Docker Image | Medium Docker Image | Large Docker Image |
| --- | --- | --- | --- |
| `ubuntu-latest` | [`node:16-buster-slim`](https://hub.docker.com/_/buildpack-deps) | [`catthehacker/ubuntu:act-latest`](https://github.com/catthehacker/docker_images) | [`catthehacker/ubuntu:full-latest`](https://github.com/catthehacker/docker_images) |
| `ubuntu-22.04` | [`node:16-bullseye-slim`](https://hub.docker.com/_/buildpack-deps) | [`catthehacker/ubuntu:act-22.04`](https://github.com/catthehacker/docker_images) | `unavailable` |
| `ubuntu-20.04` | [`node:16-buster-slim`](https://hub.docker.com/_/buildpack-deps) | [`catthehacker/ubuntu:act-20.04`](https://github.com/catthehacker/docker_images) | [`catthehacker/ubuntu:full-20.04`](https://github.com/catthehacker/docker_images) |
| `ubuntu-18.04` | [`node:16-buster-slim`](https://hub.docker.com/_/buildpack-deps) | [`catthehacker/ubuntu:act-18.04`](https://github.com/catthehacker/docker_images) | [`catthehacker/ubuntu:full-18.04`](https://github.com/catthehacker/docker_images) |

Windows and macOS based platforms are currently **unsupported and won't work** (see issue [#97](https://github.com/nektos/act/issues/97))

Please see [IMAGES.md](https://github.com/nektos/act/blob/master/IMAGES.md) for more information about the Docker images that can be used with `act`

## Default runners are intentionally incomplete

These default images do **not** contain **all** the tools that GitHub Actions offers by default in their runners. Many things can work improperly or not at all while running those image. Additionally, some software might still not work even if installed properly, since GitHub Actions are running in fully virtualized machines while `act` is using Docker containers (e.g. Docker does not support running `systemd`). In case of any problems [please create issue](https://github.com/nektos/act/issues/new/choose) in respective repository (issues with `act` in this repository, issues with `nektos/act-environments-ubuntu:18.04` in [`nektos/act-environments`](https://github.com/nektos/act-environments) and issues with any image from user `catthehacker` in [`catthehacker/docker_images`](https://github.com/catthehacker/docker_images))

## Alternative runner images

If you need an environment that works just like the corresponding GitHub runner then consider using an image provided by [nektos/act-environments](https://github.com/nektos/act-environments):

-   [`nektos/act-environments-ubuntu:18.04`](https://hub.docker.com/r/nektos/act-environments-ubuntu/tags) - built from the Packer file GitHub uses in [actions/virtual-environments](https://github.com/actions/runner).

⚠️ 🐘 `*** WARNING - this image is >18GB 😱***`

-   [`catthehacker/ubuntu:full-*`](https://github.com/catthehacker/docker_images/pkgs/container/ubuntu) - built from Packer template provided by GitHub, see [catthehacker/virtual-environments-fork](https://github.com/catthehacker/virtual-environments-fork) or [catthehacker/docker\_images](https://github.com/catthehacker/docker_images) for more information

## Using local runner images

The `--pull` flag is set to true by default due to a breaking on older default docker images. This would pull the docker image everytime act is executed.

Set `--pull` to false if a local docker image is needed

```shell
  act --pull=false
```

## Use an alternative runner image

To use a different image for the runner, use the `-P` option.

```shell
act -P <platform>=<docker-image>
```

If your workflow uses `ubuntu-18.04`, consider below line as an example for changing Docker image used to run that workflow:

```shell
act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04
```

If you use multiple platforms in your workflow, you have to specify them to change which image is used. For example, if your workflow uses `ubuntu-18.04`, `ubuntu-16.04` and `ubuntu-latest`, specify all platforms like below

```shell
act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 -P ubuntu-latest=ubuntu:latest -P ubuntu-16.04=node:16-buster-slim
```

# Secrets

To run `act` with secrets, you can enter them interactively, supply them as environment variables or load them from a file. The following options are available for providing secrets:

-   `act -s MY_SECRET=somevalue` - use `somevalue` as the value for `MY_SECRET`.
-   `act -s MY_SECRET` - check for an environment variable named `MY_SECRET` and use it if it exists. If the environment variable is not defined, prompt the user for a value.
-   `act --secret-file my.secrets` - load secrets values from `my.secrets` file.
    -   secrets file format is the same as `.env` format

# Configuration

You can provide default configuration flags to `act` by either creating a `./.actrc` or a `~/.actrc` file. Any flags in the files will be applied before any flags provided directly on the command line. For example, a file like below will always use the `nektos/act-environments-ubuntu:18.04` image for the `ubuntu-latest` runner:

```shell
# sample .actrc file
-P ubuntu-latest=nektos/act-environments-ubuntu:18.04
```

Additionally, act supports loading environment variables from an `.env` file. The default is to look in the working directory for the file but can be overridden by:

```shell
act --env-file my.env
```

`.env`:

```shell
MY_ENV_VAR=MY_ENV_VAR_VALUE
MY_2ND_ENV_VAR="my 2nd env var value"
```
