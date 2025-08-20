import { ReactNode } from 'react'

interface TerminalProps {
  children: ReactNode
  title?: string
  prompt?: string
}

export function Terminal({ children, title = 'Terminal' }: TerminalProps) {
  return (
    <div className="my-8 bg-gradient-to-br from-gray-900 via-gray-900 to-slate-900 rounded-xl overflow-hidden shadow-2xl border border-gray-700">
      <div className="bg-gradient-to-r from-gray-800 to-gray-750 px-5 py-3 flex items-center justify-between border-b border-gray-600">
        <div className="flex items-center space-x-2">
          <div className="w-3.5 h-3.5 bg-red-500 rounded-full shadow-sm" />
          <div className="w-3.5 h-3.5 bg-yellow-500 rounded-full shadow-sm" />
          <div className="w-3.5 h-3.5 bg-green-500 rounded-full shadow-sm" />
        </div>
        <span className="text-gray-300 text-sm font-mono font-medium bg-gray-700/50 px-3 py-1 rounded-full">{title}</span>
        <div className="w-20" />
      </div>
      
      <div className="p-6 font-mono text-sm text-gray-100 bg-gradient-to-b from-gray-900 to-black">
        {children}
      </div>
    </div>
  )
}

interface CommandProps {
  children: string
  prompt?: string
}

export function Command({ children, prompt = '$' }: CommandProps) {
  return (
    <div className="flex items-start space-x-3 mb-3 group">
      <span className="text-emerald-400 select-none font-bold group-hover:text-emerald-300 transition-colors">{prompt}</span>
      <span className="text-gray-100 font-medium group-hover:text-white transition-colors">{children}</span>
    </div>
  )
}

interface OutputProps {
  children: ReactNode
  type?: 'default' | 'success' | 'error' | 'warning'
}

export function Output({ children, type = 'default' }: OutputProps) {
  const styles = {
    default: 'text-gray-400 border-l-gray-600',
    success: 'text-emerald-400 border-l-emerald-500',
    error: 'text-red-400 border-l-red-500',
    warning: 'text-amber-400 border-l-amber-500'
  }
  
  return (
    <div className={`pl-6 mb-3 border-l-2 ${styles[type]} bg-gray-800/30 py-1 rounded-r-md`}>
      {children}
    </div>
  )
}

// Convenience component for a complete terminal session
interface TerminalSessionProps {
  commands: Array<{
    input: string
    output?: string
    outputType?: 'default' | 'success' | 'error' | 'warning'
  }>
  title?: string
  prompt?: string
}

export function TerminalSession({ commands, title, prompt = '$' }: TerminalSessionProps) {
  return (
    <Terminal title={title} prompt={prompt}>
      {commands.map((cmd, i) => (
        <div key={i}>
          <Command prompt={prompt}>{cmd.input}</Command>
          {cmd.output && (
            <Output type={cmd.outputType}>{cmd.output}</Output>
          )}
        </div>
      ))}
    </Terminal>
  )
}