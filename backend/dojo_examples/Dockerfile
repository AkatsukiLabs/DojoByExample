FROM debian:bookworm-slim

# Accept build arg from compose
ARG EXAMPLE_DIR

# Set environment variable so it's accessible in RUN and CMD
ENV EXAMPLE_DIR=${EXAMPLE_DIR}
ENV ASDF_DIR=/root/.asdf

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    ca-certificates \
    gnupg \
    unzip \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Copy app code
WORKDIR /app
COPY . /app

# Install asdf
RUN git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch v0.14.0 && \
    echo '. "$ASDF_DIR/asdf.sh"' >> ~/.bashrc && \
    echo '. "$ASDF_DIR/completions/asdf.bash"' >> ~/.bashrc

# Use bash for RUN commands
SHELL ["/bin/bash", "-c"]

# Load asdf and install plugins + tools from .tool-versions
RUN source "$ASDF_DIR/asdf.sh" && \
    cd "/app/${EXAMPLE_DIR}" && \
    for plugin in $(cut -d ' ' -f1 .tool-versions); do \
        asdf plugin add "$plugin" || true; \
    done && \
    asdf install && \
    # Set global versions
    SCARB_VERSION=$(grep "scarb" .tool-versions | awk '{print $2}') && \
    DOJO_VERSION=$(grep "dojo" .tool-versions | awk '{print $2}') && \
    asdf global scarb "$SCARB_VERSION" && \
    asdf global dojo "$DOJO_VERSION"

# Final shell starts in the example directory
CMD ["bash", "-c", "cd /app/${EXAMPLE_DIR} && exec bash"]
