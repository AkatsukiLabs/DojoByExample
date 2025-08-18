# React Integration - Dojo Config

The `dojoConfig.ts` file is the main configuration point that connects the React game frontend to our Dojo onchain gaming infrastructure. It establishes the connection between client side and the blockchain where your game state lives.

## 📁 File Structure

```typescript
// src/dojo/dojoConfig.ts
import { createDojoConfig } from "@dojoengine/core";
import { manifest } from "../config/manifest";

const {
    VITE_PUBLIC_NODE_URL,
    VITE_PUBLIC_TORII,
    VITE_PUBLIC_MASTER_ADDRESS,
    VITE_PUBLIC_MASTER_PRIVATE_KEY,
} = import.meta.env;

export const dojoConfig = createDojoConfig({
    manifest,
    masterAddress: VITE_PUBLIC_MASTER_ADDRESS || '',
    masterPrivateKey: VITE_PUBLIC_MASTER_PRIVATE_KEY || '',
    rpcUrl: VITE_PUBLIC_NODE_URL || '',
    toriiUrl: VITE_PUBLIC_TORII || '',
});
```

## 🎮 Gaming Context

In a Dojo game, your game state lives onchain as ECS (Entity Component System) data. The `dojoConfig` tells your React app:
- **Where to find the blockchain** (via RPC)
- **Where to query game data efficiently** (via Torii indexer)
- **Which game world to connect to** (via manifest)
- **How to submit game actions** (via master account in development)

## 🔧 Configuration Parameters

### `manifest`
The game's deployed contract information contains the:
- **World address**: The onchain location of your game world
- **Contract addresses**: Where your game systems (move, attack, craft, etc.) are deployed
- **Component schemas**: The structure of your game entities (Player, Position, Health, etc.)

### `rpcUrl` (VITE_PUBLIC_NODE_URL)
The Starknet RPC endpoint for blockchain interactions:
- **Local development**: `http://localhost:5050` (Katana)
- **Testnet**: `https://api.cartridge.gg/x/starknet/sepolia`
- **Mainnet**: `https://api.cartridge.gg/x/starknet/mainnet`

### `toriiUrl` (VITE_PUBLIC_TORII)
The Torii GraphQL indexer for fast game data queries:
- **Purpose**: Query game state without waiting for blockchain sync
- **Example queries**: "Get all players in this dungeon", "Show leaderboard", "Fetch my inventory"
- **Local development**: `http://localhost:8080/graphql`

### `masterAddress` & `masterPrivateKey`
Development-only admin account for game actions:
- **Development**: Used for testing game mechanics
- **Production**: Should be empty strings for security
- **Purpose**: Submit transactions on behalf of players during development

## 🌍 Environment Setup

### Local Development (.env.local)
```bash
VITE_PUBLIC_NODE_URL=http://localhost:5050
VITE_PUBLIC_TORII=http://localhost:8080/graphql
VITE_PUBLIC_MASTER_ADDRESS=0x123...abc
VITE_PUBLIC_MASTER_PRIVATE_KEY=0x456...def
```

### Testnet (.env.local)
```bash
VITE_PUBLIC_NODE_URL=https://api.cartridge.gg/x/starknet/sepolia
VITE_PUBLIC_TORII=https://api.cartridge.gg/x/your-game/torii/graphql
VITE_PUBLIC_MASTER_ADDRESS=0x123...abc
VITE_PUBLIC_MASTER_PRIVATE_KEY=0x456...def
```

### Production (.env.production)
```bash
VITE_PUBLIC_NODE_URL=https://api.cartridge.gg/x/starknet/mainnet
VITE_PUBLIC_TORII=https://api.cartridge.gg/x/your-game/torii/graphql
VITE_PUBLIC_MASTER_ADDRESS=
VITE_PUBLIC_MASTER_PRIVATE_KEY=
```

## 🔒 Security for Game Deployment

```typescript
// ✅ Production-safe game configuration
export const dojoConfig = createDojoConfig({
    manifest,
    masterAddress: '', // Never include in production games
    masterPrivateKey: '', // Never include in production games
    rpcUrl: VITE_PUBLIC_NODE_URL || 'https://api.cartridge.gg/x/starknet/mainnet',
    toriiUrl: VITE_PUBLIC_TORII || 'https://api.cartridge.gg/x/your-game/torii/graphql',
});
```

## 🎯 Common Game Setup Issues

**"Can't connect to game world"**
- Check `VITE_PUBLIC_NODE_URL` is accessible
- Verify your game contracts are deployed to the target network
- Ensure `manifest.world.address` exists

**"Game state not loading"**
- Confirm `VITE_PUBLIC_TORII` URL is correct
- Check if Torii indexer is running and synced
- Verify Torii is indexing your specific game world

**"Transactions failing"**
- Ensure wallet is connected to same network as `VITE_PUBLIC_NODE_URL`
- Check if game contracts have proper permissions
- Verify account has sufficient tokens for gas

---

This configuration connects the React game client to the Dojo onchain gaming infrastructure, allowing real-time multiplayer gameplay with persistent blockchain state.

**Next**: While dojoConfig establishes how your React frontend connects to the Dojo infrastructure, the [Manifest](./manifest.md) handles the critical "where" question - determining which deployed contract addresses your app should use based on the current network environment.
