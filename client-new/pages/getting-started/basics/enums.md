# Enums in Dojo Engine

## Introduction to Enums

Enums (enumerations) are custom data types consisting of a fixed set of named values, called variants. They are fundamental in on-chain game development with Dojo, allowing developers to elegantly represent:

- Game states (waiting, active, finished)
- Entity types (fire, water, earth)
- Player actions (attack, defend, move)
- Skills or characteristics (slash, freeze, burn)

## What is an Enum?

An enum in Cairo is a way to define a type that can have one of several distinct values. Each possible value is called a "variant." Unlike integers or flags, enums are explicit and named, which improves code readability and safety.

Let's look at a basic example:

```cairo
#[derive(Copy, Drop, Serde, Introspect, Debug, PartialEq)]
enum PlayerCharacter {
    Godzilla,
    Dragon,
    Fox,
    Rhyno
}
```

This `PlayerCharacter` enum has four possible variants. Each instance of this type will contain exactly one of these variants.

## Enums in the Dojo Ecosystem

In Dojo, enums are extremely useful for modeling game state and entity types. They are an integral part of the Entity Component System (ECS) pattern used by Dojo.

### Basic Structure of a Dojo Enum

A typical enum in Dojo has this structure:

```cairo
#[derive(Copy, Drop, Serde, Introspect, Debug, PartialEq)]
pub enum EnumName {
    Variant1,
    Variant2,
    // More variants...
}
```

The most common `derive` attributes for enums are:
- `Copy`: Allows the enum to be copied rather than moved
- `Drop`: Allows the enum to be discarded when no longer needed
- `Serde`: Enables serialization/deserialization
- `Introspect`: Allows Dojo to "introspect" the type (important for models)
- `Debug`: Facilitates debugging with text representations
- `PartialEq`: Allows comparing enums with the `==` operator

## Practical Examples of Enums

### 1. Battle States

Let's look at a real example of an enum representing possible battle states:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum BattleStatus {
    Waiting,
    Active,
    Finished,
    None,
}
```

This enum allows tracking which phase a battle is in, facilitating the logic for transitioning between states.

### 2. Creature Types

Another common example is representing different types of creatures in a game:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum BeastType {
    Fire,
    Water,
    Earth,
    Electric,
    Dragon,
    Ice,
    Magic,
    Rock,
    Undefined,
}
```

### 3. Skill Types

Enums are also useful for categorizing skills or actions:

```cairo
#[derive(Copy, Drop, Serde, Introspect, Debug, PartialEq)]
pub enum SkillType {
    Slash,
    Beam,
    Wave,
    Punch,
    Kick,
    Blast,
    Crush,
    Pierce,
    Smash,
    Burn,
    Freeze,
    Shock,
    Default,
}
```

## Implementing Traits for Enums

One of the most powerful features of enums in Cairo is the ability to implement traits for them, which allows adding specific functionality.

### Display Trait for Text Representation

The `Display` trait allows converting an enum to a textual representation:

```cairo
pub impl SkillTypeDisplay of core::fmt::Display<SkillType> {
    fn fmt(self: @SkillType, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            SkillType::Beam => "Beam",
            SkillType::Slash => "Slash",
            SkillType::Wave => "Wave",
            SkillType::Punch => "Punch",
            // Other variants...
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
```

This pattern is very useful for debugging and UI representation.

### Into Trait for Type Conversion

The `Into` traits allow converting enums to other types, such as `felt252` or `u8`:

```cairo
pub impl IntoBattleStatusFelt252 of Into<BattleStatus, felt252> {
    #[inline(always)]
    fn into(self: BattleStatus) -> felt252 {
        match self {
            BattleStatus::Waiting => 0,
            BattleStatus::Active => 1,
            BattleStatus::Finished => 2,
            BattleStatus::None => 3,
        }
    }
}

pub impl IntoBattleStatusU8 of Into<BattleStatus, u8> {
    #[inline(always)]
    fn into(self: BattleStatus) -> u8 {
        match self {
            BattleStatus::Waiting => 0,
            BattleStatus::Active => 1,
            BattleStatus::Finished => 2,
            BattleStatus::None => 3,
        }
    }
}
```

