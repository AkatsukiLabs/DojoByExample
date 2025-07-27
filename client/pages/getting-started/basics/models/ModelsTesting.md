# Models Testing Documentation

Welcome to the **Models Testing** guide for Dojo Engine! This comprehensive guide focuses specifically on testing strategies and patterns for Dojo models in game development. Whether you're new to testing Cairo models or looking to improve your testing practices, this guide provides practical examples and proven patterns for testing game models effectively.

## Table of Contents
- [Testing Fundamentals](#testing-fundamentals)
- [Basic Model Testing](#basic-model-testing)
- [Advanced Model Testing](#advanced-model-testing)
- [Gaming-Specific Testing Scenarios](#gaming-specific-testing-scenarios)

## Testing Fundamentals

### Model Testing Overview and Importance

Testing models in Dojo is crucial for ensuring the reliability of your game's data integrity and business logic. Models represent the state of your game entities, and proper testing helps catch bugs early, validates data integrity, and ensures your game logic behaves as expected.

Key reasons for model testing:
- **Data Integrity**: Ensure model fields are initialized and updated correctly
- **Business Logic Validation**: Verify custom traits and methods work as intended
- **Regression Prevention**: Catch breaking changes when models change
- **Documentation**: Tests serve as executable documentation for model behavior

### Cairo Testing Framework Basics for Models

Dojo uses the Cairo testing framework with specific enhancements. All model tests should be organized using the standard Cairo testing structure:

```cairo
#[cfg(test)]
mod tests {
    // Import the model and its traits
    use super::*;
    
    #[test]
    #[available_gas(300000)]
    fn test_model_functionality() {
        // Test implementation goes here
    }
}
```

### Test Block Structure and Organization

Structure your model tests in a logical hierarchy:

1. **Unit Tests**: Test individual model functionality in the same file as the model
2. **Integration Tests**: Test model interactions with systems in separate test files
3. **Property Tests**: Test model traits and custom implementations

### Gas Considerations and Test Attributes

Start with a reasonable gas limit and adjust based on your test complexity:
- Begin with `#[available_gas(100000)]` for simple tests
- Increase as needed if you get "out of gas" errors
- Use `#[available_gas(300000)]` or higher for complex operations

### Setting Up Test Environments for Game Models

For models that interact with the world contract, use the Dojo testing utilities:

```cairo
use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
use dojo::world::{WorldStorage, WorldStorageTrait};
use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource};
```

## Basic Model Testing

### Testing Model Initialization and Creation

Test that your models can be properly created with valid initial values:

```cairo
#[cfg(test)]
mod tests {
    use super::{Position, Vec2, Vec2Trait};
    
    #[test]
    #[available_gas(100000)]
    fn test_position_initialization() {
        let position = Position { 
            player: starknet::contract_address_const::<0x123>(),
            vec: Vec2 { x: 10, y: 20 }
        };
        
        assert_eq!(position.vec.x, 10, "X coordinate should be 10");
        assert_eq!(position.vec.y, 20, "Y coordinate should be 20");
    }
}
```

### Testing Field Assignments and Validation

Verify that model fields can be properly assigned and maintain their values:

```cairo
#[test]
#[available_gas(100000)]
fn test_player_stats_assignment() {
    let player = Player {
        address: starknet::contract_address_const::<0x456>(),
        current_beast_id: 5,
        battles_won: 10,
        battles_lost: 3,
        last_active_day: 100,
        creation_day: 1,
    };
    
    assert_eq!(player.battles_won, 10, "Battles won should be 10");
    assert_eq!(player.battles_lost, 3, "Battles lost should be 3");
    assert_eq!(player.current_beast_id, 5, "Current beast ID should be 5");
}
```

### Testing Model Equality and Comparison

Test that models can be properly compared for equality:

```cairo
#[test]
#[available_gas(100000)]
fn test_vec_equality() {
    let vec1 = Vec2 { x: 420, y: 0 };
    let vec2 = Vec2 { x: 420, y: 0 };
    let vec3 = Vec2 { x: 421, y: 0 };
    
    assert!(vec1.is_equal(vec2), "Identical vectors should be equal");
    assert!(!vec1.is_equal(vec3), "Different vectors should not be equal");
}
```

### Testing Simple Model Operations

Test basic operations and transformations on model data:

```cairo
#[test]
#[available_gas(100000)]
fn test_vec_is_zero() {
    let zero_vec = Vec2 { x: 0, y: 0 };
    let non_zero_vec = Vec2 { x: 1, y: 2 };
    
    assert!(Vec2Trait::is_zero(zero_vec), "Zero vector should return true");
    assert!(!Vec2Trait::is_zero(non_zero_vec), "Non-zero vector should return false");
}
```

## Advanced Model Testing

### Testing Custom Traits and Implementations

Test custom trait implementations for your models:

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

#[cfg(test)]
mod potion_tests {
    use super::{Potion, PotionTrait, Rarity};
    
    #[test]
    #[available_gas(300000)]
    fn test_potion_creation() {
        let potion = PotionTrait::new_potion(1);
        
        assert_eq!(potion.id, 1, "Potion ID should be 1");
        assert_eq!(potion.name, 'Potion', "Potion name should be 'Potion'");
        assert_eq!(potion.rarity, Rarity::Basic, "Default rarity should be Basic");
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_potion_rarity_check() {
        let mut potion = PotionTrait::new_potion(1);
        
        // Test rare potion
        potion.rarity = Rarity::VeryRare;
        assert_eq!(potion.is_rare(), true, "VeryRare should return true");
        
        potion.rarity = Rarity::Rare;
        assert_eq!(potion.is_rare(), true, "Rare should return true");
        
        // Test common potion
        potion.rarity = Rarity::Uncommon;
        assert_eq!(potion.is_rare(), false, "Uncommon should return false");
        
        potion.rarity = Rarity::Basic;
        assert_eq!(potion.is_rare(), false, "Basic should return false");
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_potion_use_effect() {
        let potion = Potion {
            id: 1,
            name: 'Healing Potion',
            effect: 0,
            rarity: Rarity::Basic,
            power: 50
        };
        
        let initial_hp = 70;
        let new_hp = potion.use_potion(initial_hp);
        
        assert_eq!(new_hp, 120, "HP should increase by potion power");
    }
}
```

### Testing Model Validation Logic

Test custom validation methods like `assert_exists` and `assert_not_exists`:

```cairo
#[test]
#[available_gas(200000)]
fn test_player_existence_validation() {
    let existing_player = Player {
        address: starknet::contract_address_const::<0x123>(),
        current_beast_id: 1,
        battles_won: 5,
        battles_lost: 2,
        last_active_day: 50,
        creation_day: 1,
    };
    
    let empty_player = Player {
        address: constants::ZERO_ADDRESS(),
        current_beast_id: 0,
        battles_won: 0,
        battles_lost: 0,
        last_active_day: 0,
        creation_day: 1,
    };
    
    // Should not panic for existing player
    existing_player.assert_exists();
    
    // Should not panic for empty player
    empty_player.assert_not_exists();
    
    assert!(existing_player.is_non_zero(), "Existing player should be non-zero");
    assert!(empty_player.is_zero(), "Empty player should be zero");
}
```

### Testing Zero Pattern Implementations

Test the Zero trait implementation for proper initialization and validation:

```cairo
#[test]
#[available_gas(200000)]
fn test_zero_pattern() {
    let zero_player = Player::zero();
    
    assert_eq!(zero_player.address, constants::ZERO_ADDRESS(), "Zero player should have zero address");
    assert_eq!(zero_player.current_beast_id, 0, "Zero player should have zero beast ID");
    assert_eq!(zero_player.battles_won, 0, "Zero player should have zero battles won");
    assert_eq!(zero_player.creation_day, 1, "Zero player should have creation day 1");
    
    assert!(zero_player.is_zero(), "Zero player should return true for is_zero()");
    assert!(!zero_player.is_non_zero(), "Zero player should return false for is_non_zero()");
}
```

### Testing Custom Model Methods and Behaviors

Test complex model methods that involve calculations or state changes:

```cairo
#[test]
#[available_gas(300000)]
fn test_beast_level_calculation() {
    let mut beast = Beast {
        player: starknet::contract_address_const::<0x123>(),
        beast_id: 1,
        level: 1,
        experience: 0,
        beast_type: BeastType::Fire,
    };
    
    // Test experience gain and level up
    beast.gain_experience(150);
    assert_eq!(beast.experience, 150, "Experience should be updated");
    
    // Assuming level up happens at 100 XP
    assert_eq!(beast.level, 2, "Beast should level up to 2");
}
```

## Gaming-Specific Testing Scenarios

### Testing Player Stat Calculations and Updates

Test complex player statistics and progression systems:

```cairo
#[test]
#[available_gas(500000)]
fn test_player_battle_statistics() {
    let mut player = Player {
        address: starknet::contract_address_const::<0x123>(),
        current_beast_id: 1,
        battles_won: 10,
        battles_lost: 5,
        last_active_day: 100,
        creation_day: 1,
    };
    
    // Test win rate calculation
    let total_battles = player.battles_won + player.battles_lost;
    let win_rate = (player.battles_won * 100) / total_battles;
    assert_eq!(win_rate, 66, "Win rate should be 66%");
    
    // Test battle outcome updates
    player.record_battle_win();
    assert_eq!(player.battles_won, 11, "Battles won should increase");
    
    player.record_battle_loss();
    assert_eq!(player.battles_lost, 6, "Battles lost should increase");
}
```

### Testing Game State Transitions

Test how models change state during game progression:

```cairo
#[test]
#[available_gas(400000)]
fn test_game_state_progression() {
    let mut game_state = GameState {
        game_id: 1,
        status: GameStatus::WaitingForPlayers,
        turn_count: 0,
        current_player: starknet::contract_address_const::<0x0>(),
        max_players: 4,
        current_players: 0,
    };
    
    // Test joining game
    game_state.add_player(starknet::contract_address_const::<0x123>());
    assert_eq!(game_state.current_players, 1, "Player count should increase");
    
    // Test game start when enough players
    if game_state.current_players >= 2 {
        game_state.start_game();
        assert_eq!(game_state.status, GameStatus::InProgress, "Game should start");
        assert!(game_state.turn_count > 0, "Turn count should be initialized");
    }
}
```

### Testing Battle Mechanics and Combat Calculations

Test complex battle calculations and damage systems:

```cairo
#[test]
#[available_gas(600000)]
fn test_battle_damage_calculation() {
    let attacker_beast = Beast {
        player: starknet::contract_address_const::<0x123>(),
        beast_id: 1,
        level: 5,
        experience: 500,
        beast_type: BeastType::Fire,
    };
    
    let defender_beast = Beast {
        player: starknet::contract_address_const::<0x456>(),
        beast_id: 2,
        level: 4,
        experience: 400,
        beast_type: BeastType::Water,
    };
    
    // Test type effectiveness
    let (damage, is_favored, is_super_effective) = attacker_beast.attack(
        defender_beast.beast_type,
        SkillType::Beam,
        100
    );
    
    // Fire vs Water should not be favored
    assert!(!is_favored, "Fire should not be favored against Water");
    assert!(!is_super_effective, "Fire should not be super effective against Water");
    
    // Test damage calculation based on level difference
    let expected_damage = calculate_base_damage(attacker_beast.level, defender_beast.level);
    assert!(damage >= expected_damage * 80 / 100, "Damage should be within expected range");
}
```

### Testing Inventory and Item Management

Test inventory operations and item interactions:

```cairo
#[test]
#[available_gas(400000)]
fn test_inventory_management() {
    let mut inventory = Inventory {
        player: starknet::contract_address_const::<0x123>(),
        item_count: 0,
        max_capacity: 10,
    };
    
    // Test adding items
    let potion = Item {
        id: 1,
        item_type: ItemType::Potion,
        quantity: 5,
    };
    
    inventory.add_item(potion);
    assert_eq!(inventory.item_count, 1, "Item count should increase");
    
    // Test inventory capacity limits
    let result = inventory.can_add_item(ItemType::Weapon);
    assert!(result, "Should be able to add item when under capacity");
    
    // Fill inventory to test capacity
    inventory.item_count = inventory.max_capacity;
    let result = inventory.can_add_item(ItemType::Armor);
    assert!(!result, "Should not be able to add item when at capacity");
}
```

### Testing Achievement and Progression Systems

Test player achievements and milestone tracking:

```cairo
#[test]
#[available_gas(500000)]
fn test_achievement_system() {
    let mut player_progress = PlayerProgress {
        player: starknet::contract_address_const::<0x123>(),
        total_experience: 0,
        achievements_unlocked: 0,
        milestones_reached: 0,
    };
    
    // Test experience tracking
    player_progress.add_experience(1000);
    assert_eq!(player_progress.total_experience, 1000, "Experience should be tracked");
    
    // Test achievement unlocking
    if player_progress.total_experience >= 500 {
        player_progress.unlock_achievement(AchievementType::FirstHundredXP);
        assert_eq!(player_progress.achievements_unlocked, 1, "Achievement should be unlocked");
    }
    
    // Test milestone progression
    let milestone_reached = player_progress.check_milestone(MilestoneType::Level10);
    if milestone_reached {
        player_progress.milestones_reached += 1;
        assert!(player_progress.milestones_reached > 0, "Milestone should be recorded");
    }
}
```

### Integration Testing with World Contract

Test models in the context of the world contract:

```cairo
#[cfg(test)]
mod integration_tests {
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait};
    
    fn namespace_def() -> NamespaceDef {
        NamespaceDef {
            namespace: "game_models",
            resources: [
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Model(m_Beast::TEST_CLASS_HASH),
                TestResource::Model(m_Inventory::TEST_CLASS_HASH),
            ].span()
        }
    }
    
    #[test]
    fn test_world_model_interactions() {
        let caller = starknet::contract_address_const::<0x123>();
        let mut world = spawn_test_world(namespace_def().resources);
        
        // Test writing and reading models
        let player = Player {
            address: caller,
            current_beast_id: 1,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 1,
            creation_day: 1,
        };
        
        world.write_model(@player);
        let retrieved_player: Player = world.read_model(caller);
        
        assert_eq!(retrieved_player.address, caller, "Player address should match");
        assert_eq!(retrieved_player.current_beast_id, 1, "Beast ID should match");
    }
}
```

## Testing Best Practices for Game Models

### Consistent Naming Conventions

Use descriptive test names that clearly indicate what is being tested:

```cairo
#[test]
fn test_player_initialization_with_valid_data() { /* ... */ }

#[test]
fn test_battle_damage_calculation_with_type_advantage() { /* ... */ }

#[test]
fn test_inventory_capacity_limit_enforcement() { /* ... */ }
```

### Comprehensive Edge Case Testing

Always test boundary conditions and edge cases:

```cairo
#[test]
#[available_gas(300000)]
fn test_experience_overflow_protection() {
    let mut beast = Beast { /* ... */ };
    
    // Test maximum experience value
    beast.experience = u16::MAX;
    beast.gain_experience(1);
    
    // Should handle overflow gracefully
    assert!(beast.experience <= u16::MAX, "Experience should not overflow");
}
```

### Test Data Consistency

Ensure your test data represents realistic game scenarios:

```cairo
#[test]
fn test_realistic_battle_scenario() {
    // Use realistic level ranges (1-100)
    let attacker = create_test_beast(level: 25, beast_type: BeastType::Fire);
    let defender = create_test_beast(level: 23, beast_type: BeastType::Grass);
    
    // Test with realistic damage values
    let damage = calculate_damage(attacker, defender);
    assert!(damage > 0 && damage < 1000, "Damage should be within realistic range");
}
```

## Conclusion

Model testing is essential for building reliable and maintainable game systems in Dojo. By following the patterns and examples in this guide, you can create comprehensive test suites that catch bugs early, validate game logic, and provide confidence in your model implementations.

Remember to:
- Test both happy paths and edge cases
- Use realistic game data in your tests
- Test model interactions with the world contract
- Maintain your tests as your models evolve
- Use descriptive test names and clear assertions

Start with basic model testing and gradually expand to more complex scenarios as your game grows in complexity. Well-tested models form the foundation for reliable and enjoyable gaming experiences.