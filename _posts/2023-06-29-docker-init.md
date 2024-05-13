---
title: Docker init
date: 2023-06-29 11:00:00
categories: [Docker]
tags: [cli, init]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/docker-banner.png?raw=true)
{: .shadow }

Initialize a project with the files necessary to run the project in a container.

Docker 4.18 and later provides the Docker Init plugin with the `docker init` CLI command. Run `docker init` in your project directory to be walked through the creation of the following files with sensible defaults for your project:

-   .dockerignore
-   Dockerfile
-   compose.yaml
-   README.Docker.md

> If any of the files already exist, a prompt appears and provides a warning as well as giving you the option to overwrite all the files.
{: .prompt-tip }

After running `docker init`, you can choose one of the following templates:

-   ASP.NET Core: Suitable for an ASP.NET Core application.
-   Go: Suitable for a Go server application.
-   Node: Suitable for a Node server application.
-   PHP with Apache: Suitable for a PHP web application.
-   Python: Suitable for a Python server application.
-   Rust: Suitable for a Rust server application.
-   Other: General purpose starting point for containerizing your application.

After `docker init` has completed, you may need to modify the created files and tailor them to your project. Visit the following topics to learn more about the files:

-   [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file)
-   [Dockerfile](https://docs.docker.com/engine/reference/builder/)
-   [compose.yaml](https://docs.docker.com/compose/compose-application-model/)

## Example of running docker init

The following example shows the initial menu after running `docker init`.

```
$ docker init

Welcome to the Docker Init CLI!

This utility will walk you through creating the following files with sensible defaults for your project:
  - .dockerignore
  - Dockerfile
  - compose.yaml
  - README.Docker.md

Let's get started!

? What application platform does your project use?  [Use arrows to move, type to filter]
 PHP with Apache - (detected) suitable for a PHP web application
  Go - (detected) suitable for a Go server application
  Python - suitable for a Python server application
  Node - suitable for a Node server application
  Rust - suitable for a Rust server application
  ASP.NET Core - suitable for an ASP.NET Core application
  Other - general purpose starting point for containerizing your application
  Don't see something you need? Let us know!
  Quit
```

## See Docker Init in action

To see `docker init` in action, check out the following overview video by [Francesco Ciulla](https://www.linkedin.com/in/francesco-ciulla-roma/), which demonstrates building the required Docker assets to your project.

{% include embed/youtube.html id='f4cHtDRZv5U' %}