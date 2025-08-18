/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx}',
    './layout/**/*.{js,ts,jsx,tsx}',
    './src/**/*.{js,ts,jsx,tsx}',
    './vocs.config.ts',
  ],
  darkMode: ['class', '[data-theme="dark"]'],
  theme: {
    extend: {
      colors: {
        // Dojo brand colors
        'dojo-primary': '#ff3000',
        'dojo-hover': '#e62900',
        'dojo-light': '#ff6b4a',
        'dojo-dark': '#cc2600',
        
        // Dynamic colors that change with theme
        'background': 'var(--color-background)',
        'background-secondary': 'var(--color-background-secondary)',
        'background-tertiary': 'var(--color-background-tertiary)',
        'surface': 'var(--color-surface)',
        'surface-hover': 'var(--color-surface-hover)',
        'border': 'var(--color-border)',
        'border-hover': 'var(--color-border-hover)',
        
        // Text colors
        'text-primary': 'var(--color-text-primary)',
        'text-secondary': 'var(--color-text-secondary)',
        'text-tertiary': 'var(--color-text-tertiary)',
        'text-muted': 'var(--color-text-muted)',
        
        // Semantic colors
        'success': '#10b981',
        'warning': '#f59e0b',
        'error': '#ef4444',
        'info': '#3b82f6',
      },
      fontFamily: {
        'sans': ['DM Sans', 'system-ui', '-apple-system', 'sans-serif'],
        'mono': ['JetBrains Mono', 'Consolas', 'Monaco', 'monospace'],
      },
      spacing: {
        'xs': 'var(--space-xs)',
        'sm': 'var(--space-sm)',
        'md': 'var(--space-md)',
        'lg': 'var(--space-lg)',
        'xl': 'var(--space-xl)',
        '2xl': 'var(--space-2xl)',
        '3xl': 'var(--space-3xl)',
      },
      fontSize: {
        'xs': 'var(--font-size-xs)',
        'sm': 'var(--font-size-sm)',
        'base': 'var(--font-size-base)',
        'lg': 'var(--font-size-lg)',
        'xl': 'var(--font-size-xl)',
        '2xl': 'var(--font-size-2xl)',
        '3xl': 'var(--font-size-3xl)',
        '4xl': 'var(--font-size-4xl)',
        '5xl': 'var(--font-size-5xl)',
      },
      borderRadius: {
        'sm': 'var(--radius-sm)',
        'md': 'var(--radius-md)',
        'lg': 'var(--radius-lg)',
        'xl': 'var(--radius-xl)',
        '2xl': 'var(--radius-2xl)',
      },
      boxShadow: {
        'sm': 'var(--shadow-sm)',
        'md': 'var(--shadow-md)',
        'lg': 'var(--shadow-lg)',
        'xl': 'var(--shadow-xl)',
        'dojo': '0 0 20px rgba(255, 48, 0, 0.3)',
      },
      animation: {
        'fadeIn': 'fadeIn 0.5s ease-out',
        'slideIn': 'slideIn 0.3s ease-out',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideIn: {
          '0%': { transform: 'translateX(-100%)' },
          '100%': { transform: 'translateX(0)' },
        },
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: 'var(--color-text-primary)',
            a: {
              color: '#ff3000',
              '&:hover': {
                color: '#e62900',
              },
            },
            h1: {
              color: 'var(--color-text-primary)',
            },
            h2: {
              color: 'var(--color-text-primary)',
            },
            h3: {
              color: 'var(--color-text-primary)',
            },
            h4: {
              color: 'var(--color-text-primary)',
            },
            code: {
              color: 'var(--color-text-primary)',
              backgroundColor: 'var(--color-background-tertiary)',
              borderRadius: '0.375rem',
              padding: '0.125rem 0.25rem',
            },
            'code::before': {
              content: '""',
            },
            'code::after': {
              content: '""',
            },
            pre: {
              backgroundColor: 'var(--color-background-tertiary)',
            },
            blockquote: {
              borderLeftColor: '#ff3000',
              color: 'var(--color-text-secondary)',
            },
          },
        },
      }),
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}