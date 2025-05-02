# Models

# Models in Dojo Engine

Welcome to the **Models** guide for the Dojo By Example documentation! This page introduces models in the Dojo Engine, a powerful framework for building on-chain games using the **Entity Component System (ECS)** pattern on Starknet. Whether you're new to game development or Cairo programming, this guide will help you understand what models are, how they're structured, and how they integrate with Dojo's ECS architecture. Additionally, we'll explore cleanup mechanisms in Java, Go, and JavaScript to provide context for resource management in programming.

## Introduction to Models in Dojo and ECS

In the Dojo Engine, a **model** is a fundamental data structure that defines the schema for storing game state(state of entities within a game world) on-chain. Think of models as blueprints for the attributes of game objects, such as a character's health, a game's status, or an inventory's contents. Models are the "data layer" in Dojo's ECS pattern, enabling efficient storage, querying, and updating of game state in a decentralized environment.

### Why Models Matter
- **Structured Data**: Models define the properties (fields) of game entities, like a character's strength or a game's turn count.
- **ECS Integration**: Models act as **components** in the ECS pattern, attaching data to **entities** and enabling **systems** (game logic) to manipulate them.
- **On-Chain Efficiency**: Built for Starknet, models are optimized for scalability and verifiability, storing state in the world contract.

Models are written in **Cairo**, Starknet's native language, and use the `#[dojo::Model]` attribute to integrate with Dojo's framework. By defining models, you create the foundation for your game's state, which systems can query and update via Dojo's introspection tools.

### What is ECS?
**ECS (Entity Component System)** is a design pattern used in game development to organize and manage game state and logic. It consists of:
- **Entities**: Unique identifiers (e.g., a character or game instance) that serve as "containers" for data. In Dojo, entities are typically `felt252` IDs.
- **Components**: Data structures (in Dojo, **models**) that hold specific attributes of an entity, such as health or inventory.
- **Systems**: Logic modules (service layer) that process entities by querying and updating their components. Systems contain the game's rules, like combat or movement logic.
ECS enables scalable, modular game development by separating data (models/components) from logic (systems), making it ideal for on-chain games.

## Anatomy of a Model

A model in Dojo is a Cairo struct with specific attributes and fields. Let's explore the key components using examples from the [combat_game models](https://github.com/AkatsukiLabs/DojoByExample/tree/main/backend/dojo_examples/combat_game/src/models).

### Key Concepts and Examples

1. **`#[dojo::Model]` Attribute**:
   - Marks a struct as a Dojo model, registering it in the world contract for ECS integration.
   - **Example**: From `character.cairo`:
     ```cairo
     #[dojo::Model]
     struct Character {
         #[key]
         id: felt252,
         health: u32,
         attack: u32,
         defense: u32,
     }
     ```
     - **Commentary**: The `#[dojo::Model]` attribute tells Dojo to treat `Character` as a model. This model stores a character's stats (health, attack, defense) for a combat game, with `id` as the unique identifier.

2. **`#[key]` Attribute**:
   - Specifies the primary key field, uniquely identifying an instance of the model for a given entity. Only one field can be marked with `#[key]`.
   - **Example**: From `game.cairo`:
     ```cairo
     #[dojo::Model]
     struct Game {
         #[key]
         id: felt252,
         player1: felt252,
         player2: felt252,
         turn: u8,
         winner: Option<felt252>,
     }
     ```
     - **Commentary**: The `id` field is the key, ensuring each game instance is uniquely identified. The model tracks players, turn count, and the winner (if any).

3. **Field Types**:
   - Models use Cairo's primitive types (e.g., `felt252`, `u32`, `u8`, `Option<T>`) to define fields. Choose types based on the data's range and purpose (e.g., `u8` for small counters, `felt252` for IDs).
   - **Example**: From `inventory.cairo`:
     ```cairo
     #[dojo::Model]
     struct Inventory {
         #[key]
         character_id: felt252,
         item_count: u16,
     }
     ```
     - **Commentary**: The `item_count: u16` field uses a 16-bit unsigned integer to store the number of items a character holds, suitable for moderate counts (0–65,535).

