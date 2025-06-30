# Cartridge Controller Connector

## 📌 File Overview & Purpose

```ts
import { Connector } from "@starknet-react/core";
import { ControllerConnector } from "@cartridge/connector";
import {
  ColorMode,
  SessionPolicies,
  ControllerOptions,
} from "@cartridge/controller";
import { constants } from "starknet";

const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;

const CONTRACT_ADDRESS_GAME =
  "0x36a518498c1d7de4106b8904f0878e1e7b78c73614001fba22eba0adca80387";

const policies: SessionPolicies = {
  contracts: {
    [CONTRACT_ADDRESS_GAME]: {
      methods: [
        { name: "spawn_player", entrypoint: "spawn_player" },
        { name: "reward_player", entrypoint: "reward_player" },
      ],
    },
  },
};

// Controller basic configuration
const colorMode: ColorMode = "dark";
const theme = "golem-runner";

const options: ControllerOptions = {
  chains: [
    {
      rpcUrl: "https://api.cartridge.gg/x/starknet/sepolia",
    },
  ],
  defaultChainId:
    VITE_PUBLIC_DEPLOY_TYPE === "mainnet"
      ? constants.StarknetChainId.SN_MAIN
      : constants.StarknetChainId.SN_SEPOLIA,
  policies,
  theme,
  colorMode,
  namespace: "golem_runner",
  slot: "golem7",
};

const cartridgeConnector = new ControllerConnector(
  options
) as never as Connector;

export default cartridgeConnector;
```

The `cartridgeConnector.tsx` file initializes and exports a configured `ControllerConnector` instance. This is essential for enabling secure, seamless interactions between your Dojo game and the Starknet blockchain via Cartridge.

- It defines the RPC and network settings.
- Pre-authorizes smart contract method calls using session policies.
- Connects with Starknet React through a `Connector` interface.

---

## 📦 Imports and Dependencies

```ts
import { Connector } from "@starknet-react/core";
import { ControllerConnector } from "@cartridge/connector";
import {
  ColorMode,
  SessionPolicies,
  ControllerOptions,
} from "@cartridge/controller";
import { constants } from "starknet";
```

**Explanation:**

- `Connector` — Interface for wallet connectors in `@starknet-react/core`.
- `ControllerConnector` — Implements the `Connector` interface for Cartridge Controller.
- `ColorMode`, `SessionPolicies`, `ControllerOptions` — Type definitions for styling and access control.
- `constants` — Provides network chain IDs (e.g., `SN_SEPOLIA`, `SN_MAIN`).

---

## 🌍 Environment Configuration

```ts
const { VITE_PUBLIC_DEPLOY_TYPE } = import.meta.env;
```

This variable controls the target deployment environment:

- `mainnet`: Starknet main network
- `sepolia`: Starknet Sepolia testnet

This pattern allows safe, environment-specific configuration via `.env` files.

---

## 📜 Contract Address Resolution

```ts
const CONTRACT_ADDRESS_GAME =
  "0x36a518498c1d7de4106b8904f0878e1e7b78c73614001fba22eba0adca80387";
```

Here, the contract address is hardcoded. In a more dynamic setup, it's advisable to resolve this from a manifest:

```ts
import { manifest } from "./manifest";
const getGameContractAddress = () => manifest.contracts[0].address;
```

### Why Manifest?

The `manifest.json` file in Dojo contains deployment metadata for contracts. Using it ensures flexibility across networks.

---

## 🛡️ Session Policies Configuration

```ts
const policies: SessionPolicies = {
  contracts: {
    [CONTRACT_ADDRESS_GAME]: {
      methods: [
        { name: "spawn_player", entrypoint: "spawn_player" },
        { name: "reward_player", entrypoint: "reward_player" },
      ],
    },
  },
};
```

### What are session policies?

Session policies define which contract methods can be invoked by the connected user **without explicit approval** each time. This improves UX by reducing wallet prompts.

### Customizing:

To add more methods:

```ts
{ name: "train", entrypoint: "train" }
```

To support multiple contracts:

```ts
contracts: {
  [address1]: { methods: [...] },
  [address2]: { methods: [...] },
}
```

---

## 🎨 Controller Options Configuration

```ts
const colorMode: ColorMode = "dark";
const theme = "golem-runner";

const options: ControllerOptions = {
  chains: [
    {
      rpcUrl: "https://api.cartridge.gg/x/starknet/sepolia",
    },
  ],
  defaultChainId:
    VITE_PUBLIC_DEPLOY_TYPE === "mainnet"
      ? constants.StarknetChainId.SN_MAIN
      : constants.StarknetChainId.SN_SEPOLIA,
  policies,
  theme,
  colorMode,
  namespace: "golem_runner",
  slot: "golem7",
};
```

### Explanation of fields:

- `chains`: RPC URLs for supported Starknet chains
- `defaultChainId`: Auto-selects the chain based on environment
- `policies`: Session policies defined earlier
- `theme`, `colorMode`: UI appearance control
- `namespace`: Cartridge app namespace (must be registered on Cartridge)
- `slot`: Specific session or app slot for isolation

---

## 🔗 Connector Instantiation

```ts
const cartridgeConnector = new ControllerConnector(
  options
) as never as Connector;
```

This line creates the actual connector using your `options`. The TypeScript casting (`as never as Connector`) ensures compatibility with `@starknet-react/core` expectations.

### Usage in App:

```ts
<StarknetProvider connectors={[cartridgeConnector]}>
  <App />
</StarknetProvider>
```

---
