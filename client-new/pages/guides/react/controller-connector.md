# Controller Connector

The `cartridgeConnector.tsx` file configures the Cartridge Controller integration for your Dojo game. This connector enables seamless wallet functionality specifically designed for gaming, eliminating transaction popups and providing session-based authentication that keeps players focused on gameplay rather than blockchain complexity.

## File Overview & Purpose

The `cartridgeConnector.tsx` file creates and configures a Cartridge Controller connector that serves as the bridge between your game interface and player wallets. Unlike traditional DeFi wallet connectors, this configuration prioritizes gaming user experience through:

- **Session-Based Authentication**: Pre-approved game actions that don't require individual transaction confirmations.
- **Multi-Environment Support**: Automatic network switching between localhost, sepolia, and mainnet.
- **Dynamic Contract Resolution**: Automatically resolves contract addresses from your Dojo manifest.
- **Gaming-Optimized RPC**: Uses Cartridge's gaming-focused endpoints for better performance.

This connector transforms blockchain interactions from a technical hurdle into a seamless gaming experience, allowing players to focus on strategy and fun rather than transaction management.

## Complete Implementation

```typescript
import { Connector } from "@starknet-react/core";
import { ControllerConnector } from "@cartridge/connector";
import { ControllerOptions } from "@cartridge/controller";
import { constants } from "starknet";
import { manifest } from "./manifest";

const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;

console.log("VITE_PUBLIC_DEPLOY_TYPE", VITE_PUBLIC_DEPLOY_TYPE);

const getRpcUrl = () => {
  switch (VITE_PUBLIC_DEPLOY_TYPE) {
    case "localhost":
      return "http://localhost:5050"; // Katana localhost default port
    case "mainnet":
      return "https://api.cartridge.gg/x/starknet/mainnet";
    case "sepolia":
      return "https://api.cartridge.gg/x/starknet/sepolia";
    default:
      return "https://api.cartridge.gg/x/starknet/sepolia";
  }
};

const getDefaultChainId = () => {
  switch (VITE_PUBLIC_DEPLOY_TYPE) {
    case "localhost":
      return "0x4b4154414e41"; // KATANA in ASCII
    case "mainnet":
      return constants.StarknetChainId.SN_MAIN;
    case "sepolia":
      return constants.StarknetChainId.SN_SEPOLIA;
    default:
      return constants.StarknetChainId.SN_SEPOLIA;
  }
};

const getGameContractAddress = () => {
  return manifest.contracts[0].address;
};

const CONTRACT_ADDRESS_GAME = getGameContractAddress();
console.log("Using game contract address:", CONTRACT_ADDRESS_GAME);

const policies = {
  contracts: {
    [CONTRACT_ADDRESS_GAME]: {
      methods: [
        { name: "spawn_player", entrypoint: "spawn_player" },
        { name: "train", entrypoint: "train" },
        { name: "mine", entrypoint: "mine" },
        { name: "rest", entrypoint: "rest" },
      ],
    },
  },
};

const options: ControllerOptions = {
  chains: [{ rpcUrl: getRpcUrl() }],
  defaultChainId: getDefaultChainId(),
  policies,
  namespace: "full_starter_react",
  slot: "full-starter-react",
};

const cartridgeConnector = new ControllerConnector(
  options
) as never as Connector;

export default cartridgeConnector;
```

## Imports and Dependencies

### Starknet React Integration

```typescript
import { Connector } from "@starknet-react/core";
```

- **Purpose**: Base interface that allows the Cartridge Controller to integrate seamlessly with Starknet React's provider system.

### Cartridge Controller Core

```typescript
import { ControllerConnector } from "@cartridge/connector";
import { ControllerOptions } from "@cartridge/controller";
```

- **Components**:
  - **ControllerConnector**: The main connector class that implements gaming-optimized wallet functionality.
  - **ControllerOptions**: TypeScript interface for connector configuration.
- **Gaming Benefits**: These imports provide session management, transaction batching, and user-friendly interfaces designed specifically for gaming applications.

### Starknet Constants

```typescript
import { constants } from "starknet";
```

- **Purpose**: Provides standardized chain identifiers for different Starknet networks.
- **Usage**: Ensures consistent network identification across localhost (Katana), sepolia testnet, and mainnet deployments.

### Dojo Manifest Integration

```typescript
import { manifest } from "./manifest";
```