4. **Metadata (Derives)**:
   - Additional derives like `Drop` and `Serde` are often used alongside `#[dojo::Model]`:
     - **`Drop`**: Ensures the struct can be safely deallocated from memory when no longer needed, preventing memory leaks. Think of it as a "cleanup crew" that automatically removes the struct's data (e.g., a character's stats) from memory when the program no longer needs it, keeping your on-chain program efficient and secure in Cairo's resource-conscious environment.
     - **`Serde`**: Enables serialization/deserialization for off-chain interactions, allowing model data to be converted to/from formats usable by external systems.
   - **Example**: From `combat.cairo`:
     ```cairo
     #[dojo::Model]
     #[derive(Drop, Serde)]
     struct Combat {
         #[key]
         game_id: felt252,
         attacker: felt252,
         defender: felt252,
         outcome: CombatOutcome,
     }
     ```
     - **Commentary**: The `#[derive(Drop, Serde)]` attributes ensure the `Combat` model can be safely deallocated and serialized. The `CombatOutcome` enum (defined elsewhere) tracks the result of a combat encounter.

## Models, Entities, and Components in ECS

Dojo leverages the **ECS** pattern to organize game logic. Understanding the roles of models, entities, and components is essential.

### Definitions
- **Entities**: Unique identifiers (e.g., a character or game instance) that serve as "containers" for data. Entities are typically represented by a `felt252` ID and hold no data themselves.
- **Components**: In Dojo, **models** are components. Each model attached to an entity defines a specific aspect of its state (e.g., health, inventory).
- **Systems**: Logic modules that process entities by querying and updating their components. Systems contain the game's rules, like combat or movement logic, and interact with the world contract via the `IWorldDispatcher` trait.

### Comparison Table

| Concept     | Role in ECS                              | Example from Combat Game           |
|-------------|------------------------------------------|------------------------------------|
| **Entity**  | A unique ID for a game object            | A character ID (`felt252`)         |
| **Component** | Data (model) attached to an entity       | `Character` or `Inventory` model   |
| **System**  | Logic that operates on components        | A system updating `Combat.outcome` |

### How They Work Together
- An entity (e.g., `character1`) can have multiple models, such as `Character` (health, attack) and `Inventory` (item count).
- **Systems** query the world contract to fetch or update these models. For example, a combat system might fetch the `Character` model for `character1`, reduce `health`, and update the `Combat` model.

## Introspection and Referencing Models

Dojo's **introspection** system allows **systems** to dynamically query and update models stored in the **world contract**, the central registry for game state on Starknet.

### How Introspection Works
- **Registration**: Models are registered in the world contract during deployment (using `sozo build` and `sozo migrate`).
- **Querying**: Systems use the `IWorldDispatcher` trait to access model data for an entity.
- **Example**: Fetching and updating a character's health:
  ```cairo
  use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

  fn take_damage(world: IWorldDispatcher, character_id: felt252, damage: u32) {
      let mut character = world.get::<Character>(character_id);
      if character.health > damage {
          character.health -= damage;
          world.set::<Character>(character);
      } else {
          character.health = 0;
          world.set::<Character>(character);
      }
  }
  ```
  - **Explanation**:
    - `world.get::<Character>(character_id)` retrieves the `Character` model for the given entity.
    - `world.set::<Character>(character)` updates the model in the world contract.
    - The `#[key]` field (`id`) links the model to the entity.

### Practical Example: Combat System
Consider a system that processes a combat action using the `Combat` model:
```cairo
fn process_combat(world: IWorldDispatcher, game_id: felt252) {
    let combat = world.get::<Combat>(game_id);
    let mut attacker = world.get::<Character>(combat.attacker);
    let mut defender = world.get::<Character>(combat.defender);
    // Simplified combat logic
    if attacker.attack > defender.defense {
        defender Mathematical operations are not allowed on struct types..health -= attacker.attack - defender.defense;
        world.set::<Character>(defender);
    }
    // Update combat outcome
    let mut combat = combat;
    combat.outcome = CombatOutcome::AttackerWins;
    world.set::<Combat>(combat);
}
```
- **Introspection**: The system fetches `Combat` and `Character` models using `world.get`.
- **Updates**: It modifies `Character.health` and `Combat.outcome`, then saves changes with `world.set`.

