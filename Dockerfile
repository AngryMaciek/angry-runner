##### BASE IMAGE #####
FROM ubuntu:24.04

##### METADATA #####
LABEL base.image="ubuntu:24.04"
LABEL version="1.3.0"
LABEL maintainer="Maciek Bak"

##### DEFINE BUILD/ENV VARIABLES #####
ARG MAMBADIR="/mambaforge"
ARG MAMBAURL="https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-x86_64.sh"
ENV LANG C.UTF-8

##### INSTALL SYSTEM-LEVEL DEPENDENCIES #####
RUN apt-get update \
    && apt-get install --no-install-recommends --yes \
    ca-certificates cmake curl g++ gcc git gnupg2 gosu make vim wget \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##### INSTALL MAMBAFORGE & PKGS #####
RUN /bin/bash -c "curl -L ${MAMBAURL} > mambaforge.sh \
    && bash mambaforge.sh -b -p ${MAMBADIR} \
    && ${MAMBADIR}/bin/conda config --system --set channel_priority strict \
    && source ${MAMBADIR}/bin/activate \
    && conda init bash \
    && mamba install boa conda-build conda-verify -c conda-forge --yes \
    && conda clean --all --yes \
    && rm -f mambaforge.sh"

##### EXPOSE PORTS #####
EXPOSE 8888

##### PREPARE WORKING DIRECTORY #####
VOLUME /workdir
WORKDIR /workdir

##### SETUP ENTRYPOINT W/ NONROOT USER #####
COPY entrypoint.sh /bin/entrypoint.sh
RUN /bin/bash -c "chmod +x /bin/entrypoint.sh \
  && groupadd conda \
  && chgrp -R conda ${MAMBADIR} \
  && chmod 770 -R ${MAMBADIR}"
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/bash"]
