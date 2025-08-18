import { ReactNode } from 'react'

interface HeroProps {
  title: string | ReactNode
  subtitle?: string
  description?: string
  children?: ReactNode
}

export function Hero({ title, subtitle, description, children }: HeroProps) {
  return (
    <section className="relative py-16 md:py-24 lg:py-32">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          {subtitle && (
            <p className="text-dojo-primary font-semibold text-sm md:text-base uppercase tracking-wide mb-3">
              {subtitle}
            </p>
          )}
          
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold text-text-primary mb-6">
            {title}
          </h1>
          
          {description && (
            <p className="text-lg md:text-xl text-text-secondary max-w-3xl mx-auto mb-8">
              {description}
            </p>
          )}
          
          {children && (
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              {children}
            </div>
          )}
        </div>
      </div>
      
      {/* Gradient background effect */}
      <div className="absolute inset-0 -z-10 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-dojo-primary/5 via-transparent to-transparent" />
      </div>
    </section>
  )
}

interface HeroButtonProps {
  href: string
  children: ReactNode
  variant?: 'primary' | 'secondary'
  external?: boolean
}

export function HeroButton({ href, children, variant = 'primary', external = false }: HeroButtonProps) {
  const className = variant === 'primary' 
    ? 'inline-flex items-center px-6 py-3 rounded-lg bg-dojo-primary text-white font-semibold hover:bg-dojo-hover transition-colors shadow-lg hover:shadow-xl'
    : 'inline-flex items-center px-6 py-3 rounded-lg bg-surface border border-border text-text-primary font-semibold hover:bg-surface-hover transition-colors'
  
  const content = (
    <>
      {children}
      <span className="ml-2">→</span>
    </>
  )
  
  if (external) {
    return (
      <a 
        href={href}
        target="_blank"
        rel="noopener noreferrer"
        className={className}
      >
        {content}
      </a>
    )
  }
  
  return (
    <a href={href} className={className}>
      {content}
    </a>
  )
}

interface HeroBadgeProps {
  text: string
  href?: string
}

export function HeroBadge({ text, href }: HeroBadgeProps) {
  const className = "inline-flex items-center px-3 py-1 rounded-full bg-dojo-primary/10 text-dojo-primary text-sm font-medium"
  
  if (href) {
    return (
      <a href={href} className={`${className} hover:bg-dojo-primary/20 transition-colors`}>
        {text}
      </a>
    )
  }
  
  return <span className={className}>{text}</span>
}