## Practical Walkthrough: Using the Character Model

Let's walk through using the `Character` model from `character.cairo` in a combat game.

### Step 1: Review the Model
```cairo
#[dojo::Model]
struct Character {
    #[key]
    id: felt252,
    health: u32,
    attack: u32,
    defense: u32,
}
```
- **Purpose**: Tracks a character's stats for combat.
- **Key**: `id` uniquely identifies the character.
- **Fields**: `health`, `attack`, and `defense` are `u32` for large, positive values.

### Step 2: Deploy the Model
- Compile with `sozo build`.
- Deploy to the world contract with `sozo migrate`.

### Step 3: Create a System
Write a system to heal a character:
```cairo
fn heal_character(world: IWorldDispatcher, character_id: felt252, heal_amount: u32) {
    let mut character = world.get::<Character>(character_id);
    character.health += heal_amount;
    // Cap health at a maximum (e.g., 100)
    if character.health > 100 {
        character.health = 100;
    }
    world.set::<Character>(character);
}
```
- **Logic**: Increases `health` and ensures it doesn't exceed 100.

### Step 4: Test the Model
- Use `sozo test` to simulate the system.
- Verify that `character.health` updates correctly and introspection works.

## Cleanup Mechanisms in Java

To provide context for resource management in programming, let's compare cleanup mechanisms in **Java** as it relate to the concept of `Drop` in Cairo.

### Java Cleanup
In Java, cleanup is associated with **garbage collection** and explicit resource management:
- **Garbage Collection**: Automatically reclaims memory for unreachable objects. Developers can suggest it with `System.gc()`, but it’s not guaranteed.[](https://www.theserverside.com/video/5-ways-to-force-Java-garbage-collection)
- **Cleaners**: Java 9+ uses the `Cleaner` class to register cleanup actions (e.g., closing files) when objects become phantom-reachable, replacing the deprecated `finalize()` method.[](https://inside.java/2022/05/27/testing-clean-cleaner-cleanup/)
- **Try-with-Resources**: The preferred way to close resources (e.g., files, sockets) using `AutoCloseable` objects, ensuring `close()` is called automatically.[](https://stackoverflow.com/questions/24216664/what-do-we-mean-by-cleanup-code)
  ```java
  try (FileInputStream fis = new FileInputStream("file.txt")) {
      // Use file
  } // fis.close() called automatically
  ```
- **Terminology**: Called "garbage collection" for memory and "resource management" for explicit cleanup.


### Relation to Cairo's Drop
Cairo's `Drop` derive is akin to these mechanisms, ensuring structs are safely deallocated when no longer needed, similar to Java's garbage collection or Go's `defer` for memory cleanup. However, `Drop` is specific to Cairo's provable computation model, guaranteeing memory safety in a resource-constrained environment.

## Further Reading
- [Entities in Dojo](./entities.md): Explore how entities act as unique IDs in ECS.
- [Introspection in Dojo](./introspection.md): Learn more about querying models.
- [Dojo Models Overview](https://docs.dojoengine.org/models): Official documentation for advanced features.
- [Starknet Cairo Guide](https://www.cairo-lang.org/docs/): Master Cairo's syntax and types.
- [Combat Game Models](https://github.com/AkatsukiLabs/DojoByExample/tree/main/backend/dojo_examples/combat_game/src/models): Source for the examples used here.

## Conclusion

Models are the core of game state management in Dojo Engine, defining how data is structured and stored on Starknet. By combining models with **entities** and **systems** in the **ECS** pattern, you can build dynamic, decentralized games. This guide covered the anatomy of models, their role in ECS, practical examples from a combat game, and cleanup mechanisms in Java, Go, and JavaScript for broader context. Dive into the linked resources, experiment with the code, and join the Dojo community to create your own on-chain games!