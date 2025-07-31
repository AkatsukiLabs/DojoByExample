# Models Patterns and Integration

Welcome to the **Models Patterns and Integration** guide! This document focuses on advanced model patterns and practical integration techniques for building complex game logic in Dojo Engine. If you're new to models, start with the [Models Basics](../models.md) guide first.

This guide covers essential patterns for production game development, including trait implementations, systems integration, and real-world battle system examples.

## Model Traits and Common Patterns

### The Zero Pattern

The Zero pattern is fundamental for model initialization and validation. It provides a standardized way to create "empty" model instances and check model existence.

```cairo
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

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

**Usage in Game Logic:**
```cairo
fn check_player_exists(world: IWorldDispatcher, player_address: ContractAddress) -> bool {
    let player = world.read_model(player_address);
    player.is_non_zero()
}

fn initialize_new_player(world: IWorldDispatcher, player_address: ContractAddress) {
    let existing_player = world.read_model(player_address);
    assert(existing_player.is_zero(), 'Player already exists');
    
    let new_player = Player {
        address: player_address,
        current_beast_id: 1,
        battles_won: 0,
        battles_lost: 0,
        last_active_day: get_current_day(),
        creation_day: get_current_day(),
    };
    
    world.write_model(@new_player);
}
```

### Custom Trait Generation with `#[generate_trait]`

Use `#[generate_trait]` to create model-specific validation and utility functions:

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

    #[inline(always)]
    fn assert_active(self: Player) {
        let current_day = get_current_day();
        assert(current_day - self.last_active_day <= 7, 'Player: Inactive too long');
    }
}
```

### Gaming-Specific Validation Patterns

Implement game-specific validation logic for common scenarios:

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
    pub health: u8,
    pub max_health: u8,
    pub beast_type: BeastType,
}

#[generate_trait]
pub impl BeastValidation of BeastValidationTrait {
    fn assert_alive(self: @Beast) {
        assert(*self.health > 0, 'Beast: Is dead');
    }

    fn assert_can_battle(self: @Beast) {
        self.assert_alive();
        assert(*self.level >= 5, 'Beast: Level too low for battle');
    }

    fn assert_can_evolve(self: @Beast) {
        assert(*self.level >= 10, 'Beast: Not ready to evolve');
        assert(*self.experience >= 1000, 'Beast: Insufficient experience');
    }

    fn is_elite(self: @Beast) -> bool {
        *self.level >= 50 && *self.experience >= 10000
    }
}
```

## Advanced Model Methods

### Implementing Custom Model Behaviors

Create sophisticated model behaviors that encapsulate game logic:

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

#[generate_trait]
pub impl PotionImpl of PotionTrait {
    fn new_potion(potion_id: u64, rarity: Rarity) -> Potion {
        let (power, effect) = match rarity {
            Rarity::Basic => (10, 1),
            Rarity::Uncommon => (25, 2),
            Rarity::Rare => (50, 3),
            Rarity::VeryRare => (100, 5),
        };
        
        Potion { 
            id: potion_id, 
            name: 'Health Potion', 
            effect, 
            rarity, 
            power 
        }
    }

    fn use_potion(self: @Potion, target_hp: u32, target_max_hp: u32) -> u32 {
        let healing = *self.power;
        let new_hp = target_hp + healing;
        
        if new_hp > target_max_hp {
            target_max_hp
        } else {
            new_hp
        }
    }

    fn is_rare(self: @Potion) -> bool {
        match self.rarity {
            Rarity::Rare | Rarity::VeryRare => true,
            _ => false,
        }
    }

    fn get_sell_value(self: @Potion) -> u32 {
        let base_value = match self.rarity {
            Rarity::Basic => 5,
            Rarity::Uncommon => 15,
            Rarity::Rare => 50,
            Rarity::VeryRare => 200,
        };
        base_value * (*self.power / 10)
    }
}
```

### Performance Considerations

Optimize model operations for gas efficiency:

```cairo
#[generate_trait]
pub impl BeastOptimized of BeastOptimizedTrait {
    // Batch operations to reduce gas costs
    fn level_up_with_rewards(
        ref self: Beast, 
        experience_gained: u16, 
        health_bonus: u8
    ) -> (bool, u8) { // Returns (leveled_up, new_level)
        self.experience += experience_gained;
        let old_level = self.level;
        
        // Calculate new level efficiently
        let new_level = min(100, old_level + (experience_gained / 100));
        
        if new_level > old_level {
            self.level = new_level;
            self.max_health += health_bonus * (new_level - old_level);
            self.health = self.max_health; // Full heal on level up
            (true, new_level)
        } else {
            (false, old_level)
        }
    }

    // Inline calculations for critical path operations
    #[inline(always)]
    fn calculate_damage_multiplier(self: @Beast, target_type: BeastType) -> u8 {
        if self.beast_type.is_effective_against(target_type) {
            150 // 1.5x damage
        } else if self.beast_type.is_weak_against(target_type) {
            75  // 0.75x damage
        } else {
            100 // 1.0x damage
        }
    }
}
```

## Models in ECS Context

### Entity Identification and Component Composition

Understanding how entities and models work together:

```cairo
// Entity: Player (identified by ContractAddress)
// ├── Player model (stats, battles won/lost)
// ├── Inventory model (items owned)  
// ├── Position model (location in game world)
// └── Beast model (current beast, composite key with beast_id)

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Inventory {
    #[key]
    player: ContractAddress,
    potions: u8,
    gold: u32,
    equipped_weapon: u16,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Position {
    #[key]
    player: ContractAddress,
    x: u32,
    y: u32,
    zone: felt252,
}
```

### Component Composition Patterns

Design entities with multiple focused models:

```cairo
fn get_complete_player_state(
    world: IWorldDispatcher, 
    player_address: ContractAddress
) -> (Player, Inventory, Position, Option<Beast>) {
    let player = world.read_model(player_address);
    let inventory = world.read_model(player_address);
    let position = world.read_model(player_address);
    
    // Beast uses composite key
    let beast = if player.current_beast_id > 0 {
        Option::Some(world.read_model((player_address, player.current_beast_id)))
    } else {
        Option::None
    };
    
    (player, inventory, position, beast)
}
```

## Systems Integration

### Reading Models from Systems

Efficient model querying patterns:

```cairo
fn validate_battle_participants(
    world: IWorldDispatcher,
    player_address: ContractAddress,
    opponent_address: ContractAddress
) -> (Player, Player, Beast, Beast) {
    // Read player models
    let player = world.read_model(player_address);
    let opponent = world.read_model(opponent_address);
    
    // Validate players exist and are active
    player.assert_exists();
    player.assert_active();
    opponent.assert_exists();
    opponent.assert_active();
    
    // Read beast models with composite keys
    let player_beast = world.read_model((player_address, player.current_beast_id));
    let opponent_beast = world.read_model((opponent_address, opponent.current_beast_id));
    
    // Validate beasts can battle
    player_beast.assert_can_battle();
    opponent_beast.assert_can_battle();
    
    (player, opponent, player_beast, opponent_beast)
}
```

### Writing Models with Error Handling

Safe model updates with rollback capabilities:

```cairo
fn update_player_inventory_safe(
    world: IWorldDispatcher,
    player_address: ContractAddress,
    gold_spent: u32,
    potions_used: u8
) {
    let mut inventory = world.read_model(player_address);
    
    // Validate sufficient resources
    assert(inventory.gold >= gold_spent, 'Insufficient gold');
    assert(inventory.potions >= potions_used, 'Insufficient potions');
    
    // Update inventory
    inventory.gold -= gold_spent;
    inventory.potions -= potions_used;
    
    // Write updated model
    world.write_model(@inventory);
}
```

### Batch Model Operations

Optimize multiple model updates:

```cairo
fn process_quest_completion(
    world: IWorldDispatcher,
    player_address: ContractAddress,
    experience_reward: u16,
    gold_reward: u32,
    item_reward: u16
) {
    // Read all required models
    let mut player = world.read_model(player_address);
    let mut inventory = world.read_model(player_address);
    let mut beast = world.read_model((player_address, player.current_beast_id));
    
    // Update player stats
    player.battles_won += 1;
    player.last_active_day = get_current_day();
    
    // Update inventory
    inventory.gold += gold_reward;
    inventory.potions += 1; // Bonus potion
    
    // Level up beast
    let (leveled_up, new_level) = beast.level_up_with_rewards(experience_reward, 5);
    
    // Write all updates (batch operation)
    world.write_model(@player);
    world.write_model(@inventory);
    world.write_model(@beast);
    
    // Emit events for client updates
    if leveled_up {
        emit!(world, BeastLevelUp { 
            player: player_address, 
            beast_id: player.current_beast_id,
            new_level 
        });
    }
}
```

## Practical Battle System Example

Here's a complete battle system demonstrating complex model coordination:

```cairo
fn execute_battle(
    world: IWorldDispatcher,
    player_address: ContractAddress,
    opponent_address: ContractAddress,
    skill_type: SkillType
) {
    // Validate and read all participants
    let (mut player, mut opponent, mut player_beast, mut opponent_beast) = 
        validate_battle_participants(world, player_address, opponent_address);
    
    // Calculate battle outcome
    let (damage, is_critical, is_super_effective) = calculate_battle_damage(
        @player_beast,
        @opponent_beast, 
        skill_type
    );
    
    // Apply damage with validation
    let final_damage = min(damage, opponent_beast.health.into());
    opponent_beast.health -= final_damage.try_into().unwrap();
    
    // Determine battle result
    let player_wins = opponent_beast.health == 0;
    
    if player_wins {
        // Update winner stats
        player.battles_won += 1;
        opponent.battles_lost += 1;
        
        // Experience and level up logic
        let exp_gained = calculate_experience_reward(@opponent_beast);
        let (leveled_up, new_level) = player_beast.level_up_with_rewards(exp_gained, 2);
        
        // Reward inventory updates
        let mut player_inventory = world.read_model(player_address);
        player_inventory.gold += calculate_gold_reward(@opponent_beast);
        world.write_model(@player_inventory);
        
        // Handle level up rewards
        if leveled_up {
            emit!(world, BeastLevelUp { 
                player: player_address, 
                beast_id: player.current_beast_id,
                new_level 
            });
        }
    } else {
        // Handle partial damage scenario
        player.battles_lost += 1;
        opponent.battles_won += 1;
        
        // Small experience gain for participation
        let (_, _) = player_beast.level_up_with_rewards(10, 0);
    }
    
    // Update activity timestamps
    let current_day = get_current_day();
    player.last_active_day = current_day;
    opponent.last_active_day = current_day;
    
    // Write all updated models
    world.write_model(@player);
    world.write_model(@opponent);
    world.write_model(@player_beast);
    world.write_model(@opponent_beast);
    
    // Emit battle result event
    emit!(world, BattleResult {
        player: player_address,
        opponent: opponent_address,
        winner: if player_wins { player_address } else { opponent_address },
        damage: final_damage,
        is_critical,
        is_super_effective
    });
}

// Helper functions for battle calculations
fn calculate_battle_damage(
    attacker: @Beast, 
    defender: @Beast, 
    skill_type: SkillType
) -> (u32, bool, bool) {
    let base_damage = (attacker.level.into() * 10) + skill_type.get_power();
    let type_multiplier = attacker.calculate_damage_multiplier(*defender.beast_type);
    let damage = (base_damage * type_multiplier.into()) / 100;
    
    // Critical hit calculation (10% chance)
    let is_critical = get_random_u8() < 26; // 10% of 256
    let final_damage = if is_critical { damage * 2 } else { damage };
    
    let is_super_effective = type_multiplier > 100;
    
    (final_damage, is_critical, is_super_effective)
}

fn calculate_experience_reward(defeated_beast: @Beast) -> u16 {
    let base_exp = *defeated_beast.level.into() * 15;
    min(base_exp, 500) // Cap at 500 exp per battle
}

fn calculate_gold_reward(defeated_beast: @Beast) -> u32 {
    let base_gold = *defeated_beast.level.into() * 5;
    base_gold + if defeated_beast.is_elite() { 100 } else { 0 }
}
```

## Advanced Pattern: State Machine Models

Implement complex game states using model patterns:

```cairo
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
enum GamePhase {
    Preparation,
    Battle,
    Resolution,
    Ended
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct GameSession {
    #[key]
    session_id: u64,
    player1: ContractAddress,
    player2: ContractAddress,
    current_phase: GamePhase,
    turn_count: u16,
    winner: ContractAddress,
}

#[generate_trait]
impl GameSessionImpl of GameSessionTrait {
    fn advance_phase(ref self: GameSession) {
        self.current_phase = match self.current_phase {
            GamePhase::Preparation => GamePhase::Battle,
            GamePhase::Battle => GamePhase::Resolution,
            GamePhase::Resolution => GamePhase::Battle, // Next turn
            GamePhase::Ended => GamePhase::Ended, // Stay ended
        };
        
        if matches!(self.current_phase, GamePhase::Resolution) {
            self.turn_count += 1;
        }
    }
    
    fn can_perform_action(self: @GameSession, player: ContractAddress, action: ActionType) -> bool {
        match (*self.current_phase, action) {
            (GamePhase::Preparation, ActionType::SelectBeast) => true,
            (GamePhase::Battle, ActionType::Attack | ActionType::UseItem) => true,
            (GamePhase::Resolution, ActionType::ViewResults) => true,
            _ => false,
        }
    }
}
```

## Optimizing Model Performance

### Memory Layout Optimization

Use `IntrospectPacked` for frequently accessed, fixed-size models:

```cairo
#[derive(Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct PlayerStats {
    #[key]
    player: ContractAddress,
    health: u8,
    mana: u8,
    level: u8,
    experience: u16,
}
```

### Lazy Loading Patterns

Load complex models only when needed:

```cairo
fn get_battle_ready_player(
    world: IWorldDispatcher, 
    player_address: ContractAddress
) -> (Player, Beast) {
    let player = world.read_model(player_address);
    
    // Only load beast if player has one
    if player.current_beast_id > 0 {
        let beast = world.read_model((player_address, player.current_beast_id));
        beast.assert_can_battle();
        (player, beast)
    } else {
        panic!("Player has no beast for battle");
    }
}
```

This comprehensive guide provides the patterns and integration techniques needed to build sophisticated game logic with Dojo models. Use these patterns as building blocks for your own game systems, adapting them to your specific requirements while maintaining the ECS principles that make Dojo powerful.