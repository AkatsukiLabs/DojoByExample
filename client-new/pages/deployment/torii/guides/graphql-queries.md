# GraphQL Queries for Torii

Learn how to structure GraphQL queries to fetch Cairo model data from Torii's indexing service.

## 🔍 Query Structure Overview

Torii generates GraphQL queries based on your Cairo models. The naming convention follows: `full{WorldName}{ModelName}Models`.

### Basic Query Format

```graphql
query QueryName($variable: Type!) {
  fullWorldNameModelNameModels(where: { field: $variable }) {
    edges {
      node {
        field1
        field2
      }
    }
  }
}
```

## 📊 Cairo Model Query Examples

### Position Model Query

```graphql
# Query for Position model (Cairo struct with #[key] player field)
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
```

### Moves Model Query

```graphql
# Query for Moves model (Cairo struct with #[key] player field)
query GetPlayerMoves($playerOwner: ContractAddress!) {
  fullStarterReactMovesModels(where: { player: $playerOwner }) {
    edges {
      node {
        player
        remaining
      }
    }
  }
}
```

### Multiple Model Query

```graphql
# Query multiple Cairo models for a player
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
```

## 🎯 Advanced Query Patterns

### Leaderboard Query

```graphql
# Query top players by remaining moves
query GetTopPlayers {
  fullStarterReactMovesModels(
    first: 10,
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
```

### Filtered Query

```graphql
# Query players with specific conditions
query GetActivePlayers {
  fullStarterReactMovesModels(
    where: { remaining: { gt: "0" } },
    first: 50,
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
```

### Pagination Query

```graphql
# Query with pagination
query GetPlayersPage($first: Int!, $after: String) {
  fullStarterReactMovesModels(
    first: $first,
    after: $after,
    orderBy: "remaining",
    orderDirection: "desc"
  ) {
    edges {
      node {
        player
        remaining
      }
      cursor
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
  }
}
```

## 🔧 Query Variables

### Variable Types

```typescript
// Common variable types for Torii queries
interface QueryVariables {
  playerOwner: string;        // ContractAddress
  first: number;              // Int
  after: string;              // String (cursor)
  orderBy: string;            // String (field name)
  orderDirection: 'asc' | 'desc'; // String
}
```

### Using Variables

```typescript
// Example query with variables
const query = `
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

const variables = {
  playerOwner: account.address
};

const response = await fetch(TORII_URL, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ query, variables })
});
```

## 📋 Query Best Practices

### 1. Use Specific Field Selection

```graphql
# ✅ Good: Select only needed fields
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

# ❌ Avoid: Selecting all fields
query GetPlayerPosition($playerOwner: ContractAddress!) {
  fullStarterReactPositionModels(where: { player: $playerOwner }) {
    edges {
      node {
        # Don't select fields you don't need
      }
    }
  }
}
```

### 2. Use Pagination for Large Datasets

```graphql
# ✅ Good: Use pagination
query GetPlayers($first: Int!, $after: String) {
  fullStarterReactMovesModels(
    first: $first,
    after: $after
  ) {
    edges {
      node {
        player
        remaining
      }
      cursor
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

### 3. Use Filters to Reduce Data

```graphql
# ✅ Good: Use filters to get relevant data
query GetActivePlayers {
  fullStarterReactMovesModels(
    where: { remaining: { gt: "0" } },
    first: 20
  ) {
    edges {
      node {
        player
        remaining
      }
    }
  }
}
```

## 🛠️ Debugging Queries

### Schema Introspection

```graphql
# Get available models and fields
query IntrospectSchema {
  __schema {
    types {
      name
      fields {
        name
        type {
          name
        }
      }
    }
  }
}
```

### Model Discovery

```graphql
# Check if a specific model exists
query CheckModel {
  fullStarterReactPositionModels(first: 1) {
    edges {
      node {
        __typename
      }
    }
  }
}
```

### Error Handling

```typescript
// Handle GraphQL errors
const handleQueryError = (result: any) => {
  if (result.errors) {
    console.error('GraphQL Errors:', result.errors);
    throw new Error(result.errors[0].message);
  }
  return result.data;
};

// Usage
const response = await fetch(TORII_URL, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ query, variables })
});

const result = await response.json();
const data = handleQueryError(result);
```

## 🎯 Common Query Patterns

### Single Entity Query

```graphql
# Query a single entity by key
query GetPlayer($playerOwner: ContractAddress!) {
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
```

### List Query

```graphql
# Query multiple entities
query GetAllPlayers {
  fullStarterReactMovesModels(first: 100) {
    edges {
      node {
        player
        remaining
      }
    }
  }
}
```

### Aggregation Query

```graphql
# Query with aggregation (if supported)
query GetPlayerStats {
  fullStarterReactMovesModels {
    edges {
      node {
        remaining
      }
    }
  }
}
```

## 📚 Next Steps

1. **Learn custom hooks** in the [Custom Hooks](./custom-hooks.md) guide
2. **Handle data conversion** with the [Data Conversion](./data-conversion.md) guide
3. **Implement error handling** using the [Error Handling](./error-handling.md) guide

---

**Back to**: [Torii Client Integration](../client-integration.md) | **Next**: [Custom Hooks](./custom-hooks.md)
