# Bevy Dojo Starter Template

[bevy_dojo_starter](https://github.com/okhaimie-dev/bevy_dojo_starter.git) provides a comprehensive template for building 2D onchain games using Bevy game engine integrated with Dojo framework on Starknet. The template showcases a fully functional 2D game that leverages blockchain state management while maintaining smooth gameplay through Bevy's ECS architecture.

## What's Included
### Core Components

- [dojo.bevy](https://github.com/dojoengine/dojo.bevy) Plugin Integration: Pre-configured plugin by the Cartridge.gg team
- Automatic Indexer Connection: Direct integration with [Torii](https://github.com/dojoengine/torii) indexer for real-time blockchain state
- Katana Testnet Integration: Ready-to-use connection to [Katana](https://github.com/dojoengine/katana) sequencer for testing
- 2D Game Example: Complete working game demonstrating onchain mechanics

### Features Demonstrated

- Blockchain state synchronization with game state
- Real-time updates from the Torii indexer
- Transaction handling within game loops
- Seamless onchain/offchain game logic separation

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Bevy Engine   │◄──►│ dojo.bevy Plugin │◄──►│  Starknet       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Game Systems   │    │  State Sync      │    │ Torii Indexer   │
│  & Components   │    │  & Game Systems  │    │ Katana Sequencer│
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Getting Started
### Prerequisites

- Rust ([latest stable version](https://rustup.rs/))
- Dojo development environment
- Basic understanding of Bevy ECS patterns
- Familiarity with Cairo smart contracts

### Installation

-  Clone the starter kit repository
- Install dependencies
- Configure your Dojo environment
- Run the example game

1. Clone the starter kit repository
```
git clone https://github.com/okhaimie-dev/bevy_dojo_starter.git
```
2. Install dependencies
```
cd bevy_dojo_starter
cargo build
```
3. Configure your Dojo environment
```
cd contracts
```
```
katana --config ./katana.toml
```
```
torii --config ./torii_dev.toml
```
```
sozo build
```
```
sozo migrate
```
```
sozo inspect
```
```
cd ..
```

Open the `src/constants/dojo.rs` file.
And modify the `WORLD_ADDRESS` and `ACTION_ADDRESS` constants. To the value you get for this respective constants from the `sozo inspect` command.

4. Run the example game
```
cargo run
```

## Next Steps

- Explore the example game code
- Modify game mechanics to suit your needs
- Deploy to testnet for testing
- Scale to mainnet for production

## Resources

[Bevy Documentation](https://bevy.org/learn/quick-start/introduction/)
[Dojoengine Documentation](https://dojoengine.org/overview)

## Contributing
Contributions are welcome! Please see our contributing guidelines for more
