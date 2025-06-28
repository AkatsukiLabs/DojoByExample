# React Integration - Starknet Provider

The **StarknetProvider.tsx** file is a crucial configuration component that establishes the connection between your Dojo game and the Starknet blockchain. This provider wrapper acts as the foundation for all blockchain interactions in your React application, coordinating wallet connections, network configurations, and RPC providers for seamless gaming experiences.

## File Overview & Purpose

The `StarknetProvider.tsx` file serves as the central configuration hub for Starknet React integration in Dojo games. It wraps your entire application with the necessary context providers that enable:

- **Blockchain Connectivity**: Establishes connections to Starknet networks (mainnet, sepolia, localhost)
- **Wallet Integration**: Configures wallet connectors like Cartridge Controller for gaming-optimized UX
- **Network Management**: Handles environment-based switching between different blockchain networks
- **State Management**: Provides React context for blockchain state throughout your application

> **Gaming-First Design**: Unlike traditional DeFi applications, this provider is specifically optimized for gaming experiences, prioritizing fast transactions, session management, and user-friendly wallet interactions.

## Complete Implementation

Here's the complete `StarknetProvider.tsx` implementation with detailed explanations:

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
    // Environment configuration for deployment targeting
    const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;

    // Dynamic RPC URL selection based on deployment environment
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

    // Configure JSON-RPC provider with environment-specific endpoint
    const provider = jsonRpcProvider({
        rpc: () => ({ nodeUrl: getRpcUrl() }),
    });

    // Dynamic chain selection based on deployment type
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

**Usage**: Enables the provider to wrap any React component tree with proper type safety.

### Starknet React Chains
```typescript
import { sepolia, mainnet } from "@starknet-react/chains";
```

**Purpose**: Pre-configured chain objects containing network-specific settings.

**Details**:
- `sepolia`: Starknet testnet configuration
- `mainnet`: Starknet production network configuration
- Each chain object includes RPC endpoints, block explorers, and network identifiers

### Starknet React Core
```typescript
import {
    jsonRpcProvider,
    StarknetConfig,
    starkscan,
} from "@starknet-react/core";
```

**Component Breakdown**:
- `jsonRpcProvider`: Creates RPC providers for blockchain communication
- `StarknetConfig`: Main configuration wrapper for the entire Starknet integration
- `starkscan`: Block explorer integration for transaction viewing

### Cartridge Connector Import
```typescript
import cartridgeConnector from "../config/cartridgeConnector";
```

**Purpose**: Imports the gaming-optimized wallet connector configuration.

**Why Important**: Cartridge Controller provides session-based wallet management, eliminating the need for users to sign every transaction during gameplay.

## Component Structure and Props

### Function Signature
```typescript
export default function StarknetProvider({ children }: PropsWithChildren)
```

**Pattern Explanation**:
- **PropsWithChildren**: Standard React pattern for provider components
- **children**: All child components that need access to Starknet functionality
- **Provider Wrapper**: Enables any descendant component to use Starknet hooks

### Usage in Component Tree
```typescript
// Typical application structure
function App() {
    return (
        <StarknetProvider>
            <DojoProvider>
                <GameInterface />
                <WalletConnection />
            </DojoProvider>
        </StarknetProvider>
    );
}
```

## Environment Configuration

### Environment Variable Usage
```typescript
const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;
```

**Environment Variables**:
- `VITE_PUBLIC_DEPLOY_TYPE`: Controls which network the application targets
- **Values**: "mainnet", "sepolia", or undefined (defaults to sepolia)
- **Vite Integration**: Uses Vite's environment variable system for build-time configuration

**Environment Setup Examples**:

**.env.development**
```bash
VITE_PUBLIC_DEPLOY_TYPE=sepolia
```

**.env.production**
```bash
VITE_PUBLIC_DEPLOY_TYPE=mainnet
```

**.env.local** (for local development)
```bash
VITE_PUBLIC_DEPLOY_TYPE=sepolia
```

## RPC Provider Configuration

### Dynamic RPC URL Selection
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

**RPC Endpoint Details**:

| Network | Endpoint | Purpose |
|---------|----------|---------|
| Mainnet | `https://api.cartridge.gg/x/starknet/mainnet` | Production blockchain |
| Sepolia | `https://api.cartridge.gg/x/starknet/sepolia` | Testnet for development |
| Default | `https://api.cartridge.gg/x/starknet/sepolia` | Fallback to testnet |

**Why Cartridge RPC Endpoints?**:
- **Gaming Optimization**: Optimized for game-specific transaction patterns
- **Reliability**: High uptime and performance for gaming applications
- **Integration**: Seamless integration with Cartridge Controller wallet

