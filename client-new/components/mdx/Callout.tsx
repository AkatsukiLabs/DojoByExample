import { ReactNode } from 'react'

interface CalloutProps {
  type?: 'info' | 'warning' | 'error' | 'success' | 'tip'
  title?: string
  children: ReactNode
  emoji?: string
}

export function Callout({ type = 'info', title, children, emoji }: CalloutProps) {
  const styles = {
    info: {
      bg: 'bg-gradient-to-r from-blue-50 to-blue-100/50 dark:from-blue-950/30 dark:to-blue-900/20',
      border: 'border-blue-200 dark:border-blue-800',
      text: 'text-blue-700 dark:text-blue-300',
      iconBg: 'bg-blue-100 dark:bg-blue-900/50',
      iconText: 'text-blue-600 dark:text-blue-400',
      icon: emoji || 'ℹ️'
    },
    warning: {
      bg: 'bg-gradient-to-r from-amber-50 to-orange-100/50 dark:from-amber-950/30 dark:to-orange-900/20',
      border: 'border-amber-200 dark:border-amber-800',
      text: 'text-amber-700 dark:text-amber-300',
      iconBg: 'bg-amber-100 dark:bg-amber-900/50',
      iconText: 'text-amber-600 dark:text-amber-400',
      icon: emoji || '⚠️'
    },
    error: {
      bg: 'bg-gradient-to-r from-red-50 to-red-100/50 dark:from-red-950/30 dark:to-red-900/20',
      border: 'border-red-200 dark:border-red-800',
      text: 'text-red-700 dark:text-red-300',
      iconBg: 'bg-red-100 dark:bg-red-900/50',
      iconText: 'text-red-600 dark:text-red-400',
      icon: emoji || '❌'
    },
    success: {
      bg: 'bg-gradient-to-r from-emerald-50 to-green-100/50 dark:from-emerald-950/30 dark:to-green-900/20',
      border: 'border-emerald-200 dark:border-emerald-800',
      text: 'text-emerald-700 dark:text-emerald-300',
      iconBg: 'bg-emerald-100 dark:bg-emerald-900/50',
      iconText: 'text-emerald-600 dark:text-emerald-400',
      icon: emoji || '✅'
    },
    tip: {
      bg: 'bg-gradient-to-r from-violet-50 to-purple-100/50 dark:from-violet-950/30 dark:to-purple-900/20',
      border: 'border-violet-200 dark:border-violet-800',
      text: 'text-violet-700 dark:text-violet-300',
      iconBg: 'bg-violet-100 dark:bg-violet-900/50',
      iconText: 'text-violet-600 dark:text-violet-400',
      icon: emoji || '💡'
    }
  }

  const style = styles[type]

  return (
    <div className={`${style.bg} border ${style.border} rounded-xl p-5 my-6 shadow-sm backdrop-blur-sm`}>
      <div className="flex items-start space-x-4">
        <div className={`${style.iconBg} ${style.iconText} rounded-lg p-2 flex-shrink-0 shadow-sm`}>
          <span className="text-lg font-medium">{style.icon}</span>
        </div>
        <div className="flex-1 min-w-0">
          {title && (
            <h4 className={`font-semibold ${style.text} mb-2 text-lg`}>
              {title}
            </h4>
          )}
          <div className="text-text-primary/90 [&>p]:m-0 [&>p:not(:last-child)]:mb-3 [&>p]:leading-relaxed">
            {children}
          </div>
        </div>
      </div>
    </div>
  )
}

// Alias components for convenience
export function Info({ children, title }: Omit<CalloutProps, 'type'>) {
  return <Callout type="info" title={title}>{children}</Callout>
}

export function Warning({ children, title }: Omit<CalloutProps, 'type'>) {
  return <Callout type="warning" title={title}>{children}</Callout>
}

export function Error({ children, title }: Omit<CalloutProps, 'type'>) {
  return <Callout type="error" title={title}>{children}</Callout>
}

export function Success({ children, title }: Omit<CalloutProps, 'type'>) {
  return <Callout type="success" title={title}>{children}</Callout>
}

export function Tip({ children, title }: Omit<CalloutProps, 'type'>) {
  return <Callout type="tip" title={title}>{children}</Callout>
}