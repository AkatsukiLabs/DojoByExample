import { defineConfig } from "vocs";
import { routes } from "./routes";
import remarkMath from "remark-math";
import rehypeKatex from "rehype-katex";

// Shiki currently does not support cairo
// We temporarily use shiki fine grained bundle with custom cairo grammar
// This require custom highlighter, and patch of vocs to remove initial shiki instance

export default defineConfig({
  iconUrl: "/svg/Icon_Light.svg",
  // iconUrl: {
  //   light: "/svg/Icon_Light.svg",
  //   dark: "/svg/Icon_Dark.svg",
  // },
  logoUrl: {
    light: "/svg/Horizontal_Light.svg",
    dark: "/svg/Horizontal_Dark.svg",
  },
  title: "Dojo by Example",
  rootDir: ".",
  sidebar: routes,
  editLink: {
    text: "Contribute",
    pattern:
      "https://github.com/AkatsukiLabs/DojoByExample",
  },
  socials: [
    {
      icon: "github",
      link: "https://github.com/AkatsukiLabs/DojoByExample",
    },
    {
      icon: "telegram",
      link: "https://t.me/+8T2gw4hgblowZTBh",
    },
    {
      icon: "x",
      link: "",
    },
  ],
  sponsors: [
    {
      name: "Powered by",
      height: 60,
      items: [
        [
          {
            name: "Cartridge",
            link: "https://docs.cartridge.gg/",
            image: "/collaborators/cartridge.svg",
          },
        ],
        [
          {
            name: "Starknet",
            link: "https://www.starknet.io",
            image: "/collaborators/Starknet.svg",
          },
          {
            name: "Onlydust",
            link: "https://app.onlydust.com/p/starknet-by-example",
            image: "/collaborators/Onlydust.svg",
          },
        ],
      ],
    },
    {
      name: "Ecosystem toolings",
      items: [
        [
          {
            name: "Dojo",
            link: "https://book.dojoengine.org/",
            image: "/collaborators/DojoLogo.svg",
          },
        ],
        [
          {
            name: "Katana",
            link: "https://book.dojoengine.org/toolchain/katana",
            image: "/collaborators/KatanaLogo.svg",
          },
          {
            name: "Sozo",
            link: "https://book.dojoengine.org/toolchain/sozo",
            image: "/collaborators/SozoLogo.svg",
          },
          {
            name: "Torii",
            link: "https://book.dojoengine.org/toolchain/torii",
            image: "/collaborators/ToriiLogo.svg",
          },
          {
            name: "Origami",
            link: "https://book.dojoengine.org/libraries/origami",
            image: "/collaborators/OrigamiLogo.svg",
          },
          {
            name: "Saya",
            link: "https://book.dojoengine.org/toolchain/saya",
            image: "/collaborators/SayaLogo.svg",
          },
        ],
      ],
    },
  ],
  // Theme configuration
  theme: {
    accentColor: {
      dark: "#ff3000",
      light: "#ff3000",
    },
  },
  font: {
    google: "DM Sans",
  },
  markdown: {
    code: {
      themes: {
        light: "github-light",
        dark: "github-dark-dimmed",
      },
    },
    remarkPlugins: [remarkMath],
    rehypePlugins: [
      [
        rehypeKatex,
        {
          strict: false,
          displayMode: false,
          output: "mathml",
        },
      ],
    ],
  },
});
