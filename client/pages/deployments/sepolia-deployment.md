# Sepolia Testnet Deployment Guide

After deploying dozens of Dojo games to Sepolia over the past months, I've put together this guide to help you avoid the pitfalls I encountered. Whether you're shipping your first game or your tenth, this walkthrough covers everything you need to know about Sepolia deployment.

## Configuration Files Overview

When I first started with Dojo, the configuration files seemed overwhelming. Here's what I wish someone had explained to me about each one:

### 1. dojo_sepolia.toml - Dojo World Configuration

This file defines your Dojo world settings specifically for Sepolia deployment:

```toml
[world]
name = "Combat Game"
description = "Combat Game is an example game to show Dojo/Cairo capabilities/features to onboard new devs in the ecosystem in a smooth way. Built using Dojo Engine and Cartridge Controller on Starknet."
seed = "combat_game"

[namespace]
default = "combat_game"

[env]
rpc_url = "https://api.cartridge.gg/x/starknet/sepolia"

[writers]
"combat_game" = ["combat_game-game"]
"combat_game-TrophyCreation" = ["combat_game-game"]
"combat_game-TrophyProgression" = ["combat_game-game"]
```

**Configuration Breakdown:**

- **`[world]` section**: Defines your game world metadata
  - `name`: Human-readable name for your game
  - `description`: Detailed description of your project
  - `seed`: Unique identifier for world generation (affects contract addresses)

- **`[namespace]` section**: Organizes your game components
  - `default`: Default namespace for your models and systems

- **`[env]` section**: Environment-specific settings
  - `rpc_url`: Sepolia RPC endpoint (using Cartridge's infrastructure)

- **`[writers]` section**: Defines which systems can write to which models
  - Maps model names to authorized systems for security

### 2. Scarb.toml - Project Configuration

This is your main project configuration file:

```toml
[package]
cairo-version = "2.9.2"
name = "combat_game"
version = "0.1.0"
edition = "2023_11"

[cairo]
sierra-replace-ids = true

[scripts]
sepolia = "sozo --profile sepolia clean && sozo --profile sepolia build && sozo --profile sepolia migrate --account-address $DEPLOYER_ACCOUNT_ADDRESS --private-key $DEPLOYER_PRIVATE_KEY --fee strk"

[dependencies]
dojo = { git = "https://github.com/dojoengine/dojo", tag = "v1.2.1" }
achievement = { git = "https://github.com/cartridge-gg/arcade", tag = "v1.2.1" }

[[target.starknet-contract]]
build-external-contracts = [
    "dojo::world::world_contract::world",
    "achievement::events::index::e_TrophyCreation", 
    "achievement::events::index::e_TrophyProgression", 
]

[dev-dependencies]
cairo_test = "2.9.2"
dojo_cairo_test = { git = "https://github.com/dojoengine/dojo", tag = "v1.2.1" }

[profile.sepolia]
```

**Configuration Breakdown:**

- **`[package]` section**: Basic project metadata
  - `cairo-version`: Specific Cairo compiler version
  - `name`: Project name (must match your namespace)
  - `version`: Project version for tracking
  - `edition`: Cairo language edition

- **`[cairo]` section**: Cairo compiler settings
  - `sierra-replace-ids`: Optimizes contract compilation

- **`[scripts]` section**: Custom deployment commands
  - `sepolia`: Complete deployment pipeline command

- **`[dependencies]` section**: External libraries
  - `dojo`: Core Dojo framework
  - `achievement`: Achievement system integration

- **`[[target.starknet-contract]]` section**: Contract build configuration
  - `build-external-contracts`: Additional contracts to include

- **`[profile.sepolia]` section**: Sepolia-specific overrides

### 3. torii_config.toml - Indexer Configuration

This file configures Torii, the Dojo indexer for your deployed world:

```toml
# The World address to index.
world_address = ""
 
# Default RPC URL configuration
rpc = "https://api.cartridge.gg/x/starknet/sepolia"

# Indexing Options
[indexing]
allowed_origins = ["*"]
transactions = true
pending = true
polling_interval = 1000
contracts = []

[events]
raw = true

[sql]
historical = ["combat_game-TrophyProgression"]
```

**Configuration Breakdown:**

- **`world_address`**: Your deployed world contract address (filled after deployment)
- **`rpc`**: Same RPC endpoint as your dojo_sepolia.toml
- **`[indexing]` section**: Controls what data to index
  - `allowed_origins`: CORS settings for web access
  - `transactions`: Index transaction data
  - `pending`: Include pending transactions
  - `polling_interval`: How often to check for new data (milliseconds)

## Step-by-Step Deployment Process

### Prerequisites

Before deploying to Sepolia, ensure you have:

1. **Dojo toolchain installed** (sozo, katana, torii)
2. **Starknet account** with Sepolia ETH
3. **Environment variables** set up
4. **Project built locally** and tested

### Step 1: Set Up Environment Variables

Create a `.env` file in your project root (never commit this file):

```bash
# Your Starknet account address on Sepolia
DEPLOYER_ACCOUNT_ADDRESS=0x1234567890abcdef...

# Your account's private key (keep this secure!)
DEPLOYER_PRIVATE_KEY=0xabcdef1234567890...

# Optional: Custom RPC endpoint
STARKNET_RPC_URL=https://api.cartridge.gg/x/starknet/sepolia
```

**⚠️ Hard-learned lesson**: I once accidentally committed a private key to GitHub. Don't be me - always use environment variables and add `.env` to your `.gitignore`!

### Step 2: Get Sepolia ETH

Getting Sepolia ETH can be frustrating - faucets often have daily limits. Here's what works:

1. **Multiple faucets** (bookmark these, you'll need them):
   - [Starknet Faucet](https://faucet.goerli.starknet.io/) - Usually the most reliable
   - [Alchemy Faucet](https://sepoliafaucet.com/) - Good backup option

2. **Bridge from Ethereum Sepolia** (if you have some):
   - [Starknet Bridge](https://sepolia.starkgate.starknet.io/) - Takes ~10 minutes

**Pro tip**: Request from multiple faucets early in your development cycle. You'll burn through test ETH faster than you think!

### Step 3: Build Your Project

First, clean and build your project:

```bash
# Clean previous builds
sozo --profile sepolia clean

# Build for Sepolia
sozo --profile sepolia build
```

This compiles your Cairo code and prepares it for deployment.

### Step 4: Deploy to Sepolia

Run the deployment command:

```bash
# Using the custom script from Scarb.toml
scarb run sepolia

# Or manually with environment variables
sozo --profile sepolia migrate \
  --account-address $DEPLOYER_ACCOUNT_ADDRESS \
  --private-key $DEPLOYER_PRIVATE_KEY \
  --fee strk
```

**What's happening behind the scenes:**
1. Sozo connects to Sepolia (this can take 30+ seconds sometimes)
2. Deploys your World contract (the expensive part)
3. Registers each model and system individually
4. Sets up all the permissions from your writers config
5. Spits out contract addresses (save these somewhere!)

The whole process usually takes 2-5 minutes. Grab some coffee ☕

### Step 5: Update Torii Configuration

After successful deployment, update your `torii_config.toml`:

```toml
# Replace with your actual deployed world address
world_address = "0x1234567890abcdef..."
```

### Step 6: Start Torii Indexer

Start the indexer to make your world data queryable:

```bash
# Start Torii with your configuration
torii --config torii_config.toml
```

### Step 7: Verify Deployment

Test your deployment:

```bash
# Check world info
sozo --profile sepolia world info

# List deployed models
sozo --profile sepolia model list

# List deployed systems
sozo --profile sepolia system list
```

## Local vs Testnet Configuration Differences

| Aspect | Local Development | Sepolia Testnet |
|--------|------------------|-----------------|
| **RPC URL** | `http://localhost:5050` | `https://api.cartridge.gg/x/starknet/sepolia` |
| **Account** | Katana pre-funded accounts | Your Starknet account with Sepolia ETH |
| **Deployment Speed** | Instant | 10-30 seconds per transaction |
| **Cost** | Free | Requires Sepolia ETH |
| **Persistence** | Lost on restart | Permanent until testnet reset |
| **Accessibility** | Local only | Publicly accessible |
| **Network ID** | Custom | Sepolia network ID |

## Common Issues and Troubleshooting

These are the issues that have cost me the most time. Learn from my mistakes:

### Issue 1: "Insufficient Balance" Error

**The classic mistake** - I've hit this more times than I care to admit.

**Quick fix**:
```bash
# Check your balance first
starkli balance $DEPLOYER_ACCOUNT_ADDRESS --rpc https://api.cartridge.gg/x/starknet/sepolia

# If you're broke, hit the faucets again
# Most have 24-hour cooldowns, so plan ahead
```

**Real talk**: A full deployment costs around 0.01-0.05 Sepolia ETH. Always keep more than you think you need.

### Issue 2: "Account Not Found" Error

**Problem**: Account address doesn't exist on Sepolia

**Solutions**:
```bash
# Verify account exists
starkli account fetch $DEPLOYER_ACCOUNT_ADDRESS --rpc https://api.cartridge.gg/x/starknet/sepolia

# Deploy account if needed
starkli account deploy /path/to/account.json --rpc https://api.cartridge.gg/x/starknet/sepolia
```

### Issue 3: "RPC Connection Failed"

**This one's usually network-related** - Sepolia RPC endpoints can be flaky.

**Debug steps**:
```bash
# Test if the RPC is actually responding
curl -X POST https://api.cartridge.gg/x/starknet/sepolia \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"starknet_chainId","params":[],"id":1}'

# Should return something like: {"jsonrpc":"2.0","result":"0x534e5f5345504f4c4941","id":1}
```

**If that fails**: Try switching to a different RPC endpoint or check if you're behind a corporate firewall.

### Issue 4: "Build Failed" Error

**Problem**: Compilation errors in Cairo code

**Solutions**:
```bash
# Check Cairo version compatibility
scarb --version

# Update dependencies
scarb update

# Clean and rebuild
sozo clean && sozo build

# Check for syntax errors in src/
```

### Issue 5: "Migration Failed" Error

**Problem**: Deployment transaction failed

**Solutions**:
```bash
# Check transaction details
sozo --profile sepolia migrate --dry-run

# Increase gas limit
sozo --profile sepolia migrate --max-fee 1000000000000000

# Verify account permissions
# Check for naming conflicts
```

### Issue 6: "Torii Connection Issues"

**Problem**: Indexer cannot connect to deployed world

**Solutions**:
```bash
# Verify world address in torii_config.toml
# Check RPC URL matches deployment
# Ensure world is fully deployed
# Restart Torii with verbose logging
torii --config torii_config.toml --log-level debug
```

## Best Practices (Learned the Hard Way)

### 1. Version Control Hygiene
- **Never, ever commit private keys** - I use a pre-commit hook to catch this
- Keep a `.env.example` file with dummy values for your team
- Tag your releases before deploying - makes rollbacks easier
- Save deployment logs somewhere accessible

### 2. Testing Workflow That Actually Works
- Always test on local Katana first (saves time and ETH)
- Deploy to Sepolia when you think it's ready
- Test with at least 2-3 different accounts - single-player testing misses a lot
- Have someone else play your game before you call it done

### 3. Resource Management
- Check your Sepolia ETH balance before starting (learned this one the hard way)
- Deploy during off-peak hours when gas is cheaper
- Clean up old test deployments - your future self will thank you

### 4. Security Stuff
- Use a dedicated deployment account, not your main wallet
- Rotate keys if you suspect they're compromised
- Monitor your deployed contracts - set up alerts if possible

### 5. Documentation (Trust Me on This)
- Keep a deployment log with addresses and dates
- Document any config changes you make
- Share testnet links in your team chat - makes testing easier

## What's Next?

Once you've got your game running on Sepolia:

1. **Hook up your frontend** - Update your client to point to Sepolia instead of localhost
2. **Get people to break it** - Share the link in Discord, Twitter, wherever. Fresh eyes find bugs you missed
3. **Watch the gas costs** - Sepolia gas prices mirror mainnet, so optimize now
4. **Start planning mainnet** - But don't rush it. Better to over-test on Sepolia than debug on mainnet

## Additional Resources

- [Dojo Book](https://book.dojoengine.org/) - Official Dojo documentation
- [Starknet Documentation](https://docs.starknet.io/) - Starknet developer resources
- [Cairo Book](https://book.cairo-lang.org/) - Cairo language reference
- [Cartridge Documentation](https://docs.cartridge.gg/) - Cartridge controller integration

## When You Get Stuck

Hit a wall? Here's where I go for help:

1. **[Dojo Discord](https://discord.gg/dojoengine)** - The community is super helpful, usually get answers within hours
2. **[GitHub Issues](https://github.com/dojoengine/dojo/issues)** - Search first, your problem might already be solved
3. **[Starknet Forum](https://community.starknet.io/)** - Good for deeper technical discussions

**Final reminder**: Sepolia is your playground. Break things, experiment, learn. That's what it's for. Just don't get too attached to your testnet deployments - they're not forever! 🚀 