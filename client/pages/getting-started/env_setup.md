# Local environment setup

This guide walks through setting up a Dojo development environment, creating a project, and compiling your first dojo project.

::::steps

## Install toolchain

Run this script developed by [Starkiro](https://github.com/KaizeNodeLabs/starkiro) to install asdf and the required Dojo plugins on the latest version:

```bash [Terminal]
curl -s https://raw.githubusercontent.com/KaizeNodeLabs/starkiro/main/cli/install_dojo_dev_suit.sh | bash
```

If you need an specific version you can run:

```bash [Terminal]
curl -s https://raw.githubusercontent.com/KaizeNodeLabs/starkiro/main/cli/install_dojo_dev_suit.sh -o install_dojo_dev_suit.sh
bash install_dojo_dev_suit.sh --scarb <version> --dojo <version>
```

This installs:
- [Scarb](https://docs.swmansion.com/scarb/docs.html) - Cairo package manager.
- [Dojo](https://book.dojoengine.org) - the framework.

:::note[Community Standard]
While you could use a more minimal toolchains, this curated set provides:
- Active maintenance from core contributors.
- Cross-platform compatibility.
- Integrated dependency and version management.
:::

## Create new project with `dojo-starter`

Create a new project with Dojo:

```bash [Terminal]
sozo init dojo-starter
```

This command creates a `dojo-starter` project in your current directory from the Dojo starter template. It's the ideal starting point for a new project and equips you with everything you need to begin hacking.

Take a look at the anatomy of `dojo-starter` project. It manages:

```bash [Terminal]
├── Scarb.toml
├── dojo_dev.toml
├── dojo_release.toml
└── src
    ├── lib.cairo
    ├── models.cairo
    ├── systems
    │   └── actions.cairo
    └── tests
        └── test_world.cairo
```

The scarb manifest `Scarb.toml` is a configuration file where project dependencies, metadata and other configurations are defined. Lets understand this file:

```bash [Terminal]
[package] #indicates that the following statements are configuring a package
cairo-version = "=2.9.2"
name = "dojo-starter" #project name
version = "1.1.0" #project version
edition = "2024_07" #project edition

[cairo]
sierra-replace-ids = true #specific configuration for sierra compile

[scripts] #scripts for the project
migrate = "sozo build && sozo migrate" #custom script to migrate the project              

[dependencies] #list any of your project dependencies
dojo = { git = "https://github.com/dojoengine/dojo", tag = "v1.1.1" } #Dojo dependency with version 1.1.1

[[target.starknet-contract]] #allows to build Starknet smart contracts
build-external-contracts = ["dojo::world::world_contract::world"] #reference to the world contract

[dev-dependencies]
cairo_test = "=2.9.2" #cairo tests version
dojo_cairo_test = { git = "https://github.com/dojoengine/dojo", tag = "v1.1.1" } #dojo tests tools dependencies
```

## Compile smart contract with `sozo build`

The template includes a starter `model` and `system` in `src/lib.cairo{:md}`. Compile it with:

```bash [Terminal]
sozo build
```

That compiled the models and systems into artifacts that can be deployed.

If everything works as expected you would to see an output like this one:

```bash [Terminal]
Compiling dojo-starter v1.1.1 (/your_path/dojo-starter/contract/Scarb.toml)
    Finished `dev` profile target(s) in 5 seconds
```

## Next steps

You're now ready to modify your `dojo-starter` by adding new models and systems.
We will cover the rest of the tools in the next sections.

As a bonus step, we recommend you to explore the [Dojo](https://book.dojoengine.org/overview) and [Cairo](https://book.cairo-lang.org/title-page.html) Documentacion.

