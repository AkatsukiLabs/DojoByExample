# React Integration - Starknet Provider

The **StarknetProvider.tsx** file is a crucial configuration component that establishes the connection between your Dojo game and the Starknet blockchain. This provider wrapper acts as the foundation for all blockchain interactions in your React application, coordinating wallet connections, network configurations, and RPC providers for seamless gaming experiences.

## File Overview & Purpose

The `StarknetProvider.tsx` file serves as the central configuration hub for Starknet React integration in Dojo games. It wraps your entire application with the necessary context providers that enable:

- **Blockchain Connectivity**: Establishes connections to Starknet networks (mainnet, sepolia)
- **Gaming-Optimized Wallet Integration**: Configures Cartridge Controller for frictionless gaming UX
- **Environment-Based Network Management**: Handles automatic switching between different blockchain networks
- **Session Continuity**: Provides React context for persistent blockchain state throughout your game

> **Gaming-First Design**: Unlike traditional DeFi applications, this provider is specifically optimized for gaming experiences, prioritizing fast transactions, session management, and user-friendly wallet interactions that don't interrupt gameplay flow.

## Complete Implementation

```typescript
import type { PropsWithChildren } from "react";
import { sepolia, mainnet } from "@starknet-react/chains";
import {
    jsonRpcProvider,
    StarknetConfig,
    starkscan,
} from "@starknet-react/core";
import cartridgeConnector from "../config/cartridgeConnector";

export default function StarknetProvider({ children }: PropsWithChildren) {
    const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;

    // Get RPC URL based on environment
    const getRpcUrl = () => {
        switch (VITE_PUBLIC_DEPLOY_TYPE) {
            case "mainnet":
                return "https://api.cartridge.gg/x/starknet/mainnet";
            case "sepolia":
                return "https://api.cartridge.gg/x/starknet/sepolia";
            default:
                return "https://api.cartridge.gg/x/starknet/sepolia"; 
        }
    };

    // Create provider with the correct RPC URL
    const provider = jsonRpcProvider({
        rpc: () => ({ nodeUrl: getRpcUrl() }),
    });

    // Determine which chain to use
    const chains = VITE_PUBLIC_DEPLOY_TYPE === "mainnet" 
        ? [mainnet] 
        : [sepolia];

    return (
        <StarknetConfig
            autoConnect
            chains={chains}
            connectors={[cartridgeConnector]}
            explorer={starkscan}
            provider={provider}
        >
            {children}
        </StarknetConfig>
    );
}
```

## Imports and Dependencies

### Core React Types
```typescript
import type { PropsWithChildren } from "react";
```

**Purpose**: Provides TypeScript types for React components that accept children elements.

**Gaming Context**: Enables the provider to wrap any React component tree with proper type safety, ensuring your entire game interface has access to blockchain functionality.

### Starknet React Chains
```typescript
import { sepolia, mainnet } from "@starknet-react/chains";
```

**Purpose**: Pre-configured chain objects containing network-specific settings for Starknet networks.

**Gaming Benefits**:
- `sepolia`: Testnet perfect for game development and testing without real asset risk
- `mainnet`: Production network where players interact with real assets and achievements
- Each chain includes optimized RPC endpoints and network identifiers for gaming applications

### Starknet React Core
```typescript
import {
    jsonRpcProvider,
    StarknetConfig,
    starkscan,
} from "@starknet-react/core";
```

**Component Breakdown**:
- `jsonRpcProvider`: Creates RPC providers optimized for gaming transaction patterns
- `StarknetConfig`: Main configuration wrapper that enables gaming-focused blockchain integration
- `starkscan`: Block explorer integration for players to view their game transactions and achievements

### Gaming-Optimized Connector
```typescript
import cartridgeConnector from "../config/cartridgeConnector";
```

**Purpose**: Imports the Cartridge Controller connector specifically designed for gaming applications.

**Gaming Advantages**: Cartridge Controller provides session-based wallet management, eliminating the need for players to sign every transaction during gameplay, creating a smooth gaming experience similar to traditional games.

## Component Structure and Props

### Function Signature
```typescript
export default function StarknetProvider({ children }: PropsWithChildren)
```

**Gaming Pattern**: This follows the standard React provider pattern, allowing any game component (menus, gameplay interfaces, inventory systems) to access blockchain functionality seamlessly.

**Typical Game Usage**:
```typescript
<StarknetProvider>
  <GameInterface />
  <PlayerInventory />
  <LeaderboardSystem />
</StarknetProvider>
```

## Environment Configuration

### Environment-Based Network Targeting
```typescript
const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;
```

**Gaming Deployment Strategy**:
- **Development**: Uses sepolia testnet for safe game testing
- **Production**: Switches to mainnet for live gaming with real assets
- **Automatic Detection**: No manual network switching required for players

**Environment Setup for Game Development**:

```bash
# .env.development - Safe testing environment
VITE_PUBLIC_DEPLOY_TYPE=sepolia

# .env.production - Live gaming environment  
VITE_PUBLIC_DEPLOY_TYPE=mainnet
```

