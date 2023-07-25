![build](https://github.com/AngryMaciek/angry-runner/actions/workflows/build.yaml/badge.svg)
[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/angrymaciek/angry-runner)
[![CodeFactor](https://www.codefactor.io/repository/github/angrymaciek/angry-runner/badge)](https://www.codefactor.io/repository/github/angrymaciek/angry-runner)
[![GitHub license](https://img.shields.io/github/license/AngryMaciek/angry-runner)](https://github.com/AngryMaciek/angry-runner/blob/master/LICENSE)

# Angry Runner (😠🏃‍♂️)

Delicious recipe for a Docker image suitable for self-hosted GitHub Actions runners as well as local dev.

Enjoy!

_~AngryMaciek_


### Brief description

The base image here is the popular `ubuntu:22:04` - that is to increase the similarity of the container system to users OSs; A few system tools come pre-installed: [GNU Bash](https://www.gnu.org/software/bash/), [gcc & g++](https://gcc.gnu.org/), [Git](https://git-scm.com/), [GNU Make](https://www.gnu.org/software/make/), [CMake](https://cmake.org/), [Vim](https://www.vim.org/) and most importantly - [mambaforge](https://github.com/conda-forge/miniforge), which has been set up for the (default) root user; port `8888` is exposed to the host machine; dir `/workdir` is available to mount a volume; an entrypoint script has been designed to add a new non-root linux user which can access conda via a system's group; executing commands as `angryuser` is available through [gosu](https://github.com/tianon/gosu).

Useful references:
* https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
* https://askubuntu.com/questions/1457726/how-and-where-to-install-conda-to-be-accessible-to-all-users
* https://www.fromlatest.io

### Local development

(Provided you have a Docker engine installed and set up)

In order to build a container please clone this repository and execute `docker build`:

```bash
cd $HOME
git clone https://github.com/AngryMaciek/angry-runner.git
docker build -f angry-runner/Dockerfile -t angrymaciek/angry-runner:latest angry-runner
```

Alternatively to building yourself you can pull the container from the DockerHub:

```bash
docker pull angrymaciek/angry-runner:latest
```

Run the container with:

```bash
docker run --name angry-runner -e HOSTUID=`id -u $USER` -p 8888:8888 -it -v $HOME:/workdir angry-runner:latest
```

In the example above my whole home directory is mounted as the volume.  
This may, of course, be adjusted.
