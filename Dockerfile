FROM ubuntu:22.04

# Set metadata
LABEL version="1.0.0"
LABEL maintainer="Maciek Bak"

# Set enviro vars
ENV LANG C.UTF-8
ENV SHELL /bin/bash

# Set the non-root user
ARG USERNAME=angryuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV DEBIAN_FRONTEND=noninteractive

# Create the user and group with the specified UID and GID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y --no-install-recommends sudo git wget \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch to the non-root user
# USER $USERNAME

# Set the workdir
WORKDIR /home/angryuser

# Start the container
CMD ["/bin/bash"]
