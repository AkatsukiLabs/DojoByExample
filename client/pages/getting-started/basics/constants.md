# Constants Usage in Dojo Engine 🎮

## What are Constants? 📝

Constants are fixed values used in game code to configure essential parameters such as damage, health, time durations, and other gameplay aspects. In Dojo Engine, constants are defined in Cairo files like `constants.cairo`, enabling consistent game balance and easy configuration.

## Why Use Constants? 🤔

- **Maintainability:** Changing a constant updates all parts of the code that use it.
- **Game Balance:** Allows tweaking gameplay parameters without modifying logic.
- **Clarity:** Descriptive names are easier to understand than "magic numbers."

## Real Example: constants.cairo 💻

```cairo
// Game Balance Constants
// These constants control core gameplay mechanics and balance

// Time-based constants for game progression
pub const SECONDS_PER_DAY: u64 = 86400;  // Used for daily rewards and time-based events
pub const GAME_TICK_RATE: u64 = 60;      // How often the game state updates

// Combat system constants
pub const BASE_LEVEL_BONUS: u8 = 10;     // Base bonus per level for character progression
pub const SUPER_EFFECTIVE: u8 = 150;     // 150% damage for type advantages
pub const NORMAL_EFFECTIVENESS: u8 = 100; // 100% damage for neutral matchups
pub const NOT_VERY_EFFECTIVE: u8 = 50;   // 50% damage for type disadvantages

// Attack multipliers for strategic depth
pub const FAVORED_ATTACK_MULTIPLIER: u8 = 120; // 120% damage for favored attacks
pub const NORMAL_ATTACK_MULTIPLIER: u8 = 100;  // 100% damage for normal attacks

// Energy system constants
pub const MAX_ENERGY: u8 = 100;          // Maximum energy a player can have
pub const ENERGY_REGEN_RATE: u8 = 5;     // Energy points regenerated per tick
pub const ENERGY_COST_PER_ACTION: u8 = 10; // Cost of basic actions

// Health system constants
pub const BASE_HEALTH: u8 = 100;         // Starting health for new players
pub const HEALTH_REGEN_RATE: u8 = 2;     // Health points regenerated per tick
pub const MAX_HEALTH_BONUS_PER_LEVEL: u8 = 20; // Health increase per level

// Utility constants
pub fn ZERO_ADDRESS() -> ContractAddress {
    contract_address_const::<0x0>()  // Used for null checks and initialization
}
```

## Organizing Constants 📊

- Group constants by categories: combat, health, energy, time, etc.
- Use clear comments to explain each constant's purpose.
- Use uppercase snake_case naming for constants (e.g., MAX_SEARCH).

## Best Practices ⭐

- Avoid using "magic numbers" directly in code; always reference constants.
- Keep constants immutable.
- Use clear and descriptive names to avoid confusion.
- Document each constant with a brief comment.

## How Constants Help in Dojo 🚀

### Game Balance Tuning
Constants make it easy to adjust game balance without changing core logic. For example:
- Adjusting `ENERGY_REGEN_RATE` and `ENERGY_COST_PER_ACTION` to control gameplay pace
- Modifying `MAX_HEALTH_BONUS_PER_LEVEL` to scale difficulty with player progression
- Tweaking `SUPER_EFFECTIVE` and `NOT_VERY_EFFECTIVE` to balance combat mechanics

### Code Organization
Constants help organize game parameters into logical categories:
- Combat system constants
- Energy management constants
- Health system constants
- Time-based constants
- Utility constants

### Maintainability
Using constants improves code maintainability by:
- Centralizing configuration values
- Making balance changes easier to track
- Reducing the risk of inconsistent values
- Simplifying testing and debugging

## How to Use Constants in Your Cairo Code 👨‍💻

Once you define constants in `constants.cairo`, you can import and use them throughout your Dojo game modules for clear and consistent logic.

### Importing Constants

```cairo
// Import constants module
use constants::*;
```

### Example 1: Using Constants in Functions

```cairo
// Function to calculate attack effectiveness based on type matchups
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

### Example 2: Using Constants for Calculations

```cairo
// Calculate daily bonus based on player level
fn calculate_daily_bonus(level: u8) -> u8 {
    level * BASE_LEVEL_BONUS
}  
```

### Example 3: Using Constants in Conditionals

```cairo
// Determine if an attack is favored based on beast type
fn is_favored_attack(beast_type: BeastType, skill_type: SkillType) -> bool {
    match skill_type {
        SkillType::Beam | SkillType::Slash | SkillType::Pierce |
        SkillType::Wave => beast_type == BeastType::Light,
        SkillType::Blast | SkillType::Freeze | SkillType::Burn |
        SkillType::Punch => beast_type == BeastType::Magic,
        SkillType::Smash | SkillType::Crush | SkillType::Shock |
        SkillType::Kick => beast_type == BeastType::Shadow,
        _ => false,
    }
}
```

## Benefits ✨

- Centralized configuration for easy tuning
- Avoid hardcoding values throughout the codebase
- Improves readability and maintainability

## Summary 📚

Proper use of constants is essential for maintaining organized, scalable, and balanced code in Dojo Engine. Learn to define, organize, and use constants effectively to enhance your on-chain games.