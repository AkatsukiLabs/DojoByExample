FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Scarb
RUN curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/software-mansion/scarb/master/installer.sh | sh

WORKDIR /app

# Copy the project files
COPY . .

CMD ["scarb", "test"]
