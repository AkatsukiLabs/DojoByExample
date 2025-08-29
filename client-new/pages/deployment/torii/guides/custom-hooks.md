# Custom Hooks for Torii

Learn how to create custom React hooks for fetching and managing Cairo model data from Torii.

## 🎣 Basic Hook Structure

### Simple Hook Example

```typescript
// src/hooks/usePlayer.ts
import { useEffect, useState } from "react";
import { useAccount } from "@starknet-react/core";
import { dojoConfig } from "../dojo/dojoConfig";

const TORII_URL = dojoConfig.toriiUrl + "/graphql";

const POSITION_QUERY = `
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
`;

export const usePlayer = () => {
  const [position, setPosition] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { account } = useAccount();

  const fetchData = async () => {
    if (!account?.address) {
      setIsLoading(false);
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch(TORII_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          query: POSITION_QUERY,
          variables: { playerOwner: account.address }
        })
      });

      const result = await response.json();
      const positionData = result.data?.fullStarterReactPositionModels?.edges[0]?.node;
      setPosition(positionData);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [account?.address]);

  const refetch = () => {
    fetchData();
  };

  return { position, isLoading, error, refetch };
};
```

## 🔄 Multiple Model Hook

### Hook for Multiple Models

```typescript
// src/hooks/usePlayerState.ts
import { useEffect, useState } from "react";
import { useAccount } from "@starknet-react/core";

const PLAYER_STATE_QUERY = `
  query GetPlayerState($playerOwner: ContractAddress!) {
    position: fullStarterReactPositionModels(where: { player: $playerOwner }) {
      edges {
        node {
          player
          x
          y
        }
      }
    }
    moves: fullStarterReactMovesModels(where: { player: $playerOwner }) {
      edges {
        node {
          player
          remaining
        }
      }
    }
  }
`;

export const usePlayerState = () => {
  const [playerState, setPlayerState] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { account } = useAccount();

  const fetchPlayerState = async () => {
    if (!account?.address) {
      setIsLoading(false);
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch(TORII_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          query: PLAYER_STATE_QUERY,
          variables: { playerOwner: account.address }
        })
      });

      const result = await response.json();
      setPlayerState(result.data);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchPlayerState();
  }, [account?.address]);

  return { playerState, isLoading, error, refetch: fetchPlayerState };
};
```

## 🎯 Enhanced Hook with Data Conversion

### Hook with Hex Conversion

```typescript
// src/hooks/usePlayerEnhanced.ts
import { useEffect, useState } from "react";
import { useAccount } from "@starknet-react/core";

// Data conversion utilities
const hexToNumber = (hexValue: string | number) => {
  if (typeof hexValue === 'string' && hexValue.startsWith('0x')) {
    return parseInt(hexValue, 16);
  }
  return Number(hexValue);
};

const formatAddress = (address: string) => {
  return address.toLowerCase();
};

export const usePlayerEnhanced = () => {
  const [position, setPosition] = useState(null);
  const [moves, setMoves] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { account } = useAccount();

  const fetchData = async () => {
    if (!account?.address) {
      setIsLoading(false);
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      const [positionData, movesData] = await Promise.all([
        fetchPlayerPosition(account.address),
        fetchPlayerMoves(account.address)
      ]);

      // Convert hex values to numbers
      if (positionData) {
        setPosition({
          ...positionData,
          x: hexToNumber(positionData.x),
          y: hexToNumber(positionData.y),
          player: formatAddress(positionData.player)
        });
      }

      if (movesData) {
        setMoves({
          ...movesData,
          remaining: hexToNumber(movesData.remaining),
          player: formatAddress(movesData.player)
        });
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [account?.address]);

  const refetch = () => {
    fetchData();
  };

  return { position, moves, isLoading, error, refetch };
};
```

## 📊 List Hook Pattern

### Hook for Lists and Leaderboards

```typescript
// src/hooks/useLeaderboard.ts
import { useEffect, useState } from "react";

const LEADERBOARD_QUERY = `
  query GetTopPlayers($limit: Int!) {
    fullStarterReactMovesModels(
      first: $limit,
      orderBy: "remaining",
      orderDirection: "desc"
    ) {
      edges {
        node {
          player
          remaining
        }
      }
    }
  }
`;

export const useLeaderboard = (limit: number = 10) => {
  const [players, setPlayers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchLeaderboard = async () => {
    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch(TORII_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          query: LEADERBOARD_QUERY,
          variables: { limit }
        })
      });

      const result = await response.json();
      const playersData = result.data?.fullStarterReactMovesModels?.edges || [];
      
      // Convert hex values
      const convertedPlayers = playersData.map(({ node }: any) => ({
        ...node,
        remaining: hexToNumber(node.remaining),
        player: formatAddress(node.player)
      }));

      setPlayers(convertedPlayers);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchLeaderboard();
  }, [limit]);

  return { players, isLoading, error, refetch: fetchLeaderboard };
};
```

## 🔄 Auto-Refetch Hook

### Hook with Auto-Refetch on Changes

```typescript
// src/hooks/usePlayerAutoRefetch.ts
import { useEffect, useState, useCallback } from "react";
import { useAccount } from "@starknet-react/core";

export const usePlayerAutoRefetch = (refetchInterval: number = 5000) => {
  const [position, setPosition] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { account } = useAccount();

  const fetchData = useCallback(async () => {
    if (!account?.address) {
      setIsLoading(false);
      return;
    }

    try {
      const response = await fetch(TORII_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          query: POSITION_QUERY,
          variables: { playerOwner: account.address }
        })
      });

      const result = await response.json();
      const newPosition = result.data?.fullStarterReactPositionModels?.edges[0]?.node;
      
      // Only update if data has changed
      if (JSON.stringify(newPosition) !== JSON.stringify(position)) {
        setPosition(newPosition);
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }, [account?.address, position]);

  // Initial fetch
  useEffect(() => {
    fetchData();
  }, [fetchData]);

  // Auto-refetch on interval
  useEffect(() => {
    if (!account?.address) return;

    const interval = setInterval(fetchData, refetchInterval);
    return () => clearInterval(interval);
  }, [fetchData, refetchInterval, account?.address]);

  return { position, isLoading, error, refetch: fetchData };
};
```

## 🎮 Component Usage Examples

### Basic Component

```typescript
// src/components/PlayerInfo.tsx
import React from 'react';
import { usePlayer } from '../hooks/usePlayer';

export const PlayerInfo: React.FC = () => {
  const { position, isLoading, error, refetch } = usePlayer();

  if (isLoading) {
    return <div>Loading player data...</div>;
  }

  if (error) {
    return (
      <div>
        <p>Error: {error}</p>
        <button onClick={refetch}>Retry</button>
      </div>
    );
  }

  return (
    <div>
      <h2>Player Information</h2>
      {position && (
        <div>
          <h3>Position</h3>
          <p>X: {position.x}</p>
          <p>Y: {position.y}</p>
        </div>
      )}
      <button onClick={refetch}>Refresh Data</button>
    </div>
  );
};
```

### Enhanced Component

```typescript
// src/components/PlayerInfoEnhanced.tsx
import React from 'react';
import { usePlayerEnhanced } from '../hooks/usePlayerEnhanced';

export const PlayerInfoEnhanced: React.FC = () => {
  const { position, moves, isLoading, error, refetch } = usePlayerEnhanced();

  if (isLoading) {
    return <div>Loading player data...</div>;
  }

  if (error) {
    return (
      <div>
        <p>Error: {error}</p>
        <button onClick={refetch}>Retry</button>
      </div>
    );
  }

  return (
    <div>
      <h2>Player Information</h2>
      {position && (
        <div>
          <h3>Position</h3>
          <p>X: {position.x} (converted from hex)</p>
          <p>Y: {position.y} (converted from hex)</p>
        </div>
      )}
      {moves && (
        <div>
          <h3>Moves</h3>
          <p>Remaining: {moves.remaining} (converted from hex)</p>
        </div>
      )}
      <button onClick={refetch}>Refresh Data</button>
    </div>
  );
};
```

## 📋 Hook Best Practices

### 1. Use useCallback for Fetch Functions

```typescript
const fetchData = useCallback(async () => {
  // ... fetch logic
}, [account?.address]); // Include dependencies
```

### 2. Handle Loading States Properly

```typescript
const [isLoading, setIsLoading] = useState(true);
const [error, setError] = useState(null);

// Always set loading to false in finally block
try {
  // ... fetch logic
} catch (err) {
  setError(err.message);
} finally {
  setIsLoading(false);
}
```

### 3. Provide Refetch Function

```typescript
const refetch = () => {
  fetchData();
};

return { data, isLoading, error, refetch };
```

### 4. Use Proper Dependencies

```typescript
useEffect(() => {
  fetchData();
}, [account?.address]); // Only depend on what you actually use
```

## 🎯 Hook Patterns Summary

| Pattern | Use Case | Example |
|---------|----------|---------|
| **Basic Hook** | Simple data fetching | `usePlayer()` |
| **Multiple Model** | Complex state | `usePlayerState()` |
| **Enhanced Hook** | With data conversion | `usePlayerEnhanced()` |
| **List Hook** | Collections and lists | `useLeaderboard()` |
| **Auto-Refetch** | Real-time updates | `usePlayerAutoRefetch()` |

## 📚 Next Steps

1. **Learn data conversion** in the [Data Conversion](./data-conversion.md) guide
2. **Implement error handling** using the [Error Handling](./error-handling.md) guide
3. **Optimize performance** with the [Performance](./performance.md) guide

---

**Back to**: [Torii Client Integration](../client-integration.md) | **Next**: [Data Conversion](./data-conversion.md)
