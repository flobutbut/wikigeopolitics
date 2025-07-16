export interface Conflict {
  id: string
  name: string
  status?: string
  startDate?: string
  endDate?: string
  description?: string
}

export interface ConflictDetailData {
  id: string
  title: string
  type?: string
  statut?: string
  intensite?: string
  dateDebut?: string
  dateFin?: string
  localisation?: string
  zones?: string[]
  victimes?: Record<string, any>
  paysImpliques?: Array<{
    id: string
    nom: string
    flag?: string
    role?: string
    dateEntree?: string
  }>
  timeline?: Array<{
    id: string
    date: string
    titre: string
    description?: string
  }>
  effortsPaix?: Array<{
    id: string
    type: string
    description: string
    date?: string
  }>
  consequences?: Array<{
    type: string
    description: string
  }>
} 