The reverse conversion can also be implemented:

```cairo
pub impl Intou8BattleStatus of Into<u8, BattleStatus> {
    #[inline(always)]
    fn into(self: u8) -> BattleStatus {
        let battle_type: u8 = self.into();
        match battle_type {
            0 => BattleStatus::Waiting,
            1 => BattleStatus::Active,
            2 => BattleStatus::Finished,
            3 => BattleStatus::None,
            _ => BattleStatus::None,  // Default value for unhandled cases
        }
    }
}
```

## Pattern Matching with Enums

Pattern matching is one of the most powerful features when using enums:

```cairo
fn handle_battle_status(status: BattleStatus) {
    match status {
        BattleStatus::Waiting => {
            // Logic for waiting state
        },
        BattleStatus::Active => {
            // Logic for active state
        },
        BattleStatus::Finished => {
            // Logic for finished battle
        },
        BattleStatus::None => {
            // Default case handling
        },
    }
}
```

The Cairo compiler will verify that all possible cases are handled, which helps prevent errors.

## Enums with Associated Data

Enums can contain additional data in each variant:

```cairo
#[derive(Serde, Drop, Introspect)]
enum PlayerCharacter {
    Godzilla: u128,  // Godzilla creature ID
    Dragon: u32,     // Dragon level
    Fox: (u8, u8),   // Fox coordinates (x,y)
    Rhyno: ByteArray // Custom rhino name
}
```

This allows creating more complex and expressive data structures.

## Using Enums in Dojo Models

Enums integrate perfectly with Dojo models:

```cairo
#[derive(Drop, Serde)]
#[dojo::model]
struct Battle {
    #[key]
    id: u64,
    status: BattleStatus,
    battle_type: BeastType,
    winning_skill: SkillType,
}
```

When using enums in models, it's important to ensure the enum has implemented the `Introspect` or `IntrospectPacked` trait.

## Integration with Game Logic

Enums allow implementing complex game rules clearly:

```cairo
fn calculate_effectiveness(attacker_type: BeastType, defender_type: BeastType) -> u8 {
    match (attacker_type, defender_type) {
        (BeastType::Light, BeastType::Shadow) | 
        (BeastType::Magic, BeastType::Light) |
        (BeastType::Shadow, BeastType::Magic) => SUPER_EFFECTIVE,
        
        (BeastType::Light, BeastType::Magic) | 
        (BeastType::Magic, BeastType::Shadow) |
        (BeastType::Shadow, BeastType::Light) => NOT_VERY_EFFECTIVE,
        
        _ => NORMAL_EFFECTIVENESS,
    }
}
```

This pattern allows modeling type systems and advantages like in Pokémon-style games.

## Testing Enums

Testing enums is critical to ensure correct behavior:

```cairo
#[test]
fn test_into_battle_status_waiting() {
    let battle_status = BattleStatus::Waiting;
    let battle_status_felt252: felt252 = battle_status.into();
    assert_eq!(battle_status_felt252, 0);
}

#[test]
fn test_into_battle_status_from_u8_invalid() {
    let battle_status_u8: u8 = 4;
    let battle_status: BattleStatus = battle_status_u8.into();
    assert_eq!(battle_status, BattleStatus::None);
}
```

Tests for enums should cover:
- Conversions between types
- Behavior with invalid values
- Edge cases
- Integration with other system components

## Best Practices for Enums in Dojo

### 1. Always Include a Default Value

```cairo
pub enum BeastType {
    // Common variants...
    Undefined,  // ← Default value
}
```

Having a default value makes error handling and unexpected cases easier to manage.

### 2. Implement Conversion Traits

Implementing `Into<EnumType, u8>` and `Into<u8, EnumType>` facilitates serialization and storage.

### 3. Document the Purpose of Each Variant

A good comment explains the purpose and context of use:

