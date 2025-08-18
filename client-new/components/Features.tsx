import { ReactNode } from 'react'

interface Feature {
  icon: string | ReactNode
  title: string
  description: string
  href?: string
}

interface FeaturesProps {
  title?: string
  subtitle?: string
  features: Feature[]
  columns?: 2 | 3 | 4
}

export function Features({ title, subtitle, features, columns = 3 }: FeaturesProps) {
  const gridCols = {
    2: 'grid-cols-1 md:grid-cols-2',
    3: 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3',
    4: 'grid-cols-1 md:grid-cols-2 lg:grid-cols-4',
  }
  
  return (
    <section className="py-16 md:py-24">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {(title || subtitle) && (
          <div className="text-center mb-12">
            {subtitle && (
              <p className="text-dojo-primary font-semibold text-sm md:text-base uppercase tracking-wide mb-3">
                {subtitle}
              </p>
            )}
            {title && (
              <h2 className="text-3xl md:text-4xl font-bold text-text-primary">
                {title}
              </h2>
            )}
          </div>
        )}
        
        <div className={`grid ${gridCols[columns]} gap-8`}>
          {features.map((feature, index) => (
            <FeatureCard key={index} {...feature} />
          ))}
        </div>
      </div>
    </section>
  )
}

interface FeatureCardProps extends Feature {}

export function FeatureCard({ icon, title, description, href }: FeatureCardProps) {
  const content = (
    <>
      <div className="flex items-center justify-center w-12 h-12 rounded-lg bg-dojo-primary/10 text-dojo-primary text-2xl mb-4 group-hover:scale-110 transition-transform">
        {icon}
      </div>
      <h3 className="text-xl font-semibold text-text-primary mb-2 group-hover:text-dojo-primary transition-colors">
        {title}
      </h3>
      <p className="text-text-secondary">
        {description}
      </p>
      {href && (
        <div className="mt-4 text-dojo-primary font-medium">
          Learn more →
        </div>
      )}
    </>
  )
  
  if (href) {
    return (
      <a href={href} className="block p-6 bg-surface rounded-xl border border-border hover:border-dojo-primary/50 hover:shadow-lg transition-all duration-300 group">
        {content}
      </a>
    )
  }
  
  return (
    <div className="p-6 bg-surface rounded-xl border border-border">
      {content}
    </div>
  )
}

interface FeatureHighlightProps {
  icon: string | ReactNode
  title: string
  description: string
  image?: string
  reverse?: boolean
  children?: ReactNode
}

export function FeatureHighlight({ icon, title, description, image, reverse = false, children }: FeatureHighlightProps) {
  return (
    <section className="py-16 md:py-24">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className={`grid grid-cols-1 lg:grid-cols-2 gap-12 items-center ${reverse ? 'lg:flex-row-reverse' : ''}`}>
          <div className={reverse ? 'lg:order-2' : ''}>
            <div className="flex items-center justify-center w-16 h-16 rounded-xl bg-dojo-primary/10 text-dojo-primary text-3xl mb-6">
              {icon}
            </div>
            <h2 className="text-3xl md:text-4xl font-bold text-text-primary mb-4">
              {title}
            </h2>
            <p className="text-lg text-text-secondary mb-6">
              {description}
            </p>
            {children}
          </div>
          
          <div className={reverse ? 'lg:order-1' : ''}>
            {image ? (
              <img 
                src={image} 
                alt={title}
                className="rounded-xl shadow-xl"
              />
            ) : (
              <div className="aspect-video bg-gradient-to-br from-dojo-primary/20 to-dojo-primary/5 rounded-xl flex items-center justify-center">
                <div className="text-6xl opacity-50">{icon}</div>
              </div>
            )}
          </div>
        </div>
      </div>
    </section>
  )
}