- **Purpose**: Imports your Dojo deployment manifest containing contract addresses and metadata.
- **Gaming Advantage**: Eliminates hardcoded addresses, allowing seamless deployment across different networks without code changes.

## Environment Configuration

### Environment Detection

```typescript
const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;
console.log("VITE_PUBLIC_DEPLOY_TYPE", VITE_PUBLIC_DEPLOY_TYPE);
```

- **Gaming Deployment Strategy**:
  - **localhost**: Rapid development with local Katana node.
  - **sepolia**: Safe testing with real network conditions.
  - **mainnet**: Production environment with real player assets.
- **Developer Experience**: The `console.log` helps debug deployment configuration during development.

### RPC Provider Configuration

```typescript
const getRpcUrl = () => {
  switch (VITE_PUBLIC_DEPLOY_TYPE) {
    case "localhost":
      return "http://localhost:5050"; // Katana localhost default port
    case "mainnet":
      return "https://api.cartridge.gg/x/starknet/mainnet";
    case "sepolia":
      return "https://api.cartridge.gg/x/starknet/sepolia";
    default:
      return "https://api.cartridge.gg/x/starknet/sepolia";
  }
};
```

- **Network-Specific Configuration**:

| Environment | Endpoint                                    | Gaming Purpose                                 |
| ----------- | ------------------------------------------- | ---------------------------------------------- |
| localhost   | http://localhost:5050                       | Local Katana for rapid development and testing |
| mainnet     | https://api.cartridge.gg/x/starknet/mainnet | Production gaming with real assets             |
| sepolia     | https://api.cartridge.gg/x/starknet/sepolia | Safe testing environment                       |
| default     | Sepolia fallback                            | Prevents accidental mainnet usage              |

- **Why Cartridge RPC Endpoints?**:
  - **Gaming Optimization**: Endpoints tuned for gaming transaction patterns and session management.
  - **Reliability**: High uptime crucial for uninterrupted gaming experiences.
  - **Performance**: Reduced latency for real-time game interactions.

### Chain ID Configuration

```typescript
const getDefaultChainId = () => {
  switch (VITE_PUBLIC_DEPLOY_TYPE) {
    case "localhost":
      return "0x4b4154414e41"; // KATANA in ASCII
    case "mainnet":
      return constants.StarknetChainId.SN_MAIN;
    case "sepolia":
      return constants.StarknetChainId.SN_SEPOLIA;
    default:
      return constants.StarknetChainId.SN_SEPOLIA;
  }
};
```

- **Chain ID Mapping**:

  - **localhost**: "0x4b4154414e41" (ASCII encoding of "KATANA").
  - **mainnet**: `constants.StarknetChainId.SN_MAIN` (Official Starknet mainnet ID).
  - **sepolia**: `constants.StarknetChainId.SN_SEPOLIA` (Official Starknet testnet ID).

- **Gaming Benefits**: Automatic chain selection ensures players connect to the correct network without manual configuration, maintaining the seamless experience expected in modern games.

## Contract Address Resolution

### Dynamic Address Resolution

```typescript
const getGameContractAddress = () => {
  return manifest.contracts[0].address;
};

const CONTRACT_ADDRESS_GAME = getGameContractAddress();
console.log("Using game contract address:", CONTRACT_ADDRESS_GAME);
```

- **Manifest Integration Benefits**:

  - **Deployment Flexibility**: Contract addresses automatically update when deploying to different networks.
  - **No Hardcoding**: Eliminates the need to manually update addresses in code.
  - **Environment Safety**: Prevents using wrong contract addresses across different deployments.

- **Gaming Context**: Players interact with the correct game contract regardless of whether they're on localhost development, sepolia testing, or mainnet production.

## Session Policies Configuration

### Gaming-Focused Session Policies

```typescript
const policies = {
  contracts: {
    [CONTRACT_ADDRESS_GAME]: {
      methods: [
        { name: "spawn_player", entrypoint: "spawn_player" },
        { name: "train", entrypoint: "train" },
        { name: "mine", entrypoint: "mine" },
        { name: "rest", entrypoint: "rest" },
      ],
    },
  },
};
```

- **What Are Session Policies?**: Session policies define which contract methods players can execute without individual transaction approval popups. This creates a traditional gaming experience where actions happen immediately.

