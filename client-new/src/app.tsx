import { ReactNode } from 'react'
import '../styles/globals.css'

// Custom App component for Vocs
export default function App({ children }: { children: ReactNode }) {
  return <>{children}</>
}