import { ReactNode } from 'react'

interface NavigationCardProps {
  title: string
  description: string
  href: string
  icon?: string
  children?: ReactNode
}

export function NavigationCard({ title, description, href, icon, children }: NavigationCardProps) {
  return (
    <a 
      href={href} 
      className="block p-6 bg-surface hover:bg-surface-hover border border-border hover:border-dojo-primary/50 rounded-lg transition-all duration-200 group"
    >
      <div className="flex items-start space-x-4">
        {icon && (
          <div className="text-2xl flex-shrink-0 group-hover:scale-110 transition-transform">
            {icon}
          </div>
        )}
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-text-primary group-hover:text-dojo-primary transition-colors">
            {title}
          </h3>
          <p className="text-text-secondary mt-1 text-sm">
            {description}
          </p>
          {children && (
            <div className="mt-3">
              {children}
            </div>
          )}
        </div>
        <div className="text-text-muted group-hover:text-dojo-primary transition-colors">
          →
        </div>
      </div>
    </a>
  )
}

interface NavigationGridProps {
  children: ReactNode
  columns?: 1 | 2 | 3
}

export function NavigationGrid({ children, columns = 2 }: NavigationGridProps) {
  const gridCols = {
    1: 'grid-cols-1',
    2: 'grid-cols-1 md:grid-cols-2',
    3: 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3',
  }

  return (
    <div className={`grid ${gridCols[columns]} gap-4 my-6`}>
      {children}
    </div>
  )
}

interface BreadcrumbProps {
  items: Array<{
    label: string
    href?: string
  }>
}

export function Breadcrumb({ items }: BreadcrumbProps) {
  return (
    <nav className="flex items-center space-x-2 text-sm text-text-secondary mb-6">
      {items.map((item, index) => (
        <div key={index} className="flex items-center">
          {index > 0 && <span className="mx-2 text-text-muted">/</span>}
          {item.href ? (
            <a 
              href={item.href} 
              className="hover:text-dojo-primary transition-colors"
            >
              {item.label}
            </a>
          ) : (
            <span className="text-text-primary font-medium">{item.label}</span>
          )}
        </div>
      ))}
    </nav>
  )
}

interface NextPrevProps {
  prev?: {
    label: string
    href: string
  }
  next?: {
    label: string
    href: string
  }
}

export function NextPrev({ prev, next }: NextPrevProps) {
  return (
    <div className="flex justify-between items-center mt-12 pt-8 border-t border-border">
      <div className="flex-1">
        {prev && (
          <a 
            href={prev.href}
            className="inline-flex items-center space-x-2 text-text-secondary hover:text-dojo-primary transition-colors"
          >
            <span>←</span>
            <div>
              <div className="text-xs text-text-muted">Previous</div>
              <div className="font-medium">{prev.label}</div>
            </div>
          </a>
        )}
      </div>
      
      <div className="flex-1 text-right">
        {next && (
          <a 
            href={next.href}
            className="inline-flex items-center space-x-2 text-text-secondary hover:text-dojo-primary transition-colors"
          >
            <div>
              <div className="text-xs text-text-muted">Next</div>
              <div className="font-medium">{next.label}</div>
            </div>
            <span>→</span>
          </a>
        )}
      </div>
    </div>
  )
}