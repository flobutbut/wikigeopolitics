<template>
  <div id="map" ref="mapContainer" class="map-container"></div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, onUnmounted, watch, nextTick, createApp } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import { useMapStore } from '@/stores/mapStore'
import ConflictMarker from './ConflictMarker.vue'

export default defineComponent({
  name: 'MapComponent',
  
  props: {
    initialView: {
      type: Array as unknown as () => [number, number],
      default: () => [20, 0] as [number, number]
    },
    initialZoom: {
      type: Number,
      default: 2
    },
    countriesData: {
      type: Array,
      default: () => []
    }
  },
  
  emits: ['map-click', 'map-ready', 'country-selected', 'conflict-selected'],
  
  setup(props, { emit }) {
    const mapContainer = ref<HTMLElement | null>(null)
    const mapStore = useMapStore()
    let map: L.Map | null = null
    let countryMarkers: L.Marker[] = []
    let conflictMarkers: L.Marker[] = []
    let selectedMarker: L.Marker | null = null
    
    onMounted(() => {
      if (!mapContainer.value) return
      
      // Initialisation de la carte avec Leaflet
      map = L.map(mapContainer.value).setView(props.initialView, props.initialZoom)
      
      // Ajouter une couche de tuiles OpenStreetMap
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
      }).addTo(map)
      

      
      // Créer les marqueurs pour tous les pays
      createCountryMarkers()
      
      // Gérer les évènements
      map.on('click', (e: L.LeafletMouseEvent) => {
        emit('map-click', e.latlng)
      })
      
      // Émettre un événement quand la carte est prête
      emit('map-ready', map)
    })
    
    onUnmounted(() => {
      // Nettoyer la carte lors de la destruction du composant
      if (map) {
        map.remove()
        map = null
      }
      clearMarkers()
    })
    
    // Créer les marqueurs pour les pays (filtrés selon le mode d'affichage)
    const createCountryMarkers = () => {
      if (!map || !props.countriesData) {
        clearMarkers()
        return
      }
      
      clearMarkers()
      
      // Filtrer les pays selon le mode d'affichage du mapStore
      let countriesToShow = props.countriesData
      
      if (mapStore.countryDisplayMode === 'none') {
        countriesToShow = []
      } else if (mapStore.countryDisplayMode === 'selected') {
        // Ne montrer que les pays sélectionnés
        countriesToShow = props.countriesData.filter((country: any) => 
          mapStore.selectedCountries.includes(country.id)
        )
      }
      // Si mode 'all', on garde tous les pays (comportement par défaut)
      
      countriesToShow.forEach((country: any) => {
        if (country.coordinates && Array.isArray(country.coordinates) && country.coordinates.length === 2) {
          try {
            const [lng, lat] = country.coordinates
            const coords: [number, number] = [lat, lng] // Leaflet attend [lat, lng]
            
            const marker = L.marker(coords, {
              icon: L.divIcon({
                className: 'country-marker',
                html: `<div class="marker-content">${country.flag}</div>`,
                iconSize: [30, 30],
                iconAnchor: [15, 15]
              }),
              zIndexOffset: 1000 // Forcer un Z-index élevé
            }).addTo(map!)
            
            // Gérer le clic sur le marqueur
            marker.on('click', () => {
              // Mettre en évidence le marqueur sélectionné
              highlightSelectedMarker(marker, country)
              emit('country-selected', country)
            })
            
            countryMarkers.push(marker)
          } catch (error) {
            console.warn(`Erreur lors de la création du marqueur pour ${country.title}:`, error)
          }
        }
      })
    }
    
    // Mettre en évidence le marqueur sélectionné
    const highlightSelectedMarker = (marker: L.Marker, country: any) => {
      // Retirer la mise en évidence précédente
      if (selectedMarker && map) {
        map.removeLayer(selectedMarker)
        selectedMarker = null
      }
      
      // Créer un marqueur de sélection plus grand
      const [lng, lat] = country.coordinates
      const coords: [number, number] = [lat, lng]
      
      selectedMarker = L.marker(coords, {
        icon: L.divIcon({
          className: 'country-marker selected',
          html: `<div class="marker-content selected">${country.flag}</div>`,
          iconSize: [40, 40],
          iconAnchor: [20, 20]
        }),
        zIndexOffset: 2000 // Au-dessus des autres marqueurs
      }).addTo(map!)
    }
    
    // Créer les marqueurs de conflits armés
    const createConflictMarkersNEW = () => {
      console.log('[Map] 🚀 Création des marqueurs de zones de combat')
      
      // Vérifications de base
      if (!map || !mapStore.armedConflicts || !mapStore.visibleLayers.armedConflicts) {
        console.log('[Map] Conditions non remplies pour afficher les marqueurs')
        return
      }
      
      // Nettoyer les anciens marqueurs
      console.log('[Map] 🧹 Nettoyage des anciens marqueurs...')
      conflictMarkers.forEach(marker => {
        try {
          map!.removeLayer(marker)
        } catch (e) {
          console.warn('[Map] Erreur lors de la suppression d\'un marqueur:', e)
        }
      })
      conflictMarkers = []
      
      const features = mapStore.armedConflicts.features
      console.log('[Map] 📊 Nombre de features à traiter:', features?.length || 0)
      
      if (!features || !Array.isArray(features)) {
        console.error('[Map] ❌ Features invalides:', features)
        return
      }
      
      // Créer les marqueurs
      let created = 0
      features.forEach((feature: any, index: number) => {
        try {
          const coords = feature.geometry?.coordinates
          const props = feature.properties
          
          if (!coords || !props) {
            console.warn(`[Map] ⚠️ Feature ${index} incomplète`)
            return
          }
          
          // Créer un marqueur simple avec emoji
          console.log(`[Map] 📍 Création marqueur ${index}: nom="${props.name}", coords brutes=[${coords}], coords Leaflet=[${coords[1]}, ${coords[0]}]`)
          const marker = L.marker([coords[1], coords[0]], {
            icon: L.divIcon({
              className: 'simple-conflict-marker',
              html: '<div style="font-size: 32px; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; background: transparent;">💥</div>',
              iconSize: [40, 40],
              iconAnchor: [20, 20]
            })
          }).addTo(map!)
          
          console.log(`[Map] 🔥 Marqueur ${index} ajouté à la carte:`, props.name)
          
          marker.bindPopup(`<strong>${props.name}</strong><br/>${props.description || ''}`)
          conflictMarkers.push(marker)
          console.log(`[Map] 📝 Marqueur ${index} ajouté au tableau, total:`, conflictMarkers.length)
          created++
          
        } catch (error) {
          console.error(`[Map] ❌ Erreur création marqueur ${index}:`, error)
        }
      })
      
      console.log(`[Map] ✅ ${created} marqueurs de zones de combat créés !`)
      
      // TEST AVEC DÉLAI pour voir si les marqueurs sont supprimés
      setTimeout(() => {
        console.log(`[Map] 🕒 Après 2 secondes: ${conflictMarkers.length} marqueurs restants`)
      }, 2000)
      
      setTimeout(() => {
        console.log(`[Map] 🕒 Après 5 secondes: ${conflictMarkers.length} marqueurs restants`)
      }, 5000)
      
      // TEST BRUTAL - Marqueur fixe sur Paris pour vérifier le système
      if (false) {
        console.log('[Map] 🧪 CRÉATION MARQUEUR TEST SUR PARIS')
        const testMarker = L.marker([48.8566, 2.3522], {
          icon: L.divIcon({
            className: 'test-marker',
            html: '<div style="font-size: 40px; background: blue; border-radius: 50%; width: 50px; height: 50px; display: flex; align-items: center; justify-content: center;">🔥</div>',
            iconSize: [50, 50],
            iconAnchor: [25, 25]
          })
        }).addTo(map!)
        
        testMarker.bindPopup('<strong>MARQUEUR TEST PARIS</strong>')
        conflictMarkers.push(testMarker)
        console.log('[Map] 🧪 MARQUEUR TEST CRÉÉ SUR PARIS')
      }
    }
    
    // Nettoyer les marqueurs de conflits
    const clearConflictMarkers = () => {
      console.log(`[Map] 🗑️ SUPPRESSION de ${conflictMarkers.length} marqueurs !`)
      console.trace('[Map] 🗑️ STACK TRACE de la suppression:')
      conflictMarkers.forEach(marker => {
        if (map) map.removeLayer(marker)
      })
      conflictMarkers = []
    }
    
    // Nettoyer tous les marqueurs
    const clearMarkers = () => {
      console.log('[Map] 🧹 Nettoyage des marqueurs PAYS seulement (pas les conflits!)')
      countryMarkers.forEach(marker => {
        if (map) map.removeLayer(marker)
      })
      countryMarkers = []
      
      // NE PAS effacer les marqueurs de conflits ici !
      // clearConflictMarkers()
      
      if (selectedMarker && map) {
        map.removeLayer(selectedMarker)
        selectedMarker = null
      }
    }
    
    // Surveiller les changements de données
    watch(() => props.countriesData, async (newData) => {
      // Attendre que Vue ait terminé ses mises à jour
      await nextTick()
      
      if (map) {
        // Toujours recréer les marqueurs, même si pas de données (pour les effacer)
        createCountryMarkers()
      }
    }, { immediate: true, deep: true })
    
    // Surveiller les conflits armés
    let lastFeaturesCount = 0
    watch(() => [mapStore.armedConflicts?.features?.length, mapStore.visibleLayers.armedConflicts], ([featuresCount, isVisible]) => {
      // Éviter la boucle infinie en vérifiant si quelque chose a vraiment changé
      if (featuresCount === lastFeaturesCount && !isVisible) return
      
      console.log('[Map] 👀 Watcher conflits armés:', { featuresCount, isVisible })
      
      if (map) {
        if (featuresCount > 0 && isVisible) {
          lastFeaturesCount = featuresCount
          createConflictMarkersNEW()
        } else if (!isVisible || featuresCount === 0) {
          // Nettoyer les marqueurs si la couche devient invisible ou s'il n'y a plus de données
          console.log('[Map] 🗑️ Nettoyage des marqueurs de conflits (couche invisible ou pas de données)')
          clearConflictMarkers()
          lastFeaturesCount = 0
        }
      }
    }, { immediate: false })
    
    // Surveiller les changements du mode d'affichage des pays et des sélections
    watch(() => [mapStore.countryDisplayMode, mapStore.selectedCountries], () => {
      if (map) {
        createCountryMarkers()
      }
    }, { immediate: true, deep: true })
    
    // Surveiller les demandes de zoom du mapStore
    watch(() => mapStore.targetZoom, (targetZoom) => {
      if (targetZoom && map) {
        const [lng, lat] = targetZoom.coordinates
        map.setView([lat, lng], targetZoom.zoom)
        console.log(`Zoom vers ${targetZoom.name || 'coordonnées'}: [${lat}, ${lng}] niveau ${targetZoom.zoom}`)
        
        // Effacer la demande de zoom après l'avoir traitée
        mapStore.clearTargetZoom()
      }
    })
    
    // Méthodes exposées pour interagir avec la carte
    const addMarker = (position: L.LatLngExpression, popupContent?: string) => {
      if (!map) return null
      
      const marker = L.marker(position).addTo(map)
      
      if (popupContent) {
        marker.bindPopup(popupContent)
      }
      
      return marker
    }
    
    const setView = (center: L.LatLngExpression, zoom: number) => {
      if (map) {
        map.setView(center, zoom)
      }
    }
    
    // Méthode pour zoomer sur un pays
    const zoomToCountry = (countryId: string) => {
      if (!map) return
      
      const country = props.countriesData.find((c: any) => c.id === countryId)
      if (country && (country as any).coordinates) {
        const [lng, lat] = (country as any).coordinates
        map.setView([lat, lng], 6)
        
        // Mettre en évidence le marqueur
        const marker = countryMarkers.find(m => {
          const markerLatLng = m.getLatLng()
          return markerLatLng.lat === lat && markerLatLng.lng === lng
        })
        
        if (marker) {
          highlightSelectedMarker(marker, country)
        }
      }
    }
    
    return {
      mapContainer,
      addMarker,
      setView,
      zoomToCountry
    }
  }
})
</script>

<style scoped>
.map-container {
  height: 100%;
  width: 100%;
  background-color: #A5CCDA;
}

/* Assurez-vous que le conteneur parent a une hauteur définie */
:deep(.leaflet-container) {
  height: 100%;
  width: 100%;
}

/* Styles pour les marqueurs de pays */
:deep(.country-marker) {
  background: none;
  border: none;
  z-index: 1000 !important;
}

:deep(.marker-content) {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  background: white;
  border: 2px solid #333;
  border-radius: 50%;
  font-size: 16px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
  cursor: pointer;
}

:deep(.marker-content:hover) {
  transform: scale(1.1);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

:deep(.marker-content.selected) {
  width: 40px;
  height: 40px;
  font-size: 20px;
  background: #ff6b6b;
  border-color: #ff4757;
  box-shadow: 0 0 0 4px rgba(255, 107, 107, 0.3);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(255, 107, 107, 0.7);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(255, 107, 107, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(255, 107, 107, 0);
  }
}

/* Styles pour les marqueurs de conflits */
:deep(.conflict-marker) {
  background: none;
  border: none;
  z-index: 1500 !important;
}

:deep(.conflict-marker-content) {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  font-size: 18px;
  border-radius: 50%;
  background: rgba(255, 0, 0, 0.1);
  border: 2px solid #ff4444;
  cursor: pointer;
  transition: transform 0.2s ease;
}

:deep(.conflict-marker-content:hover) {
  transform: scale(1.1);
  background: rgba(255, 0, 0, 0.2);
}

/* Styles pour les popups de conflits */
:deep(.conflict-popup h4) {
  margin: 0 0 8px 0;
  color: #d32f2f;
  font-size: 14px;
  font-weight: 600;
}

:deep(.conflict-popup p) {
  margin: 4px 0;
  font-size: 12px;
  line-height: 1.4;
}

:deep(.conflict-popup .conflict-description) {
  margin-top: 8px;
  color: #666;
  font-style: italic;
  max-width: 200px;
}
</style> 