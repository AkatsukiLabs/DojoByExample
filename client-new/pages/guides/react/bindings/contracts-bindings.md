# React Integration - Contracts Bindings

The **contracts.gen.ts** file is the auto-generated bridge between your Cairo game contracts and React frontend, providing type-safe TypeScript functions that execute game actions on the blockchain. This file transforms complex blockchain interactions into simple function calls that feel like traditional game mechanics, enabling developers to focus on gameplay rather than blockchain complexity.

## File Overview & Auto-Generation

The `contracts.gen.ts` file contains auto-generated TypeScript bindings that mirror your Cairo contract functions, providing a seamless interface for game actions. This file is automatically created and updated whenever you deploy your Dojo contracts, ensuring your frontend always stays synchronized with your game logic.

**Gaming Benefits**:

-   **Action-to-Function Mapping**: Every game action (train, mine, rest) becomes a simple TypeScript function call
-   **Type Safety**: Prevents errors by ensuring contract parameters match your game's requirements
-   **Automatic Updates**: Contract changes immediately reflect in your frontend without manual updates
-   **Game-First API**: Functions are organized by game mechanics rather than technical contract structure

**Auto-Generation Process**:

```bash
# Deploy contracts and generate bindings
sozo migrate
# TypeScript bindings automatically created in contracts.gen.ts
```

> **Gaming Philosophy**: This file eliminates the complexity barrier between game designers and blockchain, making onchain game development feel like traditional game programming.

## Complete Implementation

```typescript
import { DojoProvider, DojoCall } from "@dojoengine/core";
import { Account, AccountInterface } from "starknet";

export function setupWorld(provider: DojoProvider) {
    const build_game_mine_calldata = (): DojoCall => {
        return {
            contractName: "game",
            entrypoint: "mine",
            calldata: [],
        };
    };

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

    const build_game_rest_calldata = (): DojoCall => {
        return {
            contractName: "game",
            entrypoint: "rest",
            calldata: [],
        };
    };

    const game_rest = async (snAccount: Account | AccountInterface) => {
        try {
            return await provider.execute(
                snAccount as any,
                build_game_rest_calldata(),
                "full_starter_react"
            );
        } catch (error) {
            console.error(error);
            throw error;
        }
    };

    const build_game_spawnPlayer_calldata = (): DojoCall => {
        return {
            contractName: "game",
            entrypoint: "spawn_player",
            calldata: [],
        };
    };

    const game_spawnPlayer = async (snAccount: Account | AccountInterface) => {
        try {
            return await provider.execute(
                snAccount as any,
                build_game_spawnPlayer_calldata(),
                "full_starter_react"
            );
        } catch (error) {
            console.error(error);
            throw error;
        }
    };

    const build_game_train_calldata = (): DojoCall => {
        return {
            contractName: "game",
            entrypoint: "train",
            calldata: [],
        };
    };

    const game_train = async (snAccount: Account | AccountInterface) => {
        try {
            return await provider.execute(
                snAccount as any,
                build_game_train_calldata(),
                "full_starter_react"
            );
        } catch (error) {
            console.error(error);
            throw error;
        }
    };

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

## Imports and Core Dependencies

### Dojo Engine Core

```typescript
import { DojoProvider, DojoCall } from "@dojoengine/core";
```

**DojoProvider**: The main interface for executing game actions on the blockchain, handling all communication between your game and the Dojo world.

**DojoCall Interface**: Standardized structure for game action calls that ensures consistency and type safety:

```typescript
interface DojoCall {
    contractName: string; // Game contract identifier ("game")
    entrypoint: string; // Game action name ("mine", "train", etc.)
    calldata: any[]; // Action parameters (empty for basic actions)
}
```

**Gaming Context**: These imports provide the foundation for translating player actions into blockchain transactions seamlessly.

### Starknet Account Types

```typescript
import { Account, AccountInterface } from "starknet";
```

**Purpose**: Represents the player's wallet account for transaction signing and execution.

**Gaming Integration**: Enables players to execute game actions using their connected wallet while maintaining the gaming experience through session policies.

## setupWorld Function Architecture

### Main Function Structure

```typescript
export function setupWorld(provider: DojoProvider) {
    // Game action implementations
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

**Gaming Architecture Benefits**:

-   **Provider Injection**: Accepts DojoProvider for flexible configuration across different game environments
-   **Namespace Organization**: Groups functions by game contract for clear game logic separation
-   **Dual Function Pattern**: Each game action has both execution function and calldata builder for flexibility
-   **Consistent API**: All game actions follow the same pattern for predictable development experience

**Game Organization**: The returned object structure mirrors your game's logical organization, making it intuitive for game developers to find and use appropriate functions.

## Calldata Builder Pattern

### Builder Function Structure

```typescript
const build_game_mine_calldata = (): DojoCall => {
    return {
        contractName: "game",
        entrypoint: "mine",
        calldata: [],
    };
};
```

**Gaming Purpose**: Creates standardized call data for game actions, separating action definition from execution.

**DojoCall Structure Breakdown**:

-   `contractName: "game"`: Identifies the game contract containing the action
-   `entrypoint: "mine"`: Specifies the exact game action to execute
-   `calldata: []`: Parameters for the action (empty for basic game actions)

**Gaming Benefits**:

-   **Action Reusability**: Calldata can be built once and reused multiple times
-   **Game Testing**: Easy to test game action data without executing transactions
-   **Action Composition**: Can combine multiple game actions into sequences

**Naming Convention**: `build_game_{action}_calldata` pattern ensures consistent and discoverable function names.

## Contract Execution Methods

### Game Action Execution Pattern

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

**Gaming Execution Flow**:

1. **Player Action**: Player clicks "Mine" in game interface
2. **Account Validation**: Ensures player has connected wallet
3. **Action Building**: Creates DojoCall with game action data
4. **Blockchain Execution**: Executes action on game contract
5. **Result Handling**: Returns transaction result or throws error

**Method Parameters**:

-   `snAccount`: Player's connected wallet account for signing game transactions
-   `build_game_mine_calldata()`: Pre-built action data for the mining action
-   `"full_starter_react"`: Dojo world namespace identifier for your game

**Gaming Error Handling**: Comprehensive try-catch ensures game doesn't crash on failed actions, allowing for graceful error recovery and player feedback.

## Game Functions Documentation

### 1. `mine` - Resource Extraction Mechanic

```typescript
const game_mine = async (snAccount: Account | AccountInterface) => {
    /* ... */
};
```

**Game Mechanics**: Risk/reward mining system where players extract coins but lose health.

**Gaming Strategy**: Players must balance coin earning with health management, creating strategic decision-making.

**Player Impact**:

-   ⬆️ Increases player coins (resource gain)
-   ⬇️ Decreases player health (risk cost)

### 2. `rest` - Health Recovery System

```typescript
const game_rest = async (snAccount: Account | AccountInterface) => {
    /* ... */
};
```

**Game Mechanics**: Allows players to recover health, supporting resource management gameplay.

**Gaming Strategy**: Essential for maintaining character viability after risky actions like mining.

**Player Impact**:

-   ⬆️ Restores player health (recovery)
-   🛡️ Enables continued gameplay

### 3. `spawnPlayer` - Character Initialization

```typescript
const game_spawnPlayer = async (snAccount: Account | AccountInterface) => {
    /* ... */
};
```

**Game Mechanics**: Creates a new player character in the game world with starting statistics.

**Gaming Onboarding**: First action new players take to begin their gaming journey.

**Player Impact**:

-   🎮 Creates player character with default stats
-   🚀 Enables access to all other game functions

### 4. `train` - Character Progression

```typescript
const game_train = async (snAccount: Account | AccountInterface) => {
    /* ... */
};
```

**Game Mechanics**: Increases player experience, enabling character development and progression.

**Gaming Progression**: Core mechanic for long-term player engagement and character building.

**Player Impact**:

-   ⬆️ Increases experience points (character growth)
-   📈 Enables progression-based gameplay

## Relationship with Cairo Game Contracts

### Cairo Contract Functions

```cairo
// Cairo game contract functions
#[starknet::interface]
trait IGameActions {
    fn mine(self: @ContractState);
    fn rest(self: @ContractState);
    fn spawn_player(self: @ContractState);
    fn train(self: @ContractState);
}
```

### TypeScript Mapping

```typescript
// Auto-generated TypeScript functions
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

**Gaming Synchronization**: Direct 1:1 mapping ensures that changes to your Cairo game logic automatically update your frontend functions, maintaining consistency across your entire game stack.

**Developer Experience**: Game designers can modify Cairo contracts and immediately see those changes reflected in the TypeScript API without manual updates.

---

*The contracts.gen.ts file transforms complex blockchain transactions into simple game function calls, enabling developers to build engaging fully on-chain games with traditional gaming development patterns.*