### JSON-RPC Provider Setup
```typescript
const provider = jsonRpcProvider({
    rpc: () => ({ nodeUrl: getRpcUrl() }),
});
```

**Configuration Breakdown**:
- **jsonRpcProvider**: Creates a provider instance for blockchain communication
- **rpc function**: Returns configuration object with the node URL
- **Dynamic URL**: Calls `getRpcUrl()` to determine the appropriate endpoint based on environment

**Custom RPC Configuration Example**:
```typescript
// For local development with Katana
const provider = jsonRpcProvider({
    rpc: () => ({ 
        nodeUrl: process.env.NODE_ENV === 'development' 
            ? "http://localhost:5050" 
            : getRpcUrl() 
    }),
});
```

## Chain Configuration

### Dynamic Chain Selection
```typescript
const chains = VITE_PUBLIC_DEPLOY_TYPE === "mainnet"
    ? [mainnet]
    : [sepolia];
```

**Chain Selection Logic**:
- **Mainnet**: Production environment with real assets
- **Sepolia**: All other environments (development, testing, staging)
- **Array Format**: StarknetConfig expects an array of chain configurations

**Multi-Chain Configuration Example**:
```typescript
// Supporting multiple networks simultaneously
const chains = VITE_PUBLIC_DEPLOY_TYPE === "mainnet"
    ? [mainnet]
    : [sepolia, localhost]; // Add localhost for development

// Localhost chain configuration (for Katana)
const localhost = {
    id: "0x4b4154414e41", // "KATANA" in hex
    name: "Katana",
    network: "katana",
    nativeCurrency: {
        address: "0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7",
        name: "Ether",
        symbol: "ETH",
        decimals: 18,
    },
    rpcUrls: {
        default: {
            http: ["http://localhost:5050"],
        },
        public: {
            http: ["http://localhost:5050"],
        },
    },
    testnet: true,
};
```

## StarknetConfig Properties

### Complete Configuration Breakdown
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

### Property Explanations

#### `autoConnect`
**Purpose**: Automatically attempts to reconnect to previously connected wallets when the application loads.

**Behavior**:
- Checks for stored wallet connection data in browser storage
- Attempts to restore the connection without user intervention
- Improves UX by maintaining session continuity

**Gaming Benefits**: Players don't need to reconnect their wallet every time they reload the game.

#### `chains={chains}`
**Purpose**: Defines which blockchain networks your application supports.

**Configuration**:
- Array of chain objects with network-specific settings
- Each chain includes RPC endpoints, native currency info, and network identifiers
- Allows wallet to switch between supported networks

#### `connectors={[cartridgeConnector]}`
**Purpose**: Defines available wallet connection methods.

**Cartridge Connector Benefits**:
- **Session Management**: Enables gasless transactions during gameplay
- **Gaming UX**: Eliminates transaction popups for pre-approved actions
- **Account Abstraction**: Supports advanced account features for gaming

**Multiple Connectors Example**:
```typescript
// Supporting multiple wallet types
import { argentConnector, braavosConnector } from "@starknet-react/core";

connectors={[
    cartridgeConnector,
    argentConnector(),
    braavosConnector(),
]}
```

#### `explorer={starkscan}`
**Purpose**: Integrates block explorer for transaction viewing and debugging.

**Features**:
- View transaction details and status
- Explore contract interactions
- Debug failed transactions

**Custom Explorer Example**:
```typescript
// Using Voyager instead of Starkscan
import { voyager } from "@starknet-react/core";

explorer={voyager}
```

#### `provider={provider}`
**Purpose**: Configures the RPC provider for blockchain communication.

**Responsibilities**:
- Handles all read operations (contract calls, balance queries)
- Manages transaction broadcasting
- Provides network connectivity

## Integration Patterns

### Provider Hierarchy

The `StarknetProvider` should be placed high in your component tree to make Starknet functionality available throughout your application:

```typescript
// Recommended provider hierarchy for Dojo games
function App() {
    return (
        <StarknetProvider>
            <DojoProvider>
                <QueryClient client={queryClient}>
                    <Router>
                        <GameLayout>
                            <Routes>
                                <Route path="/" element={<GameInterface />} />
                                <Route path="/inventory" element={<Inventory />} />
                            </Routes>
                        </GameLayout>
                    </Router>
                </QueryClient>
            </DojoProvider>
        </StarknetProvider>
    );
}
```

### Using Starknet Hooks in Components

Once wrapped by `StarknetProvider`, child components can use Starknet React hooks:

```typescript
import { useAccount, useContract, useContractRead } from "@starknet-react/core";

function GameInterface() {
    // Access connected account
    const { account, isConnected } = useAccount();
    
    // Read game state from contract
    const { data: playerStats } = useContractRead({
        address: gameContractAddress,
        abi: gameAbi,
        functionName: "get_player_stats",
        args: [account?.address],
    });

    // Contract interactions
    const { contract } = useContract({
        address: gameContractAddress,
        abi: gameAbi,
    });

    return (
        <div>
            {isConnected ? (
                <PlayerDashboard stats={playerStats} contract={contract} />
            ) : (
                <ConnectWallet />
            )}
        </div>
    );
}
```

### Environment-Based Configuration Management

For complex games with multiple deployment environments:

```typescript
// config/networks.ts
export const NETWORK_CONFIG = {
    mainnet: {
        rpc: "https://api.cartridge.gg/x/starknet/mainnet",
        gameContract: "0x...", // mainnet contract address
        explorerUrl: "https://starkscan.co",
    },
    sepolia: {
        rpc: "https://api.cartridge.gg/x/starknet/sepolia",
        gameContract: "0x...", // sepolia contract address
        explorerUrl: "https://sepolia.starkscan.co",
    },
    localhost: {
        rpc: "http://localhost:5050",
        gameContract: "0x...", // local katana contract address
        explorerUrl: null,
    },
};

// Enhanced StarknetProvider with network config
export default function StarknetProvider({ children }: PropsWithChildren) {
    const deployType = import.meta.env.VITE_PUBLIC_DEPLOY_TYPE || 'sepolia';
    const networkConfig = NETWORK_CONFIG[deployType];
    
    const provider = jsonRpcProvider({
        rpc: () => ({ nodeUrl: networkConfig.rpc }),
    });
    
    // ... rest of configuration
}
```

## Debugging and Development

### Debug Configuration

For development and debugging, you can add additional logging and configuration:

```typescript
// Debug-enabled provider configuration
export default function StarknetProvider({ children }: PropsWithChildren) {
    const { VITE_PUBLIC_DEPLOY_TYPE, NODE_ENV } = import.meta.env;
    
    // Log configuration in development
    if (NODE_ENV === 'development') {
        console.log('Starknet Provider Configuration:', {
            deployType: VITE_PUBLIC_DEPLOY_TYPE,
            rpcUrl: getRpcUrl(),
            isMainnet: VITE_PUBLIC_DEPLOY_TYPE === "mainnet",
        });
    }
    
    // ... rest of configuration
}
```

### Common Issues and Solutions

**Issue**: Provider not connecting to wallet
**Solution**: Ensure `autoConnect` is enabled and cartridgeConnector is properly configured

**Issue**: Wrong network selected
**Solution**: Verify `VITE_PUBLIC_DEPLOY_TYPE` environment variable is set correctly

**Issue**: RPC connection failures
**Solution**: Check network connectivity and RPC endpoint availability

## Production Considerations

### Security Best Practices

1. **Environment Variables**: Never expose private keys or sensitive data in environment variables
2. **RPC Endpoints**: Use reliable, production-grade RPC providers
3. **Network Validation**: Always validate the connected network matches your expectations

### Performance Optimization

1. **Provider Caching**: The provider instance is created once per component lifecycle
2. **Connection Persistence**: `autoConnect` maintains user sessions
3. **Error Handling**: Implement proper error boundaries around provider usage

### Monitoring and Analytics

```typescript
// Enhanced provider with monitoring
const provider = jsonRpcProvider({
    rpc: () => {
        const nodeUrl = getRpcUrl();
        
        // Log RPC usage for monitoring
        if (import.meta.env.PROD) {
            analytics.track('rpc_connection', { network: VITE_PUBLIC_DEPLOY_TYPE });
        }
        
        return { nodeUrl };
    },
});
```

## Next Steps

Once you have the `StarknetProvider` configured, you can:

1. **Set up Cartridge Controller**: Configure session policies and gaming-specific wallet features
2. **Implement Dojo Integration**: Connect to your Dojo world contracts
3. **Add Transaction Management**: Handle game actions and state updates
4. **Build Game UI**: Create components that interact with your onchain game logic

The `StarknetProvider` serves as the foundation that makes all other Starknet and Dojo integrations possible, providing the essential blockchain connectivity that powers your onchain gaming experience.

---

*Ready to integrate wallet connections? Check out [Controller Connector](/integrations/react/controller-connector) to set up gaming-optimized wallet functionality.*