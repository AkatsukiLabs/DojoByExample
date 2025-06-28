# React Integration - Contracts Bindings

The `contracts.gen.ts` file is the heart of Dojo's React integration, providing auto-generated TypeScript bindings that seamlessly connect your React frontend to Cairo smart contracts. This file bridges the gap between blockchain logic and user interface, enabling type-safe contract interactions without manual boilerplate code.

## 🔄 Auto-Generation Process

The `contracts.gen.ts` file is automatically generated from your deployed Dojo contracts using the Dojo CLI. This process ensures that:

-   **Type Safety**: Every Cairo contract function has a corresponding TypeScript interface
-   **Automatic Updates**: Changes to your Cairo contracts automatically update the frontend bindings
-   **Consistency**: The generated code follows established patterns for reliability and maintainability

### Generation Workflow

```bash
# Deploy your contracts
sozo migrate

# Generate TypeScript bindings
sozo codegen
```

This creates the `contracts.gen.ts` file with all the necessary functions and types for your React application.

## 📦 File Structure and Imports

The generated file starts with essential imports that provide the foundation for contract interactions:

```typescript
import { DojoProvider, DojoCall } from "@dojoengine/core";
import { Account, AccountInterface } from "starknet";
```

### Core Dependencies Explained

**`DojoProvider`**: The main interface for executing contract calls and managing Dojo world interactions. It handles the communication layer between your React app and the blockchain.

**`DojoCall`**: A structured interface that defines how contract calls are formatted:

```typescript
interface DojoCall {
    contractName: string; // Contract identifier from deployment
    entrypoint: string; // Function name in the Cairo contract
    calldata: any[]; // Parameters array for the contract call
}
```

**`Account` & `AccountInterface`**: Starknet account types that represent the user's wallet for transaction signing and execution.

## 🏗️ setupWorld Function Architecture

The `setupWorld` function is the main export that organizes all contract functions into a structured, namespace-based API:

```typescript
export function setupWorld(provider: DojoProvider) {
    // Contract function implementations
    return {
        game: {
            mine: game_mine,
            buildMineCalldata: build_game_mine_calldata,
            rest: game_rest,
            buildRestCalldata: build_game_rest_calldata,
            spawnPlayer: game_spawnPlayer,
            buildSpawnPlayerCalldata: build_game_spawnPlayer_calldata,
            train: game_train,
            buildTrainCalldata: build_game_train_calldata,
        },
    };
}
```

### Architecture Benefits

-   **Provider Injection**: The `DojoProvider` parameter enables dependency injection for testing and configuration flexibility
-   **Namespace Organization**: Functions are grouped by contract (e.g., `game`) for clear organization
-   **Dual Function Pattern**: Each contract function has both an execution function and a calldata builder

## 🔧 Calldata Builder Pattern

Each contract function has a corresponding calldata builder that creates the structured call data needed for contract execution:

```typescript
const build_game_mine_calldata = (): DojoCall => {
    return {
        contractName: "game",
        entrypoint: "mine",
        calldata: [],
    };
};
```

### Calldata Builder Benefits

-   **Separation of Concerns**: Calldata creation is separated from execution logic
-   **Reusability**: Calldata can be built once and used multiple times
-   **Testing**: Easy to unit test calldata generation independently
-   **Flexibility**: Can be used for transaction simulation or batch operations

### Naming Convention

The naming follows a consistent pattern:

-   `build_{contract}_{function}_calldata`
-   Example: `build_game_mine_calldata` for the `mine` function in the `game` contract

## ⚡ Contract Execution Methods

Each contract function has an async execution method that handles the actual blockchain interaction:

```typescript
const game_mine = async (snAccount: Account | AccountInterface) => {
    try {
        return await provider.execute(
            snAccount as any,
            build_game_mine_calldata(),
            "full_starter_react"
        );
    } catch (error) {
        console.error(error);
        throw error;
    }
};
```

### Execution Method Components

**`snAccount`**: The user's Starknet account for transaction signing and execution. Supports both `Account` and `AccountInterface` types for flexibility.

**`provider.execute()`**: The core execution method with three parameters:

-   `account`: The user's account for transaction signing
-   `calldata`: The `DojoCall` object with contract details
-   `namespace`: The Dojo world namespace identifier (e.g., "full_starter_react")

**Error Handling**: Comprehensive try-catch blocks ensure graceful error handling and debugging.

## 🎮 Game Functions Documentation

The generated file includes four core game functions, each with specific game mechanics:

### 1. `mine` - Resource Extraction

**Purpose**: Allows players to extract resources (coins) at the cost of health, implementing a risk/reward mechanic.

**Game Mechanics**:

-   Increases player coins
-   Decreases player health
-   Risk/reward balance for strategic gameplay

**Usage**:

```typescript
const world = setupWorld(provider);
await world.game.mine(account);
```

### 2. `rest` - Health Recovery

**Purpose**: Enables players to restore their health, supporting resource management gameplay.

**Game Mechanics**:

-   Restores player health
-   Resource management mechanic
-   Strategic timing for optimal gameplay

**Usage**:

```typescript
const world = setupWorld(provider);
await world.game.rest(account);
```

### 3. `spawnPlayer` - Player Initialization

**Purpose**: Creates a new player entity in the game world, handling the onboarding flow.

**Game Mechanics**:

-   Initializes new player with default stats
-   Sets up player state for gameplay
-   One-time initialization function

