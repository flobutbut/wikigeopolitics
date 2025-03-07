import { scrollbar } from './scrollbar'

export default {
  install(app) {
    // Enregistrer la directive v-scrollbar
    app.directive('scrollbar', scrollbar)
  }
} 