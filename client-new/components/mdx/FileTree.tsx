import { useState, ReactNode } from 'react'

interface FileTreeProps {
  children: ReactNode
}

interface FolderProps {
  name: string
  defaultOpen?: boolean
  children: ReactNode
}

interface FileProps {
  name: string
  icon?: string
  badge?: string
}

export function FileTree({ children }: FileTreeProps) {
  return (
    <div className="my-6 p-5 bg-gradient-to-br from-slate-900 to-slate-800 border border-slate-700 rounded-xl font-mono text-sm shadow-lg overflow-hidden">
      <div className="flex items-center gap-2 mb-4 pb-3 border-b border-slate-600">
        <div className="flex gap-1.5">
          <div className="w-3 h-3 bg-red-500 rounded-full"></div>
          <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
          <div className="w-3 h-3 bg-green-500 rounded-full"></div>
        </div>
        <span className="text-slate-300 text-xs ml-2">File Explorer</span>
      </div>
      <div className="space-y-1">
        {children}
      </div>
    </div>
  )
}

export function Folder({ name, defaultOpen = false, children }: FolderProps) {
  const [isOpen, setIsOpen] = useState(defaultOpen)

  return (
    <div>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 hover:bg-slate-700/50 rounded-md px-3 py-2 w-full text-left transition-colors duration-200 group"
      >
        <span className="text-slate-400 group-hover:text-slate-300 transition-colors text-xs">
          {isOpen ? '▼' : '▶'}
        </span>
        <span className="text-blue-300 group-hover:text-blue-200 font-medium">
          {isOpen ? '📂' : '📁'} {name}/
        </span>
      </button>
      
      {isOpen && (
        <div className="ml-4 pl-3 border-l border-slate-600/50 mt-1">
          {children}
        </div>
      )}
    </div>
  )
}

export function File({ name, icon = '📄', badge }: FileProps) {
  return (
    <div className="flex items-center justify-between px-3 py-2 hover:bg-slate-700/30 rounded-md group transition-colors duration-200">
      <div className="flex items-center space-x-2">
        <span className="text-slate-500 ml-2 text-xs">├─</span>
        <span className="text-slate-200 group-hover:text-white transition-colors">
          {icon} {name}
        </span>
      </div>
      {badge && (
        <span className="text-xs px-2 py-1 bg-gradient-to-r from-orange-500/20 to-red-500/20 text-orange-300 rounded-full border border-orange-500/30 font-medium">
          {badge}
        </span>
      )}
    </div>
  )
}

// Convenience components for common file types
export function CairoFile({ name, ...props }: Omit<FileProps, 'icon'>) {
  return <File name={name} icon="🧡" {...props} />
}

export function TypeScriptFile({ name, ...props }: Omit<FileProps, 'icon'>) {
  return <File name={name} icon="🔷" {...props} />
}

export function JsonFile({ name, ...props }: Omit<FileProps, 'icon'>) {
  return <File name={name} icon="⚙️" {...props} />
}

export function MarkdownFile({ name, ...props }: Omit<FileProps, 'icon'>) {
  return <File name={name} icon="📝" {...props} />
}