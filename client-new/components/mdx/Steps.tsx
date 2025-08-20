import { ReactNode, Children, isValidElement } from 'react'
import { useState } from 'react'

interface StepsProps {
  children: ReactNode
  showProgress?: boolean
}

interface StepProps {
  title: string
  children: ReactNode
  optional?: boolean
}

export function Steps({ children, showProgress = true }: StepsProps) {
  const [completedSteps, setCompletedSteps] = useState<Set<number>>(new Set())
  
  const steps = Children.toArray(children).filter(
    child => isValidElement(child) && child.type === Step
  )
  
  const toggleStep = (index: number) => {
    const newCompleted = new Set(completedSteps)
    if (newCompleted.has(index)) {
      newCompleted.delete(index)
    } else {
      newCompleted.add(index)
    }
    setCompletedSteps(newCompleted)
  }
  
  const progress = (completedSteps.size / steps.length) * 100

  return (
    <div className="my-8">
      {showProgress && steps.length > 0 && (
        <div className="mb-8 p-4 bg-gradient-to-r from-slate-50 to-gray-50 dark:from-slate-900/50 dark:to-gray-900/30 border border-border rounded-xl">
          <div className="flex justify-between text-sm font-medium text-text-secondary mb-3">
            <span className="flex items-center gap-2">
              <div className="w-2 h-2 bg-dojo-primary rounded-full"></div>
              Progress
            </span>
            <span className="text-dojo-primary font-semibold">{completedSteps.size} / {steps.length} completed</span>
          </div>
          <div className="w-full bg-background-tertiary rounded-full h-3 shadow-inner">
            <div 
              className="bg-gradient-to-r from-dojo-primary to-dojo-primary/80 h-3 rounded-full transition-all duration-500 ease-out shadow-sm"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>
      )}
      
      <div className="space-y-6">
        {Children.map(children, (child, index) => {
          if (isValidElement(child) && child.type === Step) {
            const props = child.props as StepProps
            return (
              <StepItem
                key={index}
                number={index + 1}
                completed={completedSteps.has(index)}
                onToggle={() => toggleStep(index)}
                title={props.title}
                optional={props.optional}
              >
                {props.children}
              </StepItem>
            )
          }
          return null
        })}
      </div>
    </div>
  )
}

interface StepItemProps extends StepProps {
  number: number
  completed: boolean
  onToggle: () => void
}

function StepItem({ number, title, children, optional, completed, onToggle }: StepItemProps) {
  return (
    <div className={`relative pl-12 transition-all duration-300 ${completed ? 'opacity-70' : ''}`}>
      <button
        onClick={onToggle}
        className={`
          absolute left-0 top-0 w-9 h-9 rounded-xl flex items-center justify-center text-sm font-bold
          transition-all duration-300 hover:scale-110 shadow-sm
          ${completed 
            ? 'bg-gradient-to-r from-emerald-500 to-green-500 text-white shadow-emerald-200 dark:shadow-emerald-900/50' 
            : 'bg-gradient-to-r from-dojo-primary to-dojo-primary/90 text-white shadow-orange-200 dark:shadow-orange-900/50 hover:shadow-md'
          }
        `}
        aria-label={`Mark step ${number} as ${completed ? 'incomplete' : 'complete'}`}
      >
        {completed ? '✓' : number}
      </button>
      
      <div className={`border-l-2 ml-4 pl-8 pb-6 -mt-1 transition-colors duration-300 ${
        completed ? 'border-emerald-300 dark:border-emerald-700' : 'border-dojo-primary/30 dark:border-dojo-primary/50'
      }`}>
        <h3 className="font-bold text-text-primary mb-3 text-lg">
          {title}
          {optional && (
            <span className="ml-3 px-2 py-1 text-xs text-violet-600 dark:text-violet-400 bg-violet-100 dark:bg-violet-900/30 rounded-full font-medium">
              Optional
            </span>
          )}
        </h3>
        <div className="text-text-secondary/90 [&>p]:m-0 [&>p:not(:last-child)]:mb-4 [&>p]:leading-relaxed">
          {children}
        </div>
      </div>
    </div>
  )
}

export function Step({ children }: StepProps) {
  return <>{children}</>
}