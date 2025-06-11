# Helpers Functions in Dojo Engine 🎮

## What are Helpers Functions 🤝 

Helper functions can be described as utility methods that could be useful or reusable; how does the word itself say "Helpers Functions" designed to assist other functions within a program. In Dojo Engine, helpers are defined in Cairo files like `pseudo_random.cairo`. 


## Why Use Helper Functions? 🛠️

- **Maintainability && performance:** They perform specific, often repetitive tasks, making the code cleaner, more readable and easier to maintain. 


- **Encapsulation && readability:** Essentially, they encapsulate functionality that can be used in multiple places without duplicating code or Code Smell. 


- **Provable logic reuse in Cairo::** In Dojo Engine, writing helper functions allows you to reuse deterministic logic (like random number generation, vector math, or bounds checking) across multiple systems or components, ensuring consistent and provable behavior across your game world.


## Real Example: `pseudo_random.cairo` helper function 👨🏾‍💻

- **Arguments**
  
   * `min`: The minimum value (inclusive) of the random number range.
   * `max`: The maximum value (inclusive) of the random number range.
   * `unique_id`: A unique identifier used to generate entropy for randomness.
   * `salt`: An additional value to modify the randomness, ensuring more variation.


Let's look at a real example of a helper function!!. 

### 1. Entropy Source

    ```cairo
        let block_timestamp = get_block_timestamp();
        let block_number = get_block_number();
    ```
 
It pulls block data (timestamp & block number) from Starknet, which is deterministic and accessible on-chain — a common approach to introducing pseudo-randomness in provable systems.

### 2. Seed Generation

  ```cairo
    let hash_state = PedersenTrait::new(0);
    let hash_state = hash_state.update(hash_input);
    let hash = hash_state.finalize();
  ```

Combines the entropy with the unique_id and salt values to customize randomness per entity or action. This makes the outcome feel unique and more secure against pattern repetition.


### 3. Hashing with Pedersen

  ```cairo
    let hash_state = PedersenTrait::new(0);
    let hash_state = hash_state.update(hash_input);
    let hash = hash_state.finalize();
  ```

Converts the combined seed into a hashed value. Pedersen hash is deterministic and efficient in Cairo, making it suitable for generating pseudo-random values.


### 4. Bounding the Random Value

  ```cairo
    let range: u64 = max.into() - min.into() + 1_u64.into();
    let mod_value: u64 = (hash_u256 % range.into()).try_into().unwrap();
    let random_value: u8 = mod_value.try_into().unwrap().wrapping_add(min);
  ```

Ensures the final output is within the user-defined [min, max] range, inclusive.

## Test Function Example:

  ```cairo
    // Tests the `generate_random_u8` function to ensure it returns a value within the specified range.

    // This test ensures that the random value generated is always between `min` and `max` inclusive.

    #[test]
    #[available_gas(1000000)]
    fn test_generate_random_u8() {
        let min: u8 = 5;
        let max: u8 = 10;
        let unique_id: u16 = 12345;
        let salt: u16 = 6789;
        let result = generate_random_u8(unique_id, salt, min, max);

        // Assert the result is within the specified range
        assert!(result >= min && result <= max, "Random number out of range");
    }
  ```

🔁 **Result**: 
This test guarantees that your pseudo-random function behaves safely and deterministically, always producing values between min and max, even as inputs change. This is a great example of how pure helpers can be tested in isolation, without setting up an entire game system or world context.

## Recommendations 📚

**Recommendations for Using Helpers in Dojo Engine**

Helper functions are powerful tools when used wisely. Here are some best practices to ensure your helpers in Dojo Engine stay clean, reusable, and effective:

---

### ✅ 1. **Keep Them Pure and Stateless**

Helpers should ideally avoid modifying global state or relying on side effects. This makes them easier to test, reason about, and reuse.

> Example: `generate_random_u8` is deterministic and depends only on its inputs and block data.

---

### 🧩 2. **Use Descriptive Names**

Name your helpers clearly to reflect what they do. This improves readability and avoids confusion when multiple helpers are imported across modules.

> Use names like `calculate_damage`, `spawn_enemy_with_strength`, `generate_loot_drop`, etc.

---

### ♻️ 3. **Encapsulate Repetitive Logic**

If you find yourself copying the same logic across multiple systems (e.g., hash generation, clamping values, seeding randomness), move it into a helper.

> This reduces "code smell" and improves maintainability.

---

### 🧪 4. **Test Them Independently**

Because helpers are stateless and modular, they’re great candidates for unit tests or simulation tests. This ensures their logic works without needing full system setup.

---

### 🚀 5. **Keep Game Logic in Systems, Not Helpers**

Helpers should **support** game logic, not **replace** it. Avoid embedding ECS actions (like setting components) directly in helpers — keep those in systems or world-dispatchers.

---

### 🗂️ 6. **Group Helpers by Domain**

Organize helpers by theme or module (`random.cairo`, `math_utils.cairo`, `combat_helpers.cairo`, etc.) to keep your project structured and navigable.

Absolutely! Here's a clear and concise **Conclusion** section you can use:

---

## Conclusion 🎯

Helper functions in Dojo Engine are essential tools for writing clean, reusable, and maintainable code. By encapsulating common logic like randomness, math operations, or entity behavior, they keep your systems focused and your codebase modular. When used thoughtfully, helpers enhance readability, reduce duplication, and make your on-chain game logic more robust and scalable.

> Think of helpers as the silent teammates behind your game's core systems — small, focused, and powerful.