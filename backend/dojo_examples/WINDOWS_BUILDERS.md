# 🪟 Windows Setup Guide

If you're building on **Windows**, this guide is for you. At **DojoByExample**, we provide a smooth way to compile and run unit tests without the hassle of manually installing `scarb`, `cairo`, or `dojo` dependencies.

Everything runs inside a **Docker container**, so you can focus on building your Dojo game without dealing with environment setup.

---

## ✅ Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) — Make sure you have the latest version installed.

---

## 🛠️ How to Compile Contracts

1. Navigate to the Docker Compose file at:
   ```
   dojobyexample/backend/dojo_examples/docker-compose.yml
   ```

2. Set the `EXAMPLE_DIR` argument to the name of the example you want to compile:
   ```yaml
   EXAMPLE_DIR: "combat_game"
   ```

3. Run the following command:
   ```bash
   docker compose run --build --rm dojo-by-example-container
   ```

4. This will:
   - Build a container with all required dependencies.
   - Drop you into an interactive bash shell.
   - Automatically place you inside the example directory you specified in `EXAMPLE_DIR`, ready to run:
     ```bash
     sozo build
     sozo test
     ```
   - This compiles your project and runs the unit tests.


---

## ⚙️ Troubleshooting

- If you run into memory-related errors or slow builds, increase the memory limit in `docker-compose.yml`:
  ```yaml
  mem_limit: 4g # Increase this if you encounter memory issues
  ```

- To exit the container, type:
  ```bash
  exit
  ```
  Or, stop the container using Docker Desktop.
