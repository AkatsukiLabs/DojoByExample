import { useState, useCallback, useEffect } from 'react'

interface AsyncState<T> {
  data: T | null
  loading: boolean
  error: Error | null
}

interface UseAsyncStateOptions {
  initialData?: any
  executeOnMount?: boolean
}

export function useAsyncState<T>(
  asyncFunction?: () => Promise<T>,
  options: UseAsyncStateOptions = {}
): [
  AsyncState<T>,
  (newAsyncFunction?: () => Promise<T>) => Promise<void>,
  () => void
] {
  const { initialData = null, executeOnMount = false } = options

  const [state, setState] = useState<AsyncState<T>>({
    data: initialData,
    loading: false,
    error: null,
  })

  const execute = useCallback(async (newAsyncFunction?: () => Promise<T>) => {
    const functionToExecute = newAsyncFunction || asyncFunction
    
    if (!functionToExecute) {
      console.warn('No async function provided to execute')
      return
    }

    setState(prev => ({ ...prev, loading: true, error: null }))

    try {
      const result = await functionToExecute()
      setState({
        data: result,
        loading: false,
        error: null,
      })
    } catch (error) {
      setState({
        data: null,
        loading: false,
        error: error instanceof Error ? error : new Error(String(error)),
      })
    }
  }, [asyncFunction])

  const reset = useCallback(() => {
    setState({
      data: initialData,
      loading: false,
      error: null,
    })
  }, [initialData])

  useEffect(() => {
    if (executeOnMount && asyncFunction) {
      execute()
    }
  }, [execute, executeOnMount, asyncFunction])

  return [state, execute, reset]
}

// Helper hook for common loading patterns
export function useLoading(initialState = false) {
  const [loading, setLoading] = useState(initialState)

  const withLoading = useCallback(async <T,>(asyncFn: () => Promise<T>): Promise<T> => {
    setLoading(true)
    try {
      const result = await asyncFn()
      return result
    } finally {
      setLoading(false)
    }
  }, [])

  return { loading, setLoading, withLoading }
}