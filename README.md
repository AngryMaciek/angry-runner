![build](https://github.com/AngryMaciek/angry-runner/actions/workflows/build.yaml/badge.svg)
[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/angrymaciek/angry-runner)
[![CodeFactor](https://www.codefactor.io/repository/github/angrymaciek/angry-runner/badge)](https://www.codefactor.io/repository/github/angrymaciek/angry-runner)
[![GitHub license](https://img.shields.io/github/license/AngryMaciek/angry-runner)](https://github.com/AngryMaciek/angry-runner/blob/master/LICENSE)

# Angry Runner (😠🏃‍♂️)

Delicious recipe for a Docker image suitable for: (1) self-hosted GitHub Actions runners, (2) local development environment as well as (3) GitHub codespaces base for the devcontainer mechanism.

Enjoy!

_~AngryMaciek_


### Brief description

The base image here is the popular `ubuntu:24:04` - that is to increase the similarity of the container system to users OSs; A few system tools come pre-installed: [GNU Bash](https://www.gnu.org/software/bash/), [Z shell](https://en.wikipedia.org/wiki/Z_shell), [gcc & g++](https://gcc.gnu.org/), [Git](https://git-scm.com/), [GNU Make](https://www.gnu.org/software/make/), [CMake](https://cmake.org/), [valgrind](https://valgrind.org/), [Vim](https://www.vim.org/) and most importantly - [mambaforge](https://github.com/conda-forge/miniforge), which has been set up for the (default) root user; port `8888` is exposed to the host machine; dir `/workspace` is available to mount a volume; an entrypoint script has been designed to add a new non-root linux user which can access conda via a system group; executing commands as `angryuser` is available through [gosu](https://github.com/tianon/gosu); interactive login shell for that user is customised with my personal [Prezto](https://github.com/AngryMaciek/prezto) settings.

Useful references:
* https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
* https://askubuntu.com/questions/1457726/how-and-where-to-install-conda-to-be-accessible-to-all-users
* https://www.fromlatest.io

### Actions runner

In order to execute your CI job on a self-hosted runner in a Docker container please specify:

```yaml
  job:

    runs-on: "self-hosted"
    container:
      image: angrymaciek/angry-runner:latest
      options: --rm=true # cleanup
    defaults:
      run:
        shell: bash # recognise source

    steps:

      # Commands from the ci steps are executed in a non-interactive non-login shell;
      # conda is not initialised there thus every job step with a 'run' directive
      # needs to start with loading conda.
      # PS. base env is not activated automatically
      - name: info
        run: |
          source /mambaforge/etc/profile.d/conda.sh
          conda activate base
          conda info -a
```

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
docker run --name angry-runner -e HOSTUID=`id -u $USER` -p 8888:8888 -it -v $HOME:/workspace angrymaciek/angry-runner:latest
```

Recall that all data generated inside the container (with the exception of the mounted volume) are **not** persistent.  
If you'd like your data don't perish into oblivion after you stop the container
check out [Docker documentation on storage mechanisms](https://docs.docker.com/storage/).
In the example above my whole home directory is mounted as the volume.
This may, of course, be adjusted.

Watch out! Due to Docker's specifics commands above need to be executed as `root` user;
[alternatively, see here](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

### Codespaces (devcontainer)

The following repository is configured to push each new version of the image
to my DockerHub. Feel free to use it as a base for your development
container through the `devcontainer` mechanism; include these lines in your JSON:

```json
  "image": "angrymaciek/angry-runner:latest",
  "postCreateCommand": "bash /bin/entrypoint.sh",
```

By default the container starts as root, though one may swiftly change
to the developer shell with: `gosu angryuser zsh`. Watch out! Depending on the container set up tool
it may turn out that the cloned repository does not have write permission set for _others_ (as root is the owner).
In such case one needs to run `chmod 777 -R .` before switching users.
