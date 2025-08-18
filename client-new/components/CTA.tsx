import { ReactNode } from 'react'

interface CTAProps {
  title: string
  description?: string
  children?: ReactNode
  variant?: 'default' | 'gradient'
}

export function CTA({ title, description, children, variant = 'default' }: CTAProps) {
  const bgClass = variant === 'gradient' 
    ? 'bg-gradient-to-r from-dojo-primary to-dojo-light'
    : 'bg-surface border border-dojo-primary/20'
  
  const textClass = variant === 'gradient'
    ? 'text-white'
    : 'text-text-primary'
    
  const descClass = variant === 'gradient'
    ? 'text-white/90'
    : 'text-text-secondary'
  
  return (
    <section className="py-16 md:py-24">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className={`${bgClass} rounded-2xl p-8 md:p-12 text-center`}>
          <h2 className={`text-3xl md:text-4xl font-bold ${textClass} mb-4`}>
            {title}
          </h2>
          {description && (
            <p className={`text-lg ${descClass} mb-8 max-w-2xl mx-auto`}>
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
    </section>
  )
}

interface CTAButtonProps {
  href: string
  children: ReactNode
  variant?: 'primary' | 'white'
  external?: boolean
}

export function CTAButton({ href, children, variant = 'primary', external = false }: CTAButtonProps) {
  const className = variant === 'white'
    ? 'inline-flex items-center px-6 py-3 rounded-lg bg-white text-dojo-primary font-semibold hover:bg-gray-100 transition-colors shadow-lg'
    : 'inline-flex items-center px-6 py-3 rounded-lg bg-dojo-primary text-white font-semibold hover:bg-dojo-hover transition-colors shadow-lg'
  
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