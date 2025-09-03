# Torii Client Integration Guide

Learn how to consume Torii data from your React application using GraphQL queries and custom hooks. This guide provides practical examples for fetching game state, player data, and other onchain information efficiently from Dojo's Entity Component System (ECS) architecture.

## 🎯 Quick Start

### Prerequisites
- Torii indexer running with your deployed Dojo world
- React application with `@starknet-react/core` installed
- Deployed Cairo models and systems (e.g., Position, Moves models)

### Basic Setup

1. **Install dependencies**:
```bash
npm install @starknet-react/core
```

2. **Configure environment variables**:
```bash
# .env.local
VITE_TORII_URL=http://localhost:8080
VITE_WORLD_ADDRESS=0x1234567890abcdef...
```

3. **Update dojoConfig**:
```typescript
// src/dojo/dojoConfig.ts
export const dojoConfig = createDojoConfig({
    manifest,
    toriiUrl: VITE_PUBLIC_TORII || '',
    // ... other config
});
```

4. **Create a basic hook**:
```typescript
// src/hooks/usePlayer.ts
import { useEffect, useState } from "react";
import { useAccount } from "@starknet-react/core";

export const usePlayer = () => {
  const [position, setPosition] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const { account } = useAccount();

  // Fetch data from Torii
  const fetchData = async () => {
    if (!account?.address) return;
    
    const response = await fetch(`${dojoConfig.toriiUrl}/graphql`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        query: `
          query GetPlayerPosition($playerOwner: ContractAddress!) {
            fullStarterReactPositionModels(where: { player: $playerOwner }) {
              edges {
                node {
                  player
                  x
                  y
                }
              }
            }
          }
        `,
        variables: { playerOwner: account.address }
      })
    });
    
    const result = await response.json();
    setPosition(result.data?.fullStarterReactPositionModels?.edges[0]?.node);
    setIsLoading(false);
  };

  useEffect(() => {
    fetchData();
  }, [account?.address]);

  return { position, isLoading, refetch: fetchData };
};
```

## 📚 Detailed Guides

For comprehensive implementation details, explore these focused guides:

### 🔧 **Setup & Configuration**
- **[Basic Setup](./guides/setup.md)** - Environment configuration and dependencies
- **[GraphQL Queries](./guides/graphql-queries.md)** - Query patterns and model structure

### 🎣 **Implementation Patterns**
- **[Custom Hooks](./guides/custom-hooks.md)** - Hook patterns and state management
- **[Data Conversion](./guides/data-conversion.md)** - Hex to number utilities and type handling
- **[Error Handling](./guides/error-handling.md)** - Error management and retry strategies

### ⚡ **Advanced Features**
- **[Performance Optimization](./guides/performance.md)** - Caching and optimization strategies
- **[Security Best Practices](./guides/security.md)** - Address validation and sanitization
- **[Testing Strategies](./guides/testing.md)** - Hook testing and validation

### 🚀 **Production Deployment**
- **[Production Patterns](./guides/production.md)** - Environment-specific configurations
- **[Common Patterns](./guides/common-patterns.md)** - Multiple model queries and leaderboards

## 🎮 Quick Examples

### Basic Component Usage
```typescript
import { usePlayer } from '../hooks/usePlayer';

export const PlayerInfo = () => {
  const { position, isLoading, refetch } = usePlayer();

  if (isLoading) return <div>Loading...</div>;

  return (
    <div>
      <h2>Player Position</h2>
      {position && (
        <div>
          <p>X: {position.x}</p>
          <p>Y: {position.y}</p>
        </div>
      )}
      <button onClick={refetch}>Refresh</button>
    </div>
  );
};
```

### Data Conversion
```typescript
// Convert hex values from Cairo models
const hexToNumber = (hexValue) => {
  if (typeof hexValue === 'string' && hexValue.startsWith('0x')) {
    return parseInt(hexValue, 16);
  }
  return hexValue;
};

// Usage
const position = {
  ...rawPosition,
  x: hexToNumber(rawPosition.x),
  y: hexToNumber(rawPosition.y)
};
```

## 🔗 Additional Resources

- **[Dojo Game Starter](https://github.com/AkatsukiLabs/Dojo-Game-Starter)** - Complete working example
- **[Torii Documentation](https://github.com/dojoengine/torii)** - Official Torii docs
- **[React Integration Overview](../guides/react/overview.md)** - React-specific patterns
- **[Dojo Configuration](../guides/react/dojo-config.md)** - Setup details

## 🎯 Next Steps

1. **Start with [Basic Setup](./guides/setup.md)** for configuration
2. **Learn [GraphQL Queries](./guides/graphql-queries.md)** for data fetching
3. **Implement [Custom Hooks](./guides/custom-hooks.md)** for state management
4. **Add [Error Handling](./guides/error-handling.md)** for reliability
5. **Optimize with [Performance](./guides/performance.md)** for production

---

**Need help?** Check out the [Common Issues](./guides/common-patterns.md#common-issues) section or explore the detailed guides above.
