FROM debian:bookworm

# Install LLVM build dependencies and development tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    git \
    python3 \
    python3-pip \
    ca-certificates \
    zlib1g-dev \
    libedit-dev \
    libxml2-dev \
    libncurses-dev \
    swig \
    doxygen \
    graphviz \
    gdb \
    lldb \
    vim \
    wget \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for development
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up working directory
WORKDIR /workspace

USER $USERNAME

# Default command opens a bash shell
CMD ["/bin/bash"]
