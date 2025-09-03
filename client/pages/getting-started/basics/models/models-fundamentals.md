# Dojo Models Fundamentals

Welcome to the **Models Fundamentals** guide for Dojo Engine! This document serves as your entry point to understanding models and the Entity Component System (ECS) architecture in Dojo. Whether you're new to game development or blockchain programming, this guide will build your foundation for creating on-chain games with Dojo.

## Table of Contents

1. [Introduction to Models and ECS](#introduction-to-models-and-ecs)
2. [Basic Model Anatomy](#basic-model-anatomy)
3. [Keys and Entity Identification](#keys-and-entity-identification)
4. [Field Types and Metadata](#field-types-and-metadata)
5. [Custom Types Implementation](#custom-types-implementation)
6. [Next Steps](#next-steps)

## Introduction to Models and ECS

### What are Models in Dojo Engine?

In the Dojo Engine, a **model** is a fundamental data structure that defines the schema for storing game state on-chain. Think of models as blueprints for the attributes of game objects - like a player's stats, a beast's characteristics, or an item's properties. Models serve as the "data layer" in Dojo's ECS pattern, enabling efficient storage, querying, and updating of game state in a decentralized environment.

### Understanding the ECS Pattern

**ECS (Entity Component System)** is a design pattern that organizes game architecture into three core concepts:

- **Entities**: Unique identifiers that represent game objects (like a specific player or beast)
- **Components**: Data containers that store attributes (in Dojo, these are **models**)
- **Systems**: Logic modules that process and manipulate the data

### Why ECS Matters for Onchain Games

The ECS approach provides several key benefits for blockchain game development:

- **Modularity**: Separate data (models) from logic (systems) for cleaner code
- **Scalability**: Efficiently manage complex game states with many entities
- **Flexibility**: Easily add new features by creating new models and systems
- **Performance**: Optimized for Starknet's execution environment

### Relationship Between Entities, Components, and Systems

In Dojo's ECS implementation:

1. **Entities** are identified by their key values (like a `ContractAddress` or composite key)
2. **Models** act as components, storing specific data about entities
3. **Systems** contain game logic that reads and updates models

Example relationship:
```
Entity: Player (ContractAddress: 0x123...)
├── Player model (battles_won, battles_lost, creation_day)
├── Beast model (level, experience, beast_type)
└── Inventory model (items, quantities)
```

## Basic Model Anatomy

Every Dojo model follows a consistent structure using Cairo syntax and specific attributes.

### The #[dojo::model] Attribute

The `#[dojo::model]` attribute marks a Cairo struct as a Dojo model, registering it in the world contract for ECS integration:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Player {
    #[key]
    pub address: ContractAddress,
    pub current_beast_id: u16,
    pub battles_won: u16,
    pub battles_lost: u16,
    pub last_active_day: u32,
    pub creation_day: u32,
}
```

### Simple Model Structure with Single Key

The simplest model structure includes:
- Required attributes and derives
- A single `#[key]` field for entity identification
- Data fields using appropriate types

```cairo
#[derive(Drop, Serde)]
#[dojo::model]
struct GameSession {
    #[key]
    pub session_id: u64,
    pub player_count: u8,
    pub status: u8,
    pub created_at: u32,
}
```

### Basic Field Types

Dojo models support Cairo's primitive types:

- **`u8`, `u16`, `u32`, `u64`**: Unsigned integers of different sizes
- **`felt252`**: Field element (primary data type in Cairo)
- **`ContractAddress`**: Starknet contract addresses
- **`bool`**: Boolean values

Choose types based on your data requirements:
- Use `u8` for small values (0-255) like levels or counts
- Use `u32` for larger values like timestamps
- Use `felt252` for strings and identifiers
- Use `ContractAddress` for player or contract references

### Essential Derives

Every model requires specific derives for proper functionality:

- **`Drop`**: Enables safe memory deallocation (required)
- **`Serde`**: Enables serialization/deserialization (required)
- **`Copy`**: Allows copying instead of moving (optional, useful for simple data)
- **`Debug`**: Enables debug output (optional, helpful for development)
- **`PartialEq`**: Enables equality comparisons (optional)

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct SimpleItem {
    #[key]
    pub id: u32,
    pub name: felt252,
    pub value: u16,
}
```

## Keys and Entity Identification

Keys are crucial for identifying and querying entities in your game world.

### The #[key] Attribute and Its Purpose

The `#[key]` attribute specifies which fields serve as the unique identifier for a model instance. Every model must have at least one key field, and all key fields must appear before non-key fields in the struct definition.

### Single Key Pattern

The most straightforward approach uses a single field as the key:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Player {
    #[key]
    pub address: ContractAddress,  // Single key field
    pub current_beast_id: u16,
    pub battles_won: u16,
    pub battles_lost: u16,
}
```

### Composite Key Pattern

For more complex relationships, use multiple key fields to create composite keys:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub player: ContractAddress,    // First part of composite key
    #[key]
    pub beast_id: u16,             // Second part of composite key
    pub level: u8,
    pub experience: u16,
    pub beast_type: BeastType,
}
```

### Key Ordering Requirements

Important rules for keys:
1. All `#[key]` fields must come before non-key fields
2. Key order in the struct defines the query order
3. All keys must be provided when querying composite key models

### Querying Models with Different Key Structures

How you query models depends on their key structure:

```cairo
// Single key query
let player = world.read_model(player_address);

// Composite key query (requires all key values)
let beast = world.read_model((player_address, beast_id));
```

## Field Types and Metadata

Understanding data types and metadata is essential for creating efficient models.

### Cairo Primitive Types in Models

Choose the appropriate type based on your data requirements:

| Type | Range | Use Cases |
|------|-------|-----------|
| `u8` | 0-255 | Levels, small counters, percentages |
| `u16` | 0-65,535 | Larger counters, experience points |
| `u32` | 0-4.3B | Timestamps, large quantities |
| `u64` | 0-18.4 quintillion | Very large values, IDs |
| `felt252` | Field element | Names, strings, large identifiers |
| `ContractAddress` | Starknet address | Player addresses, contract references |

### When to Use Each Type

**Performance considerations:**
- Smaller types (`u8`, `u16`) use less storage and gas
- Larger types provide more range but cost more
- `felt252` is versatile but should be used thoughtfully

**Example with appropriate type choices:**
```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct GameItem {
    #[key]
    pub id: u64,              // Large range for unique IDs
    pub name: felt252,        // String data
    pub level_required: u8,   // Small range (1-100)
    pub price: u32,           // Medium range for currency
    pub owner: ContractAddress, // Player reference
}
```

### Required vs Optional Derives

**Required derives:**
- `Drop`: Memory management (always required)
- `Serde`: Data serialization (always required)

**Optional but recommended derives:**
- `Copy`: For simple data that can be copied cheaply
- `Debug`: For development and testing
- `PartialEq`: For comparing model instances

### Type Safety Considerations for Game Data

Ensure your types match your game's requirements:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct PlayerStats {
    #[key]
    pub player: ContractAddress,
    pub health: u16,        // 0-65535 HP range
    pub mana: u16,          // 0-65535 MP range  
    pub level: u8,          // 1-255 level cap
    pub experience: u32,    // Large XP values
}
```

## Custom Types Implementation

Advanced models often require custom types like enums and structs.

### Implementing Custom Types in Models

Custom types must implement the `Introspect` trait to be used in models. Here's an example with a custom enum:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq, Introspect)]
pub enum BeastType {
    Fire,
    Water,
    Earth,
    Air,
}

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub player: ContractAddress,
    #[key] 
    pub beast_id: u16,
    pub level: u8,
    pub experience: u16,
    pub beast_type: BeastType,  // Custom enum type
}
```

### Introspect Trait Requirements

The `Introspect` trait allows Dojo to understand your custom type's structure. For types you define, you can usually auto-derive it:

```cairo
#[derive(Drop, Serde, Introspect)]
pub struct Stats {
    pub attack: u8,
    pub defense: u8,
    pub speed: u8,
}
```

### Automatic Derivation vs Manual Implementation

**Automatic derivation** (preferred when possible):
```cairo
#[derive(Drop, Serde, Introspect)]
pub enum Rarity {
    Common,
    Uncommon,
    Rare,
    Epic,
    Legendary,
}
```

**Manual implementation** (for complex cases or external types):
```cairo
impl StatsIntrospect of dojo::database::introspect::Introspect<Stats> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(3)  // 3 u8 fields
    }

    fn layout() -> dojo::database::introspect::Layout {
        // Custom layout implementation
    }

    #[inline(always)]
    fn ty() -> dojo::database::introspect::Ty {
        // Type definition implementation  
    }
}
```

### IntrospectPacked for Space Efficiency

Use `IntrospectPacked` when you want to optimize storage space for models with known, fixed sizes:

```cairo
#[derive(Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
struct Potion {
    #[key]
    id: u64,
    name: felt252,
    effect: u8,
    rarity: Rarity,
    power: u32,
}
```

**Benefits of IntrospectPacked:**
- Reduced storage costs
- More efficient packing of data

**Limitations:**
- Cannot use dynamic types (`Array`, `ByteArray`)
- Less flexible for future upgrades

### Custom Enums and Structs in Game Models

Practical example combining custom types in a game context:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq, Introspect)]
pub enum ItemType {
    Weapon,
    Armor,
    Consumable,
    Quest,
}

#[derive(Copy, Drop, Serde, Debug, PartialEq, Introspect)]
pub struct ItemStats {
    pub attack_bonus: u8,
    pub defense_bonus: u8,
    pub durability: u8,
}

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct GameItem {
    #[key]
    pub id: u64,
    #[key]
    pub owner: ContractAddress,
    pub item_type: ItemType,     // Custom enum
    pub stats: ItemStats,        // Custom struct
    pub quantity: u16,
}
```

## Next Steps

Congratulations! You now understand the fundamentals of Dojo models and ECS architecture. You should be able to:

- Define basic model structures with appropriate types
- Use single and composite keys for entity identification  
- Implement custom types with the Introspect trait
- Choose appropriate field types for game data

### Continue Your Learning Journey

Now that you have a solid foundation, explore these advanced topics:

- **[Models Patterns](/getting-started/basics/models/models-patterns.md)**: Learn advanced patterns like model relationships, validation, and optimization techniques
- **Systems Integration**: Discover how systems interact with your models
- **World Management**: Understand how the World contract orchestrates your game state
- **Query Optimization**: Advanced techniques for efficient model queries


### Remember: 
Start simple, test thoroughly, and gradually add complexity as you become more comfortable with the ECS pattern in Dojo!