- **Gaming UX Benefits**:

  - **No Transaction Interruptions**: Players can train, mine, and rest without constant wallet popups.
  - **Seamless Gameplay Flow**: Actions execute immediately, maintaining game immersion.
  - **Traditional Game Feel**: Blockchain interactions become invisible to players.

- **Method Breakdown**:

  - **spawn_player**: Create new player character (one-time setup).
  - **train**: Improve player experience and skills.
  - **mine**: Earn in-game currency with resource gathering.
  - **rest**: Restore player health and energy.

- **Adding New Game Actions**:

```typescript
// To add new methods to session policies:
{ name: "craft_item", entrypoint: "craft_item" },
{ name: "battle_monster", entrypoint: "battle_monster" },
```

## Controller Options Configuration

### Complete Options Setup

```typescript
const options: ControllerOptions = {
  chains: [{ rpcUrl: getRpcUrl() }],
  defaultChainId: getDefaultChainId(),
  policies,
  namespace: "full_starter_react",
  slot: "full-starter-react",
};
```

- **Option Properties Breakdown**:

  - **chains**: `[{ rpcUrl: getRpcUrl() }]`

    - **Purpose**: Defines available blockchain networks with their RPC endpoints.
    - **Gaming Implementation**: Automatically configures the appropriate network based on deployment environment, ensuring players connect to the correct game instance.

  - **defaultChainId**: `getDefaultChainId()`

    - **Purpose**: Sets the primary network for wallet connections.
    - **Gaming Benefit**: Players automatically connect to the intended game network without manual network switching.

  - **policies**

    - **Purpose**: Defines pre-approved contract methods for seamless execution.
    - **Gaming Impact**: Transforms blockchain interactions from technical obstacles into smooth gaming actions.

  - **namespace**: `"full_starter_react"`

    - **Purpose**: Unique identifier for your game application within the Cartridge ecosystem.
    - **Requirements**: Must match your registered Cartridge application namespace for proper session management and policies.

  - **slot**: `"full-starter-react"`
    - **Purpose**: Specific session identifier for isolating different game instances or versions.
    - **Gaming Use Cases**: Allows running multiple game versions or environments with separate session policies.

## Connector Instantiation

### TypeScript Integration

```typescript
const cartridgeConnector = new ControllerConnector(
  options
) as never as Connector;
```

- **Technical Explanation**: The `as never as Connector` casting ensures TypeScript compatibility between Cartridge's `ControllerConnector` and Starknet React's `Connector` interface.
- **Why This Casting?**: Different package versions may have slight interface differences, and this casting guarantees compatibility while maintaining full functionality.
- **Gaming Result**: Your game can use standard Starknet React hooks while benefiting from Cartridge's gaming-specific features.

## Integration with StarknetProvider

### Provider Usage

```jsx
// In your StarknetProvider configuration
<StarknetConfig
  connectors={[cartridgeConnector]}
  // ... other props
>
  {children}
</StarknetConfig>
```

- **Gaming Flow**: The connector integrates seamlessly with your StarknetProvider, enabling gaming-optimized wallet functionality throughout your application.

## Environment Setup Examples

### Development Configuration

```plaintext
# .env.development
VITE_PUBLIC_DEPLOY_TYPE=localhost
```

### Testing Configuration

```plaintext
# .env.staging
VITE_PUBLIC_DEPLOY_TYPE=sepolia
```

### Production Configuration

```plaintext
# .env.production
VITE_PUBLIC_DEPLOY_TYPE=mainnet
```

# Gaming Benefits Summary

## For Players:

- **No Transaction Popups**: Enjoy uninterrupted gameplay without transaction confirmation popups.
- **Automatic Network Connection**: Seamlessly connect to the correct game environment based on your deployment.
- **Traditional Gaming Experience**: Experience the benefits of blockchain technology while enjoying a familiar gaming interface.

## For Developers:

- **Environment-Based Deployment**: Deploy your game across different environments without needing to change the code.
- **Dynamic Contract Address Resolution**: Automatically resolve contract addresses from the manifest, eliminating hardcoded values.
- **Gaming-Optimized RPC Endpoints**: Benefit from RPC endpoints designed specifically for gaming, ensuring better performance.

## For Game Operations:

- **Session-Based Policies**: Reduce player friction by allowing pre-approved actions without constant confirmations.
- **Automatic Environment Detection**: Prevent deployment errors with automatic detection of the current environment.
- **Reliable Performance**: Leverage Cartridge's gaming infrastructure to ensure consistent and reliable game performance.