## RPC Provider Configuration

### Gaming-Optimized RPC Selection
```typescript
const getRpcUrl = () => {
    switch (VITE_PUBLIC_DEPLOY_TYPE) {
        case "mainnet":
            return "https://api.cartridge.gg/x/starknet/mainnet";
        case "sepolia":
            return "https://api.cartridge.gg/x/starknet/sepolia";
        default:
            return "https://api.cartridge.gg/x/starknet/sepolia"; 
    }
};
```

**Why Cartridge RPC Endpoints?**:
- **Gaming Optimization**: Specifically tuned for game transaction patterns and session management
- **High Performance**: Reduced latency for real-time gaming interactions
- **Reliability**: Built for gaming applications that require consistent uptime
- **Safe Defaults**: Automatically falls back to testnet to prevent accidental mainnet usage during development

### Provider Creation
```typescript
const provider = jsonRpcProvider({
    rpc: () => ({ nodeUrl: getRpcUrl() }),
});
```

**Gaming Implementation**: Creates a JSON-RPC provider that automatically connects to the appropriate gaming-optimized endpoint based on your deployment environment, ensuring players always connect to the right network.

## Chain Configuration

### Dynamic Chain Selection for Gaming
```typescript
const chains = VITE_PUBLIC_DEPLOY_TYPE === "mainnet" 
    ? [mainnet] 
    : [sepolia];
```

**Gaming Logic**:
- **Mainnet**: Production gaming environment where players' actions have real value
- **Sepolia**: Safe testing environment for game development and QA
- **Automatic Switching**: Players never need to manually configure networks

**Player Experience**: The game automatically connects to the appropriate network, maintaining the seamless experience players expect from modern games.

## StarknetConfig Properties

### Gaming-Focused Configuration
```typescript
<StarknetConfig
    autoConnect
    chains={chains}
    connectors={[cartridgeConnector]}
    explorer={starkscan}
    provider={provider}
>
    {children}
</StarknetConfig>
```

### Property Breakdown for Gaming

#### `autoConnect`
**Gaming Benefit**: Automatically reconnects players to their wallet when they return to the game, eliminating the frustration of having to reconnect every session.

**Player Experience**: Just like saving game progress, wallet connections persist between gaming sessions.

#### `chains={chains}`
**Gaming Purpose**: Defines which blockchain networks your game supports, automatically selecting the appropriate environment.

**Player Impact**: Players connect to the right network without technical configuration, maintaining the plug-and-play experience of traditional games.

#### `connectors={[cartridgeConnector]}`
**Gaming Innovation**: Uses Cartridge Controller, designed specifically for gaming applications.

**Unique Gaming Features**:
- **Session Management**: Pre-approved transactions for uninterrupted gameplay
- **Gas Optimization**: Efficient transaction batching for gaming actions
- **User-Friendly Interface**: Gaming-focused wallet UI that doesn't feel like DeFi

#### `explorer={starkscan}`
**Gaming Utility**: Integrates Starkscan block explorer for players to view their game transactions, achievements, and asset history.

**Player Value**: Players can track their gaming history, verify rare item acquisitions, and share achievement transactions.

#### `provider={provider}`
**Gaming Infrastructure**: Provides the blockchain communication layer optimized for gaming transaction patterns.

**Technical Gaming Benefits**: Handles all game-to-blockchain communication efficiently, ensuring smooth gameplay without blockchain complexity exposure to players.

## Integration in Gaming Applications

### Provider Hierarchy for Games
```typescript
// main.tsx - Typical gaming application structure
<DojoSdkProvider sdk={sdk} dojoConfig={dojoConfig} clientFn={setupWorld}>
  <StarknetProvider>
    <GameInterface />
    <PlayerStats />
    <InventorySystem />
  </StarknetProvider>
</DojoSdkProvider>
```

### Using Gaming Hooks
Once wrapped by `StarknetProvider`, game components can access blockchain functionality:

```typescript
import { useAccount, useContract } from "@starknet-react/core";

function PlayerDashboard() {
    const { account, isConnected } = useAccount();
    
    return (
        <div>
            {isConnected ? (
                <GameInterface playerAddress={account?.address} />
            ) : (
                <ConnectWalletButton />
            )}
        </div>
    );
}
```

## Gaming Benefits Summary

**For Players**:
- Seamless wallet connections that persist between gaming sessions
- Automatic network selection without technical configuration
- Gaming-optimized transaction flow that doesn't interrupt gameplay

**For Developers**:
- Environment-based deployment without code changes
- Gaming-focused RPC endpoints optimized for game transaction patterns
- Clean integration with Dojo's gaming infrastructure

**For Game Operations**:
- Reliable infrastructure designed for gaming applications
- Built-in explorer integration for player transaction transparency
- Session management that reduces transaction friction

---

*Ready to configure gaming-specific wallet features? Check out [Controller Connector](/integrations/react/controller-connector) to set up Cartridge Controller for your game.*