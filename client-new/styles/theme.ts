// Theme configuration for Dojo by Example

export const theme = {
  colors: {
    // Brand colors
    dojo: {
      DEFAULT: '#ff3000',
      hover: '#e62900',
      light: '#ff6b4a',
      dark: '#cc2600',
    },
    
    // Semantic colors
    success: '#10b981',
    warning: '#f59e0b',
    error: '#ef4444',
    info: '#3b82f6',
  },
  
  fonts: {
    sans: ['DM Sans', 'system-ui', '-apple-system', 'sans-serif'],
    mono: ['JetBrains Mono', 'Consolas', 'monospace'],
  },
  
  transitions: {
    fast: '150ms ease',
    base: '250ms ease',
    slow: '350ms ease',
  },
}

// Export color palette for Vocs config
export const vocsTheme = {
  accentColor: {
    light: theme.colors.dojo.DEFAULT,
    dark: theme.colors.dojo.light,
  },
  
  // Logo configurations with theme switching
  logos: {
    light: {
      icon: '/logos/Icon_Light.svg',
      horizontal: '/logos/Horizontal_Light.svg',
      vertical: '/logos/Vertical_Light.svg',
    },
    dark: {
      icon: '/logos/Icon_Dark.svg',
      horizontal: '/logos/Horizontal_Dark.svg',
      vertical: '/logos/Vertical_Dark.svg',
    },
  },
}

// Partner logos configuration
export const partners = {
  powered: [
    {
      name: 'Cartridge',
      logo: '/partners/Cartridge.svg',
      url: 'https://docs.cartridge.gg/',
    },
    {
      name: 'Starknet',
      logo: '/partners/Starknet.svg',
      url: 'https://www.starknet.io',
    },
    {
      name: 'OnlyDust',
      logo: '/partners/Onlydust.svg',
      url: 'https://app.onlydust.com/p/starknet-by-example',
    },
  ],
  ecosystem: [
    {
      name: 'Dojo',
      logo: '/partners/DojoLogo.svg',
      url: 'https://book.dojoengine.org/',
    },
    {
      name: 'Katana',
      logo: '/partners/KatanaLogo.svg',
      url: 'https://book.dojoengine.org/toolchain/katana',
    },
    {
      name: 'Sozo',
      logo: '/partners/SozoLogo.svg',
      url: 'https://book.dojoengine.org/toolchain/sozo',
    },
    {
      name: 'Torii',
      logo: '/partners/ToriiLogo.svg',
      url: 'https://book.dojoengine.org/toolchain/torii',
    },
    {
      name: 'Origami',
      logo: '/partners/OrigamiLogo.svg',
      url: 'https://book.dojoengine.org/libraries/origami',
    },
    {
      name: 'Saya',
      logo: '/partners/SayaLogo.svg',
      url: 'https://book.dojoengine.org/toolchain/saya',
    },
  ],
}