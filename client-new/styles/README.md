# Design System

## Overview
This directory contains the design system for Dojo by Example, including design tokens, theme configuration, and global styles.

## Files

- `design-tokens.css` - CSS custom properties for colors, spacing, typography, etc.
- `theme.ts` - TypeScript theme configuration for Vocs and components
- `globals.css` - Global styles and Tailwind CSS imports

## Color Palette

### Brand Colors
- Primary: `#ff3000` (Dojo Red)
- Primary Hover: `#e62900`
- Primary Light: `#ff6b4a`
- Primary Dark: `#cc2600`

### Semantic Colors
- Success: `#10b981`
- Warning: `#f59e0b`
- Error: `#ef4444`
- Info: `#3b82f6`

## Typography
- Font Family: DM Sans (primary), JetBrains Mono (code)
- Scale: xs (0.75rem) to 5xl (3rem)

## Spacing
Uses a consistent scale from xs (0.25rem) to 3xl (4rem)

## Theme Switching
The design system supports automatic dark/light mode switching:
- Light mode: Default white backgrounds with dark text
- Dark mode: Dark backgrounds (#0a0a0a base) with light text

## Usage

### In CSS/Tailwind
```css
/* Use CSS variables */
.my-element {
  color: var(--dojo-primary);
  padding: var(--space-md);
}
```

### In React Components
```tsx
import { theme } from '@/styles/theme'

// Use theme values
<div style={{ color: theme.colors.dojo.DEFAULT }}>
  Dojo by Example
</div>
```

## Assets Structure
```
public/
├── logos/       # Dojo logos (light/dark variants)
├── partners/    # Partner/sponsor logos
└── og-images/   # Open Graph images for social sharing
```