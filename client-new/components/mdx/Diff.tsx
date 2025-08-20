interface DiffProps {
  children: string
  filename?: string
  language?: string
}

export function Diff({ children, filename, language = 'text' }: DiffProps) {
  const lines = children.split('\n')
  
  return (
    <div className="my-8">
      {filename && (
        <div className="bg-gradient-to-r from-gray-800 to-gray-700 border border-gray-600 border-b-0 rounded-t-xl px-5 py-3 flex items-center gap-3">
          <div className="flex gap-1.5">
            <div className="w-3 h-3 bg-red-500 rounded-full"></div>
            <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
            <div className="w-3 h-3 bg-green-500 rounded-full"></div>
          </div>
          <span className="text-sm font-mono text-gray-300 font-medium">{filename}</span>
          <span className="text-xs bg-blue-500/20 text-blue-400 px-2 py-1 rounded-full">diff</span>
        </div>
      )}
      
      <div className={`bg-gradient-to-br from-gray-900 to-slate-900 border border-gray-600 ${filename ? 'rounded-b-xl' : 'rounded-xl'} overflow-hidden shadow-lg`}>
        <pre className="overflow-x-auto p-5">
          <code className={`language-${language} font-mono text-sm`}>
            {lines.map((line, i) => {
              const isAdded = line.startsWith('+')
              const isRemoved = line.startsWith('-')
              const isContext = line.startsWith('@@')
              
              let className = 'px-2 py-0.5 rounded-sm '
              if (isAdded) className += 'bg-emerald-500/20 text-emerald-300 border-l-2 border-emerald-500'
              else if (isRemoved) className += 'bg-red-500/20 text-red-300 border-l-2 border-red-500'
              else if (isContext) className += 'text-blue-400 bg-blue-500/10 border-l-2 border-blue-500'
              else className += 'text-gray-300'
              
              return (
                <div key={i} className={className}>
                  {line || ' '}
                </div>
              )
            })}
          </code>
        </pre>
      </div>
    </div>
  )
}

interface BeforeAfterProps {
  before: string
  after: string
  filename?: string
  language?: string
}

export function BeforeAfter({ before, after, filename, language = 'text' }: BeforeAfterProps) {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 my-8">
      <div className="space-y-3">
        <div className="flex items-center gap-2 text-sm font-bold text-red-400">
          <span className="w-2 h-2 bg-red-500 rounded-full"></span>
          Before
        </div>
        <div className="bg-gradient-to-br from-red-950/30 to-red-900/20 border border-red-500/30 rounded-xl overflow-hidden shadow-lg">
          {filename && (
            <div className="bg-red-900/30 px-5 py-3 border-b border-red-500/30 flex items-center gap-3">
              <div className="flex gap-1.5">
                <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                <div className="w-3 h-3 bg-yellow-500/50 rounded-full"></div>
                <div className="w-3 h-3 bg-green-500/50 rounded-full"></div>
              </div>
              <span className="text-sm font-mono text-red-300">{filename}</span>
            </div>
          )}
          <pre className="overflow-x-auto p-5 bg-gradient-to-br from-gray-900 to-slate-900">
            <code className={`language-${language} font-mono text-sm text-red-100`}>{before}</code>
          </pre>
        </div>
      </div>
      
      <div className="space-y-3">
        <div className="flex items-center gap-2 text-sm font-bold text-emerald-400">
          <span className="w-2 h-2 bg-emerald-500 rounded-full"></span>
          After
        </div>
        <div className="bg-gradient-to-br from-emerald-950/30 to-green-900/20 border border-emerald-500/30 rounded-xl overflow-hidden shadow-lg">
          {filename && (
            <div className="bg-emerald-900/30 px-5 py-3 border-b border-emerald-500/30 flex items-center gap-3">
              <div className="flex gap-1.5">
                <div className="w-3 h-3 bg-red-500/50 rounded-full"></div>
                <div className="w-3 h-3 bg-yellow-500/50 rounded-full"></div>
                <div className="w-3 h-3 bg-green-500 rounded-full"></div>
              </div>
              <span className="text-sm font-mono text-emerald-300">{filename}</span>
            </div>
          )}
          <pre className="overflow-x-auto p-5 bg-gradient-to-br from-gray-900 to-slate-900">
            <code className={`language-${language} font-mono text-sm text-emerald-100`}>{after}</code>
          </pre>
        </div>
      </div>
    </div>
  )
}