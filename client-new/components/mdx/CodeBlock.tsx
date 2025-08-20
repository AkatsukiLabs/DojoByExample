import { useState } from 'react'

interface CodeBlockProps {
  children: string
  language?: string
  filename?: string
  highlight?: string // e.g., "1,3-5,10"
  showLineNumbers?: boolean
  title?: string
}

export function CodeBlock({
  children,
  language = 'text',
  filename,
  highlight,
  showLineNumbers = false,
  title
}: CodeBlockProps) {
  const [copied, setCopied] = useState(false)

  const copyToClipboard = async () => {
    await navigator.clipboard.writeText(children)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  // Parse highlighted lines
  const highlightedLines = new Set<number>()
  if (highlight) {
    highlight.split(',').forEach(part => {
      if (part.includes('-')) {
        const [start, end] = part.split('-').map(Number)
        for (let i = start; i <= end; i++) {
          highlightedLines.add(i)
        }
      } else {
        highlightedLines.add(Number(part))
      }
    })
  }

  const lines = children.split('\n')

  return (
    <div className="relative group my-6">
      {(filename || title) && (
        <div className="flex items-center justify-between bg-background-tertiary border border-border border-b-0 rounded-t-lg px-4 py-2">
          <span className="text-sm font-mono text-text-secondary">
            {filename || title}
          </span>
          <span className="text-xs text-text-muted">{language}</span>
        </div>
      )}
      
      <div className={`relative bg-background-tertiary border border-border ${filename || title ? 'rounded-b-lg' : 'rounded-lg'} overflow-hidden`}>
        <button
          onClick={copyToClipboard}
          className="absolute top-2 right-2 z-10 px-3 py-1 text-xs bg-surface hover:bg-surface-hover border border-border rounded opacity-0 group-hover:opacity-100 transition-opacity"
          aria-label="Copy code"
        >
          {copied ? '✓ Copied' : 'Copy'}
        </button>
        
        <pre className="overflow-x-auto p-4">
          <code className={`language-${language}`}>
            {showLineNumbers ? (
              <div className="flex">
                <div className="flex flex-col text-text-muted text-sm pr-4 select-none">
                  {lines.map((_, i) => (
                    <span key={i} className="text-right">
                      {i + 1}
                    </span>
                  ))}
                </div>
                <div className="flex-1">
                  {lines.map((line, i) => (
                    <div
                      key={i}
                      className={
                        highlightedLines.has(i + 1)
                          ? 'bg-dojo-primary/10 -mx-4 px-4'
                          : ''
                      }
                    >
                      {line}
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              children
            )}
          </code>
        </pre>
      </div>
    </div>
  )
}