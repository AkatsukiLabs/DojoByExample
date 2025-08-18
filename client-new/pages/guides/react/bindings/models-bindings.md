# React Integration - Models Bindings

The **bindings.ts** file contains auto-generated TypeScript interfaces that mirror your Cairo game models, providing type-safe access to player data, achievements, and game entities from your React components. This file serves as the crucial bridge between your onchain game logic and frontend interface, ensuring that your game's data structures remain synchronized and type-safe across the entire application.

## File Overview & Auto-Generation

The `bindings.ts` file is automatically generated from your Cairo model definitions using the Dojo toolchain, creating TypeScript interfaces that exactly match your onchain game structures. This auto-generation process ensures that your frontend always stays synchronized with your smart contract models without manual type maintenance.

**Gaming Benefits**:
- **Type Safety**: Prevents runtime errors when accessing player stats, achievements, and game data
- **Automatic Synchronization**: Model changes in Cairo automatically update frontend types
- **Developer Experience**: IntelliSense and autocomplete for all game data structures
- **Gaming-First Design**: Interfaces designed specifically for game entities like players, achievements, and progression systems

**Auto-Generation Workflow**:
```bash
# After modifying Cairo models and deploying
sozo build —typescript
# TypeScript interfaces automatically updated in bindings.ts
```

> **Gaming Philosophy**: This file eliminates the friction between game logic design and frontend implementation, allowing game developers to focus on gameplay mechanics rather than type synchronization.

## Complete Implementation

You can see a complete bindings file here in our [Dojo Game Starter](https://github.com/AkatsukiLabs/Dojo-Game-Starter/blob/main/client/src/dojo/bindings.ts)

Let's explain each part:

## Import and Core Types

### Dojo SDK Schema Integration
```typescript
import type { SchemaType as ISchemaType } from "@dojoengine/sdk";
```

**Purpose**: Imports the base schema type from Dojo SDK that provides the foundation for all model type definitions.

**Gaming Integration**: This import ensures your game models integrate seamlessly with Dojo's entity system, enabling efficient querying and state management for game data.

**Type Safety**: Provides the base structure that all your game model types extend, ensuring consistency across your entire game data layer.

## Player Model Interfaces

### Main Player Interface
```typescript
export interface Player {
	owner: string;
	experience: number;
	health: number;
	coins: number;
	creation_day: number;
}
```

**Gaming Purpose**: Represents a complete player entity in your game with all identifying and gameplay-related information.

**Field Breakdown**:
- `owner: string`: Player's wallet address - unique identifier linking blockchain account to game character
- `experience: number`: Player's accumulated experience points for progression and leveling systems
- `health: number`: Current player health status affecting ability to perform risky actions like mining
- `coins: number`: Player's in-game currency for purchasing items, upgrades, or game actions
- `creation_day: number`: Timestamp when player character was created for tracking player tenure

**Cairo Mapping**: Directly corresponds to the `Player` struct in `full_starter_react::models::player::Player`.

### Player Value Interface
```typescript
export interface PlayerValue {
	experience: number;
	health: number;
	coins: number;
	creation_day: number;
}
```

**Gaming Purpose**: Represents player data without the owner identifier, used for operations that only need the game stats.

**Key Difference**: Missing `owner` field makes this interface ideal for:
- Displaying player stats in UI components
- Calculating stat changes before applying them
- Comparing player statistics across different players

**Usage Pattern**: Often used in combination with separate owner/address tracking for efficient data handling.

## Achievement System Interfaces

### Trophy Creation Interface
```typescript
export interface TrophyCreation {
	id: number;
	hidden: boolean;
	index: number;
	points: number;
	start: number;
	end: number;
	group: number;
	icon: number;
	title: number;
	description: string;
	tasks: Array<Task>;
	data: string;
}
```

**Gaming Purpose**: Defines the complete structure for creating achievements and trophies in your game.

**Achievement System Fields**:
- `id: number`: Unique identifier for the trophy/achievement
- `hidden: boolean`: Whether achievement is visible to players before completion (secret achievements)
- `index: number`: Display order or category placement for achievement organization
- `points: number`: Score value awarded to players for completing this achievement
- `start: number`: Timestamp when achievement becomes available to players
- `end: number`: Expiration timestamp for time-limited achievements
- `group: number`: Achievement category or group classification
- `icon: number`: Icon identifier for visual representation in achievement galleries
- `title: number`: Title identifier for localized achievement names
- `description: string`: Human-readable description of achievement requirements
- `tasks: Array<Task>`: List of tasks required to complete the achievement
- `data: string`: Additional metadata or configuration data for complex achievements

### Trophy Creation Value Interface
```typescript
export interface TrophyCreationValue {
	hidden: boolean;
	index: number;
	points: number;
	start: number;
	end: number;
	group: number;
	icon: number;
	title: number;
	description: string;
	tasks: Array<Task>;
	data: string;
}
```

**Gaming Purpose**: Trophy data without the ID field, used for achievement creation and modification operations.

**Usage**: Perfect for achievement editors, admin panels, or dynamic achievement generation systems.

### Trophy Progression Interface
```typescript
export interface TrophyProgression {
	player_id: number;
	task_id: number;
	count: number;
	time: number;
}
```

**Gaming Purpose**: Tracks individual player progress toward specific achievement tasks.

**Progress Tracking Fields**:
- `player_id: number`: Links progress to specific player
- `task_id: number`: Identifies which achievement task is being tracked
- `count: number`: Current progress count toward task completion
- `time: number`: Timestamp of last progress update for time-based achievements

### Trophy Progression Value Interface
```typescript
export interface TrophyProgressionValue {
	count: number;
	time: number;
}
```

**Gaming Purpose**: Progress data without player and task identifiers, used for progress updates and calculations.

### Task Interface
```typescript
export interface Task {
	id: number;
	total: number;
	description: string;
}
```

**Gaming Purpose**: Defines individual tasks that players must complete for achievements.

**Task Structure**:
- `id: number`: Unique task identifier
- `total: number`: Required completion count (e.g., "Kill 100 monsters", "Mine 50 resources")
- `description: string`: Human-readable task description for player display

## Schema Type Definition

### Complete Schema Structure
```typescript
export interface SchemaType extends ISchemaType {
	full_starter_react: {
		Player: Player,
		PlayerValue: PlayerValue,
	},
	achievement: {
		TrophyCreation: TrophyCreation,
		TrophyCreationValue: TrophyCreationValue,
		TrophyProgression: TrophyProgression,
		TrophyProgressionValue: TrophyProgressionValue,
		Task: Task,
	},
}
```

**Gaming Organization**: The schema is organized into logical game modules:

#### `full_starter_react` Namespace
**Purpose**: Contains core game models related to player entities and basic gameplay mechanics.

**Gaming Context**: Houses the fundamental player model that tracks character stats, progression, and identity.

#### `achievement` Namespace  
**Purpose**: Contains all achievement and trophy system models for player progression tracking.

**Gaming Context**: Provides comprehensive achievement system with trophies, tasks, and progress tracking for player engagement and retention.

**Namespace Benefits**:
- **Logical Separation**: Game mechanics are grouped by functionality
- **Scalability**: Easy to add new namespaces for additional game systems
- **Clarity**: Developers can quickly locate relevant models for specific game features

## Schema Object Implementation

### Default Values Configuration
```typescript
export const schema: SchemaType = {
	full_starter_react: {
		Player: {
			owner: "",
			experience: 0,
			health: 0,
			coins: 0,
			creation_day: 0,
		},
		PlayerValue: {
			experience: 0,
			health: 0,
			coins: 0,
			creation_day: 0,
		},
	},
	achievement: {
		TrophyCreation: {
			id: 0,
			hidden: false,
			index: 0,
			points: 0,
			start: 0,
			end: 0,
			group: 0,
			icon: 0,
			title: 0,
			description: "",
			tasks: [{ id: 0, total: 0, description: "", }],
			data: "",
		},
		// ... other achievement models with defaults
	}
};
```

**Gaming Purpose**: Provides default values for all game models, ensuring consistent initialization and preventing undefined state errors.

**Default Value Strategy**:
- **Numbers**: Default to `0` for stats, currencies, and counters
- **Strings**: Default to empty strings for text fields  
- **Booleans**: Default to `false` for flags and toggles
- **Arrays**: Default to single empty element for required array fields

**Gaming Benefits**: 
- **Consistent Initialization**: New players start with predictable stats
- **Error Prevention**: Prevents null/undefined errors in game calculations
- **Development Safety**: Provides fallback values during development and testing

## Models Mapping Enum

### Entity Identification System
```typescript
export enum ModelsMapping {
	Player = 'full_starter_react-Player',
	PlayerValue = 'full_starter_react-PlayerValue',
	TrophyCreation = 'achievement-TrophyCreation',
	TrophyCreationValue = 'achievement-TrophyCreationValue',
	TrophyProgression = 'achievement-TrophyProgression',
	TrophyProgressionValue = 'achievement-TrophyProgressionValue',
	Task = 'achievement-Task',
}
```

**Gaming Purpose**: Provides standardized entity identifiers for querying and managing game data across the Dojo system.

**Naming Convention**: `{namespace}-{ModelName}` pattern ensures unique identification across all game modules.

## Relationship with Cairo Models

### Cairo Player Model
```cairo
// Cairo struct in full_starter_react::models::player
#[derive(Model, Copy, Drop, Serde)]
struct Player {
    #[key]
    owner: ContractAddress,
    experience: u32,
    health: u32,
    coins: u32,
    creation_day: u64,
}
```

### TypeScript Interface Mapping
```typescript
// Auto-generated TypeScript interface
export interface Player {
    owner: string;        // ContractAddress -> string
    experience: number;   // u32 -> number  
    health: number;       // u32 -> number
    coins: number;        // u32 -> number
    creation_day: number; // u64 -> number
}
```

**Type Conversion**:
- **ContractAddress** → **string**: Wallet addresses as hex strings
- **u32/u64** → **number**: Integer types for game statistics
- **Array<T>** → **Array<T>**: Direct array mapping for complex structures

**Gaming Synchronization**: This direct mapping ensures that any changes to your Cairo game models automatically reflect in your TypeScript interfaces, maintaining perfect synchronization between onchain logic and frontend display.

---

**Next**: While bindings.ts provides the structural foundation with TypeScript interfaces that define what your game data looks like (Player stats, achievements, game entities), [contracts.gen.ts](./contracts-bindings.md) complements this by defining what your game can actually do. Where bindings establish the "nouns" of your game (player health, experience, coins), contracts.gen.ts creates the "verbs" - the executable actions. 

*Together, these files create a complete type-safe bridge: bindings ensure your data structures stay synchronized between Cairo and TypeScript, while contracts.gen.ts transforms complex blockchain transactions into simple game function calls.*
