import { useState, ReactNode } from 'react'

interface DemoProps {
  children: ReactNode
  title?: string
  description?: string
  showCode?: boolean
  code?: string
}

export function Demo({ children, title, description, showCode = true, code }: DemoProps) {
  const [isCodeVisible, setIsCodeVisible] = useState(false)
  
  return (
    <div className="my-8 border border-border rounded-xl overflow-hidden shadow-lg bg-gradient-to-br from-white to-gray-50 dark:from-gray-900 dark:to-gray-800">
      {(title || description) && (
        <div className="bg-gradient-to-r from-gray-50 to-white dark:from-gray-800 dark:to-gray-700 px-6 py-5 border-b border-border">
          {title && (
            <h3 className="text-xl font-bold text-text-primary mb-2 flex items-center gap-2">
              <span className="w-2 h-2 bg-dojo-primary rounded-full"></span>
              {title}
            </h3>
          )}
          {description && (
            <p className="text-sm text-text-secondary/80 leading-relaxed">
              {description}
            </p>
          )}
        </div>
      )}
      
      <div className="p-8 bg-gradient-to-br from-white via-gray-50 to-gray-100 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
        {children}
      </div>
      
      {showCode && code && (
        <>
          <div className="border-t border-border bg-gradient-to-r from-gray-100 to-gray-200 dark:from-gray-700 dark:to-gray-800">
            <button
              onClick={() => setIsCodeVisible(!isCodeVisible)}
              className="w-full px-6 py-4 text-sm font-semibold text-text-secondary hover:text-text-primary hover:bg-white/50 dark:hover:bg-gray-600/50 transition-all duration-200 flex items-center justify-between group"
            >
              <span className="flex items-center gap-2">
                <span className="w-2 h-2 bg-blue-500 rounded-full group-hover:animate-pulse"></span>
                {isCodeVisible ? 'Hide' : 'Show'} Code
              </span>
              <span className={`text-xs transition-transform duration-200 ${isCodeVisible ? 'rotate-180' : ''}`}>
                ▼
              </span>
            </button>
          </div>
          
          {isCodeVisible && (
            <div className="border-t border-border animate-fadeIn">
              <pre className="p-6 overflow-x-auto bg-gradient-to-br from-gray-900 to-slate-900 text-gray-100">
                <code className="text-sm font-mono">{code}</code>
              </pre>
            </div>
          )}
        </>
      )}
    </div>
  )
}

interface PlaygroundProps {
  children: ReactNode
  title?: string
  controls?: ReactNode
}

export function Playground({ children, title, controls }: PlaygroundProps) {
  return (
    <div className="my-8 border border-border rounded-xl overflow-hidden shadow-xl bg-gradient-to-br from-white to-purple-50 dark:from-gray-900 dark:to-purple-900/20">
      {title && (
        <div className="bg-gradient-to-r from-purple-100 to-indigo-100 dark:from-purple-900/30 dark:to-indigo-900/30 px-6 py-5 border-b border-border">
          <h3 className="text-xl font-bold text-text-primary flex items-center gap-3">
            <span className="w-3 h-3 bg-gradient-to-r from-purple-500 to-indigo-500 rounded-full animate-pulse"></span>
            {title}
            <span className="text-xs bg-purple-200 dark:bg-purple-800 text-purple-700 dark:text-purple-300 px-2 py-1 rounded-full font-medium">Interactive</span>
          </h3>
        </div>
      )}
      
      {controls && (
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-700 px-6 py-4 border-b border-border">
          <div className="flex flex-wrap gap-3">
            {controls}
          </div>
        </div>
      )}
      
      <div className="p-8 bg-gradient-to-br from-white via-purple-50/30 to-indigo-50/30 dark:from-gray-900 dark:via-purple-900/10 dark:to-indigo-900/10 min-h-[250px] flex items-center justify-center">
        {children}
      </div>
    </div>
  )
}

interface InteractiveExampleProps {
  initialCode: string
  onRun: (code: string) => void
  output?: string
  language?: string
}

export function InteractiveExample({ 
  initialCode, 
  onRun, 
  output 
}: InteractiveExampleProps) {
  const [code, setCode] = useState(initialCode)
  const [isRunning, setIsRunning] = useState(false)
  
  const handleRun = () => {
    setIsRunning(true)
    onRun(code)
    setIsRunning(false)
  }
  
  return (
    <div className="my-8 grid grid-cols-1 lg:grid-cols-2 gap-4">
      <div className="border border-border rounded-lg overflow-hidden">
        <div className="bg-surface px-4 py-2 border-b border-border flex items-center justify-between">
          <span className="text-sm font-medium text-text-primary">Code Editor</span>
          <button
            onClick={handleRun}
            disabled={isRunning}
            className="px-3 py-1 text-sm bg-dojo-primary text-white rounded hover:bg-dojo-hover disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isRunning ? 'Running...' : 'Run'}
          </button>
        </div>
        <textarea
          value={code}
          onChange={(e) => setCode(e.target.value)}
          className="w-full h-64 p-4 bg-background-tertiary text-text-primary font-mono text-sm resize-none focus:outline-none"
          spellCheck={false}
        />
      </div>
      
      <div className="border border-border rounded-lg overflow-hidden">
        <div className="bg-surface px-4 py-2 border-b border-border">
          <span className="text-sm font-medium text-text-primary">Output</span>
        </div>
        <div className="h-64 p-4 bg-background-tertiary overflow-auto">
          {output ? (
            <pre className="text-text-primary font-mono text-sm">{output}</pre>
          ) : (
            <p className="text-text-muted text-sm">
              Click "Run" to see the output
            </p>
          )}
        </div>
      </div>
    </div>
  )
}