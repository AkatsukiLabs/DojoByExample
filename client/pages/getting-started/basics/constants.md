# Constants Usage in Dojo Engine 🎮

Constants are like the **configuration file** of your game - they define the fixed values that control how your game behaves. Think of them as the "rules" that determine damage amounts, health points, cooldown times, and other gameplay mechanics in your Dojo game.

## Why Constants Matter in Game Development 🤔

Imagine you're balancing a fighting game. Without constants, you'd have random numbers scattered throughout your code like:

```cairo
// ❌ Bad: Magic numbers everywhere
let damage = attack_power * 150;  // What does 150 mean?
let health = base_health + level * 20;  // Why 20?
```

With constants, your code becomes self-documenting and easier to balance:

```cairo
// ✅ Good: Clear, meaningful constants
let damage = attack_power * SUPER_EFFECTIVE;
let health = base_health + level * HEALTH_BONUS_PER_LEVEL;
```

**Key Benefits:**
- **Easy Game Balancing**: Change one number to affect the entire game
- **Clear Code**: Anyone can understand what `MAX_ENERGY` means
- **Consistent Values**: No more accidentally using 100 in one place and 99 in another
- **Team Collaboration**: Designers can suggest balance changes without touching code logic

## Real-World Example: Building a Combat System 💻

Here's how you might structure constants for a turn-based RPG in Dojo:

```cairo
// constants.cairo
// Combat Balance - The heart of your game's feel

// Type Effectiveness System (Rock-Paper-Scissors mechanics)
pub const SUPER_EFFECTIVE: u8 = 150;     // 1.5x damage - strong advantage
pub const NORMAL_EFFECTIVENESS: u8 = 100; // 1.0x damage - neutral matchup  
pub const NOT_VERY_EFFECTIVE: u8 = 50;   // 0.5x damage - poor matchup

// Character Progression
pub const BASE_LEVEL_BONUS: u8 = 10;     // Stats gained per level
pub const MAX_HEALTH_BONUS_PER_LEVEL: u8 = 20; // HP increase per level

// Energy Management (Prevents spam, adds strategy)
pub const MAX_ENERGY: u8 = 100;          // Energy cap
pub const ENERGY_REGEN_RATE: u8 = 5;     // Energy gained per turn
pub const ENERGY_COST_PER_ACTION: u8 = 10; // Energy spent per basic attack

// Time-Based Mechanics
pub const SECONDS_PER_DAY: u64 = 86400;  // For daily rewards/events
pub const GAME_TICK_RATE: u64 = 60;      // How often game updates

// Special Attack Modifiers
pub const FAVORED_ATTACK_MULTIPLIER: u8 = 120; // 1.2x for specialized attacks
pub const NORMAL_ATTACK_MULTIPLIER: u8 = 100;  // 1.0x for basic attacks

// Utility Constants
pub fn ZERO_ADDRESS() -> ContractAddress {
    contract_address_const::<0x0>()  // Null address for empty/invalid states
}
```

## How to Organize Your Constants 📊

**Group by Game System:**
```cairo
// ⚡ Energy System
pub const MAX_ENERGY: u8 = 100;
pub const ENERGY_REGEN_RATE: u8 = 5;

// ❤️ Health System  
pub const BASE_HEALTH: u8 = 100;
pub const HEALTH_REGEN_RATE: u8 = 2;

// ⚔️ Combat System
pub const SUPER_EFFECTIVE: u8 = 150;
pub const NORMAL_EFFECTIVENESS: u8 = 100;
```

**Naming Convention:** Use `SCREAMING_SNAKE_CASE` for constants - it's the Cairo standard and makes them easy to spot in your code.

## Putting Constants to Work 👨‍💻

Once you've defined your constants, here's how to use them effectively in your game logic:

### Import Your Constants
```cairo
// At the top of your Cairo files
use dojo_examples::constants::*;
```

### Example 1: Combat Effectiveness Calculator
```cairo
// Calculate how effective an attack is based on elemental types
fn calculate_damage_multiplier(attacker_type: ElementType, defender_type: ElementType) -> u8 {
    match (attacker_type, defender_type) {
        // Fire beats Ice, Water beats Fire, Ice beats Water
        (ElementType::Fire, ElementType::Ice) | 
        (ElementType::Water, ElementType::Fire) |
        (ElementType::Ice, ElementType::Water) => SUPER_EFFECTIVE,
        
        // Reverse matchups are weak
        (ElementType::Ice, ElementType::Fire) | 
        (ElementType::Fire, ElementType::Water) |
        (ElementType::Water, ElementType::Ice) => NOT_VERY_EFFECTIVE,
        
        // Same types are neutral
        _ => NORMAL_EFFECTIVENESS,
    }
}
```

### Example 2: Level-Up Rewards
```cairo
// Calculate how much health a player gains when leveling up
fn calculate_level_up_bonus(current_level: u8) -> u8 {
    current_level * BASE_LEVEL_BONUS + MAX_HEALTH_BONUS_PER_LEVEL
}
```

### Example 3: Energy Management
```cairo
// Check if player has enough energy for an action
fn can_perform_action(current_energy: u8, action_cost: u8) -> bool {
    current_energy >= action_cost
}

// Regenerate energy each turn (with cap)
fn regenerate_energy(current_energy: u8) -> u8 {
    let new_energy = current_energy + ENERGY_REGEN_RATE;
    if new_energy > MAX_ENERGY {
        MAX_ENERGY
    } else {
        new_energy
    }
}
```

## Game Designer's Perspective 🎯

Constants make your game **designer-friendly**. Want to make combat faster? Increase `ENERGY_REGEN_RATE`. Want to reduce grinding? Boost `BASE_LEVEL_BONUS`. 

**Before Constants:**
"The game feels too slow, but I'd need to find every energy-related calculation in the code..."

**With Constants:**
"Change `ENERGY_REGEN_RATE` from 5 to 8 and test it!"

## Best Practices for Dojo Games ⭐

1. **Document Your Intent**: Add comments explaining why you chose specific values
2. **Group Related Constants**: Keep all combat constants together, all time constants together
3. **Use Meaningful Names**: `CRITICAL_HIT_CHANCE` is better than `CRIT_CHANCE`
4. **Start Conservative**: It's easier to buff than nerf in live games
5. **Version Your Balance**: Keep track of constant changes for rollback purposes

## Testing Your Constants 🧪

```cairo
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_type_effectiveness() {
        // Fire should be super effective against Ice
        let multiplier = calculate_damage_multiplier(ElementType::Fire, ElementType::Ice);
        assert(multiplier == SUPER_EFFECTIVE, 'Fire should beat Ice');
    }

    #[test]
    fn test_energy_cap() {
        // Energy should never exceed maximum
        let capped_energy = regenerate_energy(MAX_ENERGY);
        assert(capped_energy == MAX_ENERGY, 'Energy should be capped');
    }
}
```

## Summary 📚

Constants are the foundation of maintainable game development in Dojo. They transform scattered magic numbers into a centralized, editable configuration system that makes balancing your game a breeze.

**Remember:**
- Constants = Game Balance Control Center
- Good naming = Self-documenting code  
- Organized constants = Happy team
- Testable constants = Reliable game mechanics

Start simple, stay organized, and let constants handle the heavy lifting of game balance while you focus on creating amazing gameplay experiences! 🚀