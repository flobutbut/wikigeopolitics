/**
 * Client API unifié pour toutes les requêtes HTTP
 */

export interface ApiResponse<T = any> {
  data: T
  status: number
  statusText: string
}

export interface ApiError {
  message: string
  status?: number
  details?: any
}

export class ApiClient {
  private baseURL: string
  private defaultOptions: RequestInit

  constructor(baseURL: string = 'http://localhost:3000', options: RequestInit = {}) {
    this.baseURL = baseURL.replace(/\/$/, '') // Remove trailing slash
    this.defaultOptions = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    }
  }

  /**
   * Requête HTTP générique
   */
  async request<T = any>(
    endpoint: string, 
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> {
    const url = `${this.baseURL}${endpoint.startsWith('/') ? endpoint : '/' + endpoint}`
    
    const config: RequestInit = {
      ...this.defaultOptions,
      ...options,
      headers: {
        ...this.defaultOptions.headers,
        ...options.headers
      }
    }

    try {
      const response = await fetch(url, config)
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`)
      }

      const data = await response.json()
      
      return {
        data,
        status: response.status,
        statusText: response.statusText
      }
    } catch (error) {
      if (error instanceof Error) {
        throw {
          message: error.message,
          details: error
        } as ApiError
      }
      throw {
        message: 'Unknown API error',
        details: error
      } as ApiError
    }
  }

  /**
   * Requête GET
   */
  async get<T = any>(endpoint: string, params?: Record<string, any>): Promise<T> {
    let url = endpoint
    
    if (params) {
      const searchParams = new URLSearchParams()
      Object.entries(params).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          searchParams.append(key, String(value))
        }
      })
      const queryString = searchParams.toString()
      if (queryString) {
        url += (url.includes('?') ? '&' : '?') + queryString
      }
    }

    const response = await this.request<T>(url, { method: 'GET' })
    return response.data
  }

  /**
   * Requête POST
   */
  async post<T = any>(endpoint: string, data?: any): Promise<T> {
    const response = await this.request<T>(endpoint, {
      method: 'POST',
      body: data ? JSON.stringify(data) : undefined
    })
    return response.data
  }

  /**
   * Requête PUT
   */
  async put<T = any>(endpoint: string, data?: any): Promise<T> {
    const response = await this.request<T>(endpoint, {
      method: 'PUT',
      body: data ? JSON.stringify(data) : undefined
    })
    return response.data
  }

  /**
   * Requête DELETE
   */
  async delete<T = any>(endpoint: string): Promise<T> {
    const response = await this.request<T>(endpoint, { method: 'DELETE' })
    return response.data
  }
}

// Instance par défaut
export const apiClient = new ApiClient()

// Méthodes de convenance
export const api = {
  get: <T = any>(endpoint: string, params?: Record<string, any>) => 
    apiClient.get<T>(endpoint, params),
  
  post: <T = any>(endpoint: string, data?: any) => 
    apiClient.post<T>(endpoint, data),
  
  put: <T = any>(endpoint: string, data?: any) => 
    apiClient.put<T>(endpoint, data),
  
  delete: <T = any>(endpoint: string) => 
    apiClient.delete<T>(endpoint)
}