```cairo
pub enum BattleStatus {
    Waiting,   // Players joining the battle, but it hasn't started
    Active,    // Battle in progress, players can make moves
    Finished,  // Battle completed with a defined result
    None,      // Invalid or uninitialized state
}
```

### 4. Definition Location

Define enums at the appropriate level of organization:
- If specific to a component, define the enum in the same file as the component
- If used across multiple components, place it in a shared module (e.g., `types/battle_status.cairo`)

### 5. Prioritize Readability

Use descriptive names for variants and organize them logically:

```cairo
// Prefer this:
enum MatchResult {
    Victory,
    Defeat,
    Draw,
    Cancelled,
}

// Instead of this:
enum MatchResult {
    R1,  // Victory
    R2,  // Defeat
    R3,  // Draw
    R4,  // Cancelled
}
```

## Comparison with Alternative Systems

### Enums vs. Integers with Constants

**Using constants:**
```cairo
const BATTLE_WAITING: u8 = 0;
const BATTLE_ACTIVE: u8 = 1;
const BATTLE_FINISHED: u8 = 2;
```

**Using enums:**
```cairo
enum BattleStatus {
    Waiting,
    Active,
    Finished,
}
```

**Advantages of enums:**
- Compile-time checking
- Descriptive names in the code
- Exhaustive pattern matching
- Impossible to use invalid values

## Enums in Dojo's ECS Pattern

In Dojo's Entity-Component-System (ECS) pattern, enums play important roles:

- As properties in components (models)
- For defining system event types
- For representing entity states
- For modeling types and categories

## Advanced Examples

### Example 1: Type-Advantage System

This pattern implements a system where different types have advantages over others:

```cairo
fn is_favored_attack(self: @Beast, skill_type: SkillType) -> bool {
    match skill_type {
        SkillType::Beam | SkillType::Slash | SkillType::Pierce |
        SkillType::Wave => self.beast_type == @BeastType::Light,
        
        SkillType::Blast | SkillType::Freeze | SkillType::Burn |
        SkillType::Punch => self.beast_type == @BeastType::Magic,
        
        SkillType::Smash | SkillType::Crush | SkillType::Shock |
        SkillType::Kick => self.beast_type == @BeastType::Shadow,
        
        _ => false,
    }
}
```

### Example 2: State Machine with Enums

```cairo
fn transition_game_state(current: GameStatus, event: GameEvent) -> GameStatus {
    match (current, event) {
        (GameStatus::NotStarted, GameEvent::PlayerJoined) => GameStatus::Lobby,
        (GameStatus::Lobby, GameEvent::GameStart) => GameStatus::InProgress,
        (GameStatus::InProgress, GameEvent::GameEnd) => GameStatus::Finished,
        // Invalid transitions maintain the current state
        _ => current,
    }
}
```

## Debugging Tips

1. **Implement Display for your enums:**
   ```cairo
   impl BeastTypeDisplay of core::fmt::Display<BeastType> {
       fn fmt(self: @BeastType, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
           let s = match self {
               BeastType::Fire => "Fire",
               // Other variants...
           };
           f.buffer.append(@s);
           Result::Ok(())
       }
   }
   ```

2. **Use the `Debug` derive to facilitate representation:**
   ```cairo
   #[derive(Debug)]
   pub enum BattleStatus {
       // Variants...
   }
   ```

## Conclusion

Enums in Dojo are an indispensable tool for on-chain game development. They offer a perfect balance between expressiveness, type safety, and computational efficiency. As you build more complex games, you'll discover that enums make your code more robust, easier to understand, and more maintainable in the long run.

Use the examples in this document as a starting point for integrating enums into your own Dojo development, and don't hesitate to expand these patterns to adapt them to the specific needs of your game.

## Additional Resources

- [Official Cairo Documentation on Enums](https://book.cairo-lang.org/ch06-00-enums-and-pattern-matching.html)
- [ECS Design Patterns in Dojo](https://docs.dojoengine.org/overview/ecs)
- [Introspect Trait Implementation](https://docs.dojoengine.org/cairo/models/introspect.html)
