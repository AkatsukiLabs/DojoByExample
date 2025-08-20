import { useState, ReactNode, Children, isValidElement } from 'react'

interface TabsProps {
  items?: string[]
  defaultValue?: string
  children: ReactNode
}

interface TabProps {
  value: string
  label?: string
  children: ReactNode
}

export function Tabs({ items, defaultValue, children }: TabsProps) {
  const childrenArray = Children.toArray(children)
  
  // Extract tab values from children if items not provided
  const tabItems = items || childrenArray
    .filter(child => isValidElement(child) && (child.props as TabProps).value)
    .map(child => {
      if (isValidElement(child)) {
        const props = child.props as TabProps
        return props.label || props.value
      }
      return ''
    })
  
  const firstValue = items ? items[0] : 
    isValidElement(childrenArray[0]) ? (childrenArray[0].props as TabProps)?.value : undefined
  const [activeTab, setActiveTab] = useState(defaultValue || firstValue)

  return (
    <div className="my-8">
      <div className="flex bg-background-secondary rounded-xl p-1 shadow-inner">
        {tabItems.map((item) => {
          const value = typeof item === 'string' ? item : item
          const label = value
          
          return (
            <button
              key={value}
              onClick={() => setActiveTab(value)}
              className={`
                px-6 py-3 font-semibold text-sm transition-all duration-300 rounded-lg relative flex-1
                ${activeTab === value 
                  ? 'text-white bg-gradient-to-r from-dojo-primary to-dojo-primary/80 shadow-lg shadow-dojo-primary/25 transform scale-[1.02]' 
                  : 'text-text-secondary hover:text-text-primary hover:bg-background/50'
                }
              `}
            >
              {label}
              {activeTab === value && (
                <div className="absolute inset-0 rounded-lg bg-gradient-to-r from-dojo-primary to-dojo-primary/80 opacity-10 animate-pulse"></div>
              )}
            </button>
          )
        })}
      </div>
      
      <div className="mt-6 p-6 bg-background border border-border rounded-xl shadow-sm">
        {Children.map(children, (child) => {
          if (isValidElement(child) && (child.props as TabProps).value === activeTab) {
            return (child.props as TabProps).children
          }
          return null
        })}
      </div>
    </div>
  )
}

export function Tab({ children }: TabProps) {
  return <>{children}</>
}