# Models Best Practices Quick Reference

A concise checklist and guidelines for optimal Dojo model development.

## Model Design Principles

### Design Checklist
- **Single responsibility** - Each model stores one aspect of entity data
- **Appropriate key structure** - Use single keys for entities, composite for relationships
- **Minimal derives** - Always include `Drop, Serde`; add others only when needed
- **Descriptive field names** - Use clear, consistent naming conventions
- **Input validation** - Implement assertion logic for data constraints
- **Upgrade planning** - Consider future schema changes during design

### Model Structure Best Practices
```cairo
// ✅ Good: Focused, single-responsibility model
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Health {
    #[key]
    id: u32,
    health: u8,
}

// ❌ Bad: Monolithic model with mixed concerns
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Character {
    #[key]
    id: u32,
    health: u8,
    max_health: u8,
    mana: u8,
    max_mana: u8,
    // ... many more fields
}
```

## Type Selection Guide

| Data Range | Type | Use Cases | Gas Efficiency |
|------------|------|-----------|----------------|
| 0–255 | `u8` | Health, levels, percentages, flags | ⭐⭐⭐ |
| 0–65,535 | `u16` | Player IDs, item counts, beast IDs | ⭐⭐⭐ |
| 0–4.2B | `u32` | Timestamps, large counters, coordinates | ⭐⭐ |
| Large numbers | `u64`, `u128` | Complex calculations, tokens | ⭐ |
| Text/IDs | `felt252` | Names, identifiers, enum values | ⭐⭐ |
| Addresses | `ContractAddress` | Player/contract references | ⭐⭐ |

### Custom Types Requirements
```cairo
// Custom types must implement Introspect (For space efficiency, use IntrospectPacked)
#[derive(Drop, Serde, Introspect)]
struct Stats {
    atk: u8,
    def: u8,
}
```

## Performance Guidelines

### Storage Optimization
| Pattern | When to Use | Trade-offs |
|---------|-------------|------------|
| `Introspect` (default) | Most models | Flexible upgrades, more storage |
| `IntrospectPacked` | Known fixed size | Less storage, limited upgrades |
| Single keys | Entity-specific data | Simple queries, efficient |
| Composite keys | Relationships | Complex queries, relationship modeling |

### Key Design Patterns
```cairo
// Single key for entity data
#[dojo::model]
struct Player {
    #[key]
    player_id: u64,
    username: String,
    score: u32,
}

// Composite key for relationships
#[dojo::model]
pub struct Beast {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub beast_id: u16,
    pub level: u8,
}

// Constant key for global settings
const GAME_SETTINGS_ID: u32 = 999999999;
#[dojo::model]
struct GameSettings {
    #[key]
    game_settings_id: u32,
    combat_cool_down: u32,
}
```

## Security & Validation

### Assertion Strategies
```cairo
// Implement validation traits
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

// Use Zero pattern for existence checks
pub impl ZeroablePlayerTrait of Zero<Player> {
    #[inline(always)]
    fn zero() -> Player {
        Player {
            address: constants::ZERO_ADDRESS(),
            current_beast_id: 0,
            battles_won: 0,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Player) -> bool {
        *self.address == constants::ZERO_ADDRESS()
    }
}
```

### Testing Patterns
```cairo
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_model_creation() {
        let player = Player { address: ADDRESS(), score: 100 };
        assert_eq!(player.score, 100);
    }
    
    #[test]
    fn test_validation() {
        let player = Player::zero();
        assert!(player.is_zero());
    }
}
```

## Upgrade Safety

### Safe Changes
- Adding new fields at the model's end
- Adding new methods to traits
- Changing method implementations

### Unsafe Changes
- Removing or reordering fields
- Changing field types
- Modifying key structure
- Changing from `Introspect` to `IntrospectPacked`