interface Stat {
  label: string
  value: string | number
  suffix?: string
}

interface StatsProps {
  title?: string
  subtitle?: string
  stats: Stat[]
}

export function Stats({ title, subtitle, stats }: StatsProps) {
  return (
    <section className="py-16 md:py-24 bg-surface">
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
        
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          {stats.map((stat, index) => (
            <div key={index} className="text-center">
              <div className="text-3xl md:text-4xl font-bold text-dojo-primary mb-2">
                {stat.value}{stat.suffix}
              </div>
              <div className="text-text-secondary">
                {stat.label}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

interface TimelineItem {
  date: string
  title: string
  description: string
  icon?: string
}

interface TimelineProps {
  title?: string
  subtitle?: string
  items: TimelineItem[]
}

export function Timeline({ title, subtitle, items }: TimelineProps) {
  return (
    <section className="py-16 md:py-24">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
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
        
        <div className="relative">
          {/* Vertical line */}
          <div className="absolute left-8 top-0 bottom-0 w-0.5 bg-border" />
          
          {items.map((item, index) => (
            <div key={index} className="relative flex items-start mb-8">
              {/* Dot */}
              <div className="absolute left-8 w-4 h-4 bg-dojo-primary rounded-full -translate-x-1/2 ring-4 ring-background z-10">
                {item.icon && (
                  <div className="absolute -left-2 -top-2 w-8 h-8 bg-dojo-primary/10 rounded-full flex items-center justify-center text-sm">
                    {item.icon}
                  </div>
                )}
              </div>
              
              {/* Content */}
              <div className="ml-20">
                <div className="text-sm text-text-muted mb-1">{item.date}</div>
                <h3 className="text-lg font-semibold text-text-primary mb-1">{item.title}</h3>
                <p className="text-text-secondary">{item.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}