**Usage**:

```typescript
const world = setupWorld(provider);
await world.game.spawnPlayer(account);
```

### 4. `train` - Character Progression

**Purpose**: Increases player experience, enabling character progression and skill development.

**Game Mechanics**:

-   Increases player experience points
-   Character progression system
-   Long-term player engagement

**Usage**:

```typescript
const world = setupWorld(provider);
await world.game.train(account);
```

## 🔗 Integration with React Components

The generated bindings integrate seamlessly with React components through hooks and state management:

### Basic Usage Pattern

```typescript
import { setupWorld } from "../dojo/contracts.gen";
import { useAccount } from "@starknet-react/core";

function GameComponent() {
    const { account } = useAccount();
    const world = setupWorld(provider);

    const handleMine = async () => {
        if (!account) return;

        try {
            await world.game.mine(account);
            // Update UI state after successful transaction
        } catch (error) {
            console.error("Mining failed:", error);
        }
    };

    return <button onClick={handleMine}>Mine Resources</button>;
}
```

### Advanced Integration with State Management

```typescript
import { useState, useEffect } from "react";
import { setupWorld } from "../dojo/contracts.gen";

function GameManager() {
    const [isLoading, setIsLoading] = useState(false);
    const [playerStats, setPlayerStats] = useState(null);
    const world = setupWorld(provider);

    const executeGameAction = async (action: () => Promise<any>) => {
        setIsLoading(true);
        try {
            await action();
            // Refresh player stats after successful action
            await refreshPlayerStats();
        } catch (error) {
            console.error("Action failed:", error);
        } finally {
            setIsLoading(false);
        }
    };

    const handleMine = () => executeGameAction(() => world.game.mine(account));
    const handleRest = () => executeGameAction(() => world.game.rest(account));
    const handleTrain = () =>
        executeGameAction(() => world.game.train(account));

    return (
        <div>
            <button onClick={handleMine} disabled={isLoading}>
                {isLoading ? "Mining..." : "Mine"}
            </button>
            {/* Other game actions */}
        </div>
    );
}
```

## 🔧 Advanced Patterns and Customization

### Extending the setupWorld Function

You can extend the generated bindings with custom functionality:

```typescript
export function setupWorld(provider: DojoProvider) {
    const baseWorld = generatedSetupWorld(provider);

    return {
        ...baseWorld,
        game: {
            ...baseWorld.game,
            // Add custom game functions
            customAction: async (account: Account) => {
                // Custom implementation
            },
        },
        // Add new contract namespaces
        custom: {
            // Custom contract functions
        },
    };
}
```

### Batch Operations

Use calldata builders for complex transaction sequences:

```typescript
const executeBatchActions = async (account: Account) => {
    const calldata = [
        build_game_mine_calldata(),
        build_game_rest_calldata(),
        build_game_train_calldata(),
    ];

    // Execute as a single transaction
    return await provider.execute(account, calldata, "full_starter_react");
};
```

### Transaction Simulation

Use calldata builders for transaction simulation:

```typescript
const simulateMine = async (account: Account) => {
    const calldata = build_game_mine_calldata();

    // Simulate the transaction without executing
    return await provider.simulate(account, calldata, "full_starter_react");
};
```

## 🎯 Best Practices

### 1. Error Handling

Always implement comprehensive error handling for contract interactions:

```typescript
const safeExecute = async (action: () => Promise<any>) => {
    try {
        return await action();
    } catch (error) {
        if (error.message.includes("insufficient funds")) {
            // Handle specific error cases
            showInsufficientFundsMessage();
        } else {
            // Handle general errors
            showGenericErrorMessage();
        }
        throw error;
    }
};
```

### 2. Loading States

Implement proper loading states for better user experience:

```typescript
const [isExecuting, setIsExecuting] = useState(false);

const executeWithLoading = async (action: () => Promise<any>) => {
    setIsExecuting(true);
    try {
        await action();
    } finally {
        setIsExecuting(false);
    }
};
```

### 3. Transaction Confirmation

Wait for transaction confirmation before updating UI:

```typescript
const executeAndWait = async (action: () => Promise<any>) => {
    const result = await action();

    // Wait for transaction confirmation
    await provider.waitForTransaction(result.transaction_hash);

    // Update UI after confirmation
    refreshGameState();
};
```

## 🔄 Relationship with Cairo Contracts

The generated TypeScript functions directly correspond to Cairo contract entrypoints:

### Cairo Contract Example

```cairo
#[starknet::interface]
trait IGameActions {
    fn mine(self: @ContractState);
    fn rest(self: @ContractState);
    fn spawn_player(self: @ContractState);
    fn train(self: @ContractState);
}
```

### Generated TypeScript Mapping

```typescript
// Each Cairo function becomes a TypeScript function
const game_mine = async (snAccount: Account) => {
    /* ... */
};
const game_rest = async (snAccount: Account) => {
    /* ... */
};
const game_spawnPlayer = async (snAccount: Account) => {
    /* ... */
};
const game_train = async (snAccount: Account) => {
    /* ... */
};
```

This direct mapping ensures that changes to your Cairo contracts automatically update your frontend bindings, maintaining consistency across your entire application stack.

---

_The `contracts.gen.ts` file is your bridge to the blockchain, providing type-safe, auto-generated bindings that make building React applications with Dojo contracts seamless and reliable._
