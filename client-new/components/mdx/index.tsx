// Import all MDX components
import { CodeBlock } from './CodeBlock'
import { Tabs, Tab } from './Tabs'
import { Callout, Info, Warning, Error, Success, Tip } from './Callout'
import { Steps, Step } from './Steps'
import { FileTree, Folder, File, CairoFile, TypeScriptFile, JsonFile, MarkdownFile } from './FileTree'
import { Diff, BeforeAfter } from './Diff'
import { Terminal, Command, Output, TerminalSession } from './Terminal'
import { Demo, Playground, InteractiveExample } from './Demo'

// Import navigation components for MDX use
import { NavigationGrid, NavigationCard, Breadcrumb, NextPrev } from '../Navigation'
import { Hero, HeroButton, HeroBadge } from '../Hero'
import { Features, FeatureCard, FeatureHighlight } from '../Features'
import { Stats, Timeline } from '../Stats'
import { CTA, CTAButton } from '../CTA'

// Import utility components
import { ErrorBoundary } from '../ErrorBoundary'
import { LoadingSpinner, LoadingDots, LoadingSkeleton, FullPageLoading, ContentLoading } from '../LoadingStates'

// Export all components
export {
  // MDX components
  CodeBlock,
  Tabs,
  Tab,
  Callout,
  Info,
  Warning,
  Error,
  Success,
  Tip,
  Steps,
  Step,
  FileTree,
  Folder,
  File,
  CairoFile,
  TypeScriptFile,
  JsonFile,
  MarkdownFile,
  Diff,
  BeforeAfter,
  Terminal,
  Command,
  Output,
  TerminalSession,
  Demo,
  Playground,
  InteractiveExample,
  
  // Navigation components
  NavigationGrid,
  NavigationCard,
  Breadcrumb,
  NextPrev,
  Hero,
  HeroButton,
  HeroBadge,
  Features,
  FeatureCard,
  FeatureHighlight,
  Stats,
  Timeline,
  CTA,
  CTAButton,
}

// Create MDX components mapping for Vocs
export const mdxComponents = {
  // Code components
  CodeBlock,
  
  // Tab components
  Tabs,
  Tab,
  
  // Callout components
  Callout,
  Info,
  Warning,
  Error,
  Success,
  Tip,
  
  // Step components
  Steps,
  Step,
  
  // File tree components
  FileTree,
  Folder,
  File,
  CairoFile,
  TypeScriptFile,
  JsonFile,
  MarkdownFile,
  
  // Diff components
  Diff,
  BeforeAfter,
  
  // Terminal components
  Terminal,
  Command,
  Output,
  TerminalSession,
  
  // Demo components
  Demo,
  Playground,
  InteractiveExample,
  
  // Navigation components
  NavigationGrid,
  NavigationCard,
  Breadcrumb,
  NextPrev,
  
  // Hero components
  Hero,
  HeroButton,
  HeroBadge,
  
  // Feature components
  Features,
  FeatureCard,
  FeatureHighlight,
  
  // Stats components
  Stats,
  Timeline,
  
  // CTA components
  CTA,
  CTAButton,
  
  // Utility components
  ErrorBoundary,
  LoadingSpinner,
  LoadingDots,
  LoadingSkeleton,
  FullPageLoading,
  ContentLoading,
}