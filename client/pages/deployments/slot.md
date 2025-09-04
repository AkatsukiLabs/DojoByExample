# Deploy using Slot

Slot is a managed service that provides hosted Katana instances and Torii indexers for Dojo games. This guide covers the complete deployment workflow from authentication to production deployment.

## Prerequisites

Ensure you have the latest Dojo version installed:

```bash
dojoup
```

## Authentication Setup

### Initial Login

First, authenticate with the Slot service:

```bash
slot auth login
```

This will open your browser for authentication. Follow the prompts to complete the login process.

### Troubleshooting Authentication

If you encounter issues with old credentials, clear them and try again:

```bash
rm ~/Library/Application\ Support/slot/credentials.json
slot auth login
```

## Backend Deployment (Katana)

### Initialize Your Project

Start by creating a new Dojo project or navigate to your existing project:

```bash
sozo init dojo-starter && cd dojo-starter
```

### Create Katana Deployment

Deploy a Katana instance using Slot:

```bash
slot deployments create my-dojo-game katana
```

Replace `my-dojo-game` with your preferred deployment name. This command will:
- Create a new Katana instance
- Return an RPC endpoint URL
- Provide unique account credentials

### Configure Your Project

After deployment, you'll receive an RPC URL. Update your `Scarb.toml` configuration:

```toml
[tool.dojo.env]
rpc_url = "https://api.cartridge.gg/x/your-deployment-id/katana"
account_address = "0x..."  # From Katana deployment logs
private_key = "0x..."      # From Katana deployment logs
world_address = "0x..."    # Will be set after migration
```

> **Note:** Each Katana slot generates unique account seeds, so you'll need to update these values for each deployment.

### Monitor Katana Logs

Stream logs from your Katana deployment in a separate terminal:

```bash
slot deployments logs my-dojo-game katana -f
```

This will show real-time logs and display the account information you need for configuration.

### Build and Migrate

Build your Dojo project:

```bash
sozo build
```

Migrate your contracts to the deployed Katana instance:

```bash
sozo migrate
```

Upon successful migration, you'll see output similar to:

```
✅ Successfully migrated World at address: 0x1234567890abcdef...
```

Save this `WORLD_ADDRESS` as you'll need it for Torii deployment.

## Torii Indexer Deployment

### Deploy Torii Instance

Deploy a Torii indexer for your world using the world address from the previous step:

```bash
slot deployments create my-dojo-game torii \
  --world 0x1234567890abcdef... \
  --rpc https://api.cartridge.gg/x/your-deployment-id/katana \
  --start-block 1
```

**Parameter explanations:**
- `--world`: The world contract address from your migration
- `--rpc`: Your Katana RPC endpoint
- `--start-block`: Block number to start indexing from (use 1 for complete history)

After successful deployment, you'll receive:
- GraphQL endpoint for queries
- gRPC endpoint for real-time subscriptions

### Monitor Torii Logs

Stream logs from your Torii deployment:

```bash
slot deployments logs my-dojo-game torii -f
```

This helps verify that the indexer is properly syncing with your world state.

## Verification and Testing

### Test Your Deployment

1. **Verify Katana is running**: Check that your RPC endpoint responds to requests
2. **Confirm world deployment**: Ensure your contracts are properly migrated
3. **Test Torii indexing**: Verify that GraphQL queries return expected data

### Access Your Services

Your deployed services will be available at:
- **Katana RPC**: `https://api.cartridge.gg/x/your-deployment-id/katana`
- **Torii GraphQL**: `https://api.cartridge.gg/x/your-deployment-id/torii/graphql`
- **Torii gRPC**: `https://api.cartridge.gg/x/your-deployment-id/torii`

## Managing Deployments

### List Deployments

View all your active deployments:

```bash
slot deployments list
```

### Delete Deployments

Remove deployments when no longer needed:

```bash
slot deployments delete my-dojo-game katana
slot deployments delete my-dojo-game torii
```

## Best Practices

1. **Consistent Naming**: Use the same `DEPLOYMENT_NAME` for both Katana and Torii instances
2. **Monitor Logs**: Keep log streams open during initial deployment to catch issues early
3. **Update Configuration**: Always update your local configuration files with new endpoints
4. **Version Control**: Don't commit private keys or sensitive configuration to version control

## Troubleshooting

### Common Issues

1. **Authentication failures**: Clear credentials and re-authenticate
2. **Migration errors**: Verify RPC URL and account configuration
3. **Torii sync issues**: Check that world address and RPC URL are correct

### Getting Help

If you encounter issues:
1. Check deployment logs for error messages
2. Verify all configuration values are correct
3. Ensure you're using the latest Dojo version

---

🎉 **Congratulations!** You now have a fully deployed Dojo game with both Katana sequencer and Torii indexer running on Slot's managed infrastructure. Your game is ready for development and testing with persistent, hosted services.
