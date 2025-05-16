# Models in Dojo Engine

Welcome to the **Models** guide for the Dojo By Example documentation! This page introduces models in the Dojo Engine, a powerful framework for building on-chain games using the **Entity Component System (ECS)** pattern on Starknet. Whether you're new to game development or Cairo programming, this guide will help you understand what models are, how they're structured, and how they integrate with Dojo's ECS architecture.

## Introduction to Models in Dojo and ECS

In the Dojo Engine, a **model** is a fundamental data structure that defines the schema for storing game state (state of entities within a game world) on-chain. Think of models as blueprints for the attributes of game objects, such as a character's health, a game's status, or an inventory's contents. Models are the "data layer" in Dojo's ECS pattern, enabling efficient storage, querying, and updating of game state in a decentralized environment.

### Why Models Matter
- **Structured Data**: Models define the properties (fields) of game entities, like a character's strength or a game's turn count.
- **ECS Integration**: Models act as **components** in the ECS pattern, attaching data to **entities** and enabling **systems** (game logic) to manipulate them.
- **On-Chain Efficiency**: Built for Starknet, models are optimized for scalability and verifiability, storing state in the world contract.

Models are written in **Cairo**, Starknet's native language, and use the `#[dojo::model]` attribute to integrate with Dojo's framework. By defining models, you create the foundation for your game's state, which systems can query and update via Dojo's introspection tools.

### What is ECS?
**ECS (Entity Component System)** is a design pattern used in game development to organize and manage game state and logic. It consists of:
- **Entities**: Unique identifiers (e.g., a character or game instance) that serve as "containers" for data. In Dojo, entities are typically represented by their key values (ContractAddress, u32, etc.).
- **Components**: Data structures (in Dojo, **models**) that hold specific attributes of an entity, such as health or inventory.
- **Systems**: Logic modules (service layer) that process entities by querying and updating their components. Systems contain the game's rules, like combat or movement logic.

ECS enables scalable, modular game development by separating data (models/components) from logic (systems), making it ideal for on-chain games.

## Anatomy of a Model

A model in Dojo is a Cairo struct with specific attributes and fields. Let's explore the key components using examples from real-world implementations.

### Key Concepts and Examples

1. **`#[dojo::model]` Attribute**:
   - Marks a struct as a Dojo model, registering it in the world contract for ECS integration.
   - **Example**: From `Player` model:
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
     - **Commentary**: The `#[dojo::model]` attribute tells Dojo to treat `Player` as a model. This model stores a player's stats and activity metrics, with `address` as the unique identifier.

2. **`#[key]` Attribute**:
   - Specifies which fields are used to index the model. You can have multiple keys to create a composite key.
   - **Example**: From the `Beast` model:
     ```cairo
     #[derive(Copy, Drop, Serde, Debug, PartialEq)]
     #[dojo::model]
     pub struct Beast {
         #[key]
         pub player: ContractAddress,
         #[key]
         pub beast_id: u16,
         pub level: u8,
         pub experience: u16,
         pub beast_type: BeastType,
     }
     ```
     - **Commentary**: Both `player` and `beast_id` fields are keys, creating a composite key. This means to query this beast, you need both the player's address and the beast's ID.

3. **Key Order and Requirements**:
   - You must define at least one key for each model, as this is how you query the model.
   - All keys must come before any non-key members in the struct.
   - When using composite keys, all keys must be provided to query the model.
   - **Example**: Querying a model with composite keys:
     ```cairo
     let player = get_caller_address();
     let beast_id = 123;
     
     // Using both parts of the composite key for the query
     let beast = world.read_model((player, beast_id));
     ```

4. **Field Types**:
   - Models use Cairo's primitive types and custom types to define fields.
   - Custom types must implement the `Introspect` trait to be used in models.
   - **Example**: From the `Potion` model:
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
     - **Commentary**: The model uses various types: `u64` for the ID, `felt252` for the name, `u8` for the effect, a custom `Rarity` enum, and `u32` for the power value.

5. **Metadata (Derives)**:
   - Essential derives for models:
     - **`Drop`**: Ensures the struct can be safely deallocated when no longer needed, as part of Cairo's ownership system.
     - **`Serde`**: Enables serialization/deserialization for data transfer.
     - **`Copy`** (optional): Allows the type to be copied rather than moved, useful for simple data types.
     - **`Debug`** (optional): Enables formatted debug output.
     - **`PartialEq`** (optional): Enables equality comparison.
   - **Example**: All models include at least `Drop` and `Serde`:
     ```cairo
     #[derive(Drop, Serde)]
     #[dojo::model]
     struct Moves {
         #[key]
         player: ContractAddress,
         remaining: u8,
     }
     ```

6. **Introspect and IntrospectPacked**:
   - `Introspect` is automatically implemented for models, enabling the world database to understand their structure.
   - `IntrospectPacked` is used when you want to store the model in a packed way to save storage:
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
     - **Commentary**: The `IntrospectPacked` derive forces the use of a `Fixed` layout, saving storage space but with less flexibility for upgrades.

## Implementing Custom Types for Models

When using custom types in models (like enums or complex structs), you need to ensure they implement the `Introspect` trait.

### Two Approaches to Implementing Introspect

1. **Automatic Derivation** (for types defined in your project):
   ```cairo
   #[derive(Drop, Serde, Introspect)]
   struct Stats {
       atk: u8,
       def: u8,
   }
   ```

2. **Manual Implementation** (for types from other projects or complex cases):
   ```cairo
   impl StatsIntrospect of dojo::database::introspect::Introspect<Stats> {
       #[inline(always)]
       fn size() -> Option<usize> {
           Option::Some(2)
       }

       fn layout() -> dojo::database::introspect::Layout {
           // Layout implementation
       }

       #[inline(always)]
       fn ty() -> dojo::database::introspect::Ty {
           // Type implementation
       }
   }
   ```

### Using IntrospectPacked for Space Efficiency

`IntrospectPacked` is useful when you know the size of the model and want to save storage space:

```cairo
#[derive(Drop, Serde, IntrospectPacked)]
struct Stats {
    atk: u8,
    def: u8,
}
```

Note that dynamic types like `ByteArray` and `Array` cannot be used in packed models.

## Model Traits and Patterns

Dojo models often include additional traits and implementations to enhance their functionality.

### The Zero Pattern

```cairo
pub impl ZeroablePlayerTrait of Zero<Player> {
    #[inline(always)]
    fn zero() -> Player {
        Player {
            address: constants::ZERO_ADDRESS(),
            current_beast_id: 0,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 0,
            creation_day: 1,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Player) -> bool {
        *self.address == constants::ZERO_ADDRESS()
    }

    #[inline(always)]
    fn is_non_zero(self: @Player) -> bool {
        !self.is_zero()
    }
}
```

This pattern provides:
- A standard way to create "empty" model instances
- Methods to check if a model is empty
- Utility for initialization and validation

### Custom Trait Generation

The `#[generate_trait]` attribute creates trait implementations for model-specific operations:

```cairo
#[generate_trait]
pub impl PlayerAssert of AssertTrait {
    #[inline(always)]
    fn assert_exists(self: Player) {
        assert(self.is_non_zero(), 'Player: Does not exist');
    }

    #[inline(always)]
    fn assert_not_exists(self: Player) {
        assert(self.is_zero(), 'Player: Already exist');
    }
}
```

This creates reusable validation logic specific to the model.

### Implementing Model Methods

Models often include implementation blocks with methods for common operations:

```cairo
#[generate_trait]
pub impl PotionImpl of PotionTrait {
    fn new_potion(potion_id: u64) -> Potion {
        Potion { id: potion_id, name: 'Potion', effect: 0, rarity: Rarity::Basic, power: 0 }
    }

    fn use_potion(self: @Potion, target_hp: u32) -> u32 {
        target_hp.saturating_add(*self.power)
    }

    fn is_rare(self: @Potion) -> bool {
        self.rarity.is_rare()
    }
}
```

## Models, Entities, and Components in ECS

Understanding how models fit into the broader ECS architecture is essential for effective Dojo development.

### Entities vs. Models

In Dojo:
- **Entities** are identified by their key values (e.g., a ContractAddress, u32, or composite key).
- **Models** (components) are attached to entities via these keys.

### Example: Relationship Between Entities and Models

Consider a player entity with multiple associated models:

```
Entity: Player (identified by ContractAddress)
├── Player model (stats, battles won/lost)
├── Inventory model (items owned)
└── Position model (location in game world)
```

Each model stores a specific aspect of the entity's state, and they're all linked by the same key value (the player's address).

### Comparison Table

| Concept     | Role in ECS                              | Example                             |
|-------------|------------------------------------------|------------------------------------|
| **Entity**  | A unique identifier for a game object    | A player's ContractAddress         |
| **Component** | Data (model) attached to an entity       | `Player`, `Beast`, or `Potion` model |
| **System**  | Logic that operates on components        | A battle system updating player stats |

## Working with Models in Systems

Systems interact with models through the World contract, which manages all game state.

### Reading Models

```cairo
fn get_player_info(world: IWorldDispatcher, player_address: ContractAddress) {
    // Read a model using its key(s)
    let player = world.read_model(player_address);
    
    // For composite keys, provide a tuple of all keys
    let beast = world.read_model((player_address, beast_id));
}
```

### Writing Models

```cairo
fn update_player(world: IWorldDispatcher, player_address: ContractAddress) {
    // First read the current state
    let mut player = world.read_model(player_address);
    
    // Update fields
    player.battles_won += 1;
    player.last_active_day = get_current_day();
    
    // Write the updated model back to the world
    world.write_model(@Player { 
        address: player_address,
        battles_won: player.battles_won,
        battles_lost: player.battles_lost,
        current_beast_id: player.current_beast_id,
        last_active_day: player.last_active_day,
        creation_day: player.creation_day
    });
}
```

### Practical Example: Battle System

Here's a simplified battle system using multiple models:

```cairo
fn process_battle(
    world: IWorldDispatcher, 
    player_address: ContractAddress,
    opponent_address: ContractAddress
) {
    // Read player models
    let player = world.read_model(player_address);
    let opponent = world.read_model(opponent_address);
    
    // Read beast models (using composite keys)
    let player_beast = world.read_model((player_address, player.current_beast_id));
    let opponent_beast = world.read_model((opponent_address, opponent.current_beast_id));
    
    // Battle logic (simplified)
    let (damage, is_favored, is_super_effective) = player_beast.attack(
        opponent_beast.beast_type,
        SkillType::Beam,
        100
    );
    
    // Update stats based on outcome
    let mut updated_player = player;
    updated_player.battles_won += 1;
    
    let mut updated_opponent = opponent;
    updated_opponent.battles_lost += 1;
    
    // Write updated models
    world.write_model(@updated_player);
    world.write_model(@updated_opponent);
}
```

## Testing Models

Cairo provides a built-in testing framework that works well with Dojo models.

### Test Block Structure

```cairo
#[cfg(test)]
mod tests {
    use super::{Potion, PotionTrait};
    use crate::types::rarity::Rarity;
    
    #[test]
    #[available_gas(300000)]
    fn test_basic_initialization() {
        let id = 1;
        let potion = Potion { 
            id: 1, 
            name: 'Murder', 
            effect: 0, 
            rarity: Rarity::Basic, 
            power: 10 
        };
        
        assert_eq!(potion.id, id, "Potion ID should match");
        assert_eq!(potion.name, 'Murder', "Potion name should be Murder");
        assert_eq!(potion.power, 10, "Power should be 10");
    }
    
    // More tests...
}
```

### Testing Traits and Methods

```cairo
#[test]
fn test_is_rare() {
    let mut potion = PotionTrait::new_potion(1);
    
    potion.rarity = Rarity::VeryRare;
    assert_eq!(potion.is_rare(), true, "VeryRare should return true");
    
    potion.rarity = Rarity::Rare;
    assert_eq!(potion.is_rare(), true, "Rare should return true");
    
    potion.rarity = Rarity::Uncommon;
    assert_eq!(potion.is_rare(), false, "Uncommon should return false");
}
```

## Special Model Patterns

### Game Settings with Constant Keys

For global values or settings:

```cairo
const GAME_SETTINGS_ID: u32 = 9999999999999;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct GameSettings {
    #[key]
    game_settings_id: u32,
    combat_cool_down: u32,
}

// Usage:
world.read_model(GAME_SETTINGS_ID);
```

### Type-Safe Entity IDs

To avoid ID collisions:

```cairo
const HUMAN: felt252 = 'HUMAN';
const GOBLIN: felt252 = 'GOBLIN';

// Create unique IDs:
let human_id = poseidon_hash_span([id, HUMAN].span());
let goblin_id = poseidon_hash_span([goblin_count, GOBLIN].span());
```

## Upgrading Models and Data Migration

Upgrading models is safe as long as changes don't affect the existing data layout and schema.

### Safe Upgrades

Adding a new field without modifying existing ones:

```cairo
// Original model
#[dojo::model]
struct Player {
    #[key]
    player_id: u64,
    username: String,
    score: u32,
}

// Upgraded model (safe)
#[dojo::model]
struct Player {
    #[key]
    player_id: u64,
    username: String,
    score: u32,
    level: u8, // New field
}
```

### Incompatible Upgrades

Changes that alter the existing layout will fail:
- Removing or reordering fields
- Changing field types
- Changing key structure

## Best Practices for Model Design

### Keep Models Small and Focused

Follow ECS principles by keeping models small and focused on a single aspect of an entity:

```cairo
// Good: Separate models for different aspects
#[dojo::model]
struct Health {
    #[key]
    id: u32,
    health: u8,
}

#[dojo::model]
struct Position {
    #[key]
    id: u32,
    x: u32,
    y: u32
}

// Avoid: Large monolithic models
#[dojo::model]
struct Character {
    #[key]
    id: u32,
    health: u8,
    max_health: u8,
    mana: u8,
    max_mana: u8,
    x: u32,
    y: u32,
    inventory_slots: u8,
    // ... many more fields
}
```

### Use Appropriate Types

Choose types based on data needs:
- `u8` for small integers (0-255)
- `u16`, `u32`, etc. for larger integers
- `felt252` for names and identifiers
- Custom structs and enums for complex data

### Implement Validation Logic

Use traits and assertions to validate model state:

```cairo
fn assert_valid_health(self: @Health) {
    assert(self.health > 0, 'Health must be positive');
    assert(self.health <= self.max_health, 'Health cannot exceed max');
}
```

### Plan for Upgrades

Design models with future upgrades in mind:
- Consider which fields might need to change
- Use `IntrospectPacked` only when necessary
- Document expected upgrade paths

## Conclusion

Models are the core of game state management in Dojo Engine, defining how data is structured and stored on Starknet. By combining models with **entities** and **systems** in the **ECS** pattern, you can build dynamic, decentralized games. 

Use the examples and patterns in this guide as a starting point for your own model designs, and experiment with the different approaches to find what works best for your game's needs.
