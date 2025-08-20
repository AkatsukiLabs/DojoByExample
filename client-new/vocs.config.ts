import { defineConfig } from 'vocs'
import { sidebar } from './src/routes'

export default defineConfig({
  // Basic configuration
  title: 'Dojo by Example',
  titleTemplate: '%s · Dojo by Example',
  description: 'Learn Dojo Engine through practical examples and comprehensive guides',
  
  // Logo configuration with theme switching
  iconUrl: {
    light: '/logos/Icon_Light.svg',
    dark: '/logos/Icon_Dark.svg',
  },
  logoUrl: {
    light: '/logos/Horizontal_Light.svg',
    dark: '/logos/Horizontal_Dark.svg',
  },
  
  // Theme configuration
  theme: {
    accentColor: {
      light: '#ff3000',
      dark: '#ff6b4a',
    },
    colorScheme: 'system', // Auto dark/light mode
  },
  
  // Font configuration
  font: {
    google: 'DM Sans',
  },
  
  // Social links
  socials: [
    {
      icon: 'github',
      link: 'https://github.com/AkatsukiLabs/DojoByExample',
    },
    {
      icon: 'telegram',
      link: 'https://t.me/+8T2gw4hgblowZTBh',
    },
    {
      icon: 'x',
      link: 'https://twitter.com/dojoengine',
    },
  ],
  
  // Top navigation configuration
  topNav: [
    { text: 'Home', link: '/' },
    { text: 'Getting Started', link: '/getting-started' },
    { text: 'Guides', link: '/guides' },
    { text: 'Examples', link: '/examples' },
  ],
  
  // Edit link configuration
  editLink: {
    pattern: 'https://github.com/AkatsukiLabs/DojoByExample/edit/main/client-new/pages/:path',
    text: 'Edit this page on GitHub',
  },
  
  // Sponsors configuration
  sponsors: [
    {
      name: 'Powered by',
      height: 60,
      items: [
        [
          {
            name: 'Cartridge',
            link: 'https://docs.cartridge.gg/',
            image: '/partners/Cartridge.svg',
          },
        ],
        [
          {
            name: 'Starknet',
            link: 'https://www.starknet.io',
            image: '/partners/Starknet.svg',
          },
          {
            name: 'OnlyDust',
            link: 'https://app.onlydust.com/p/starknet-by-example',
            image: '/partners/Onlydust.svg',
          },
        ],
      ],
    },
    {
      name: 'Ecosystem Tooling',
      items: [
        [
          {
            name: 'Dojo',
            link: 'https://book.dojoengine.org/',
            image: '/partners/DojoLogo.svg',
          },
        ],
        [
          {
            name: 'Katana',
            link: 'https://book.dojoengine.org/toolchain/katana',
            image: '/partners/KatanaLogo.svg',
          },
          {
            name: 'Sozo',
            link: 'https://book.dojoengine.org/toolchain/sozo',
            image: '/partners/SozoLogo.svg',
          },
          {
            name: 'Torii',
            link: 'https://book.dojoengine.org/toolchain/torii',
            image: '/partners/ToriiLogo.svg',
          },
        ],
        [
          {
            name: 'Origami',
            link: 'https://book.dojoengine.org/libraries/origami',
            image: '/partners/OrigamiLogo.svg',
          },
          {
            name: 'Saya',
            link: 'https://book.dojoengine.org/toolchain/saya',
            image: '/partners/SayaLogo.svg',
          },
        ],
      ],
    },
  ],
  
  // Sidebar configuration with dynamic sections
  sidebar: sidebar,
  
  
  // Markdown configuration with enhanced code highlighting
  markdown: {
    code: {
      themes: {
        light: 'github-light',
        dark: 'github-dark-dimmed',
      },
    },
  },
  
  // Root directory
  rootDir: '.',
  
  // Base URL (useful for deployment)
  baseUrl: process.env.NODE_ENV === 'production' ? 'https://dojobyexample.com' : 'http://localhost:4000',
})