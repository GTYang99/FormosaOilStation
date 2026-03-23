package com.example.formosaoilstation.near

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.formosaoilstation.data.Feature
import com.example.formosaoilstation.data.OilStations
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import java.io.InputStreamReader

class NearViewModel(application: Application) : AndroidViewModel(application) {

    private val _stations = MutableStateFlow<List<Feature>>(emptyList())
    val stations: StateFlow<List<Feature>> = _stations

    private val _favoriteStations = MutableStateFlow<Set<String>>(emptySet())
    val favoriteStations: StateFlow<Set<String>> = _favoriteStations

    private val json = Json { ignoreUnknownKeys = true }

    init {
        loadStations()
    }

    private fun loadStations() {
        viewModelScope.launch {
            try {
                val assetManager = getApplication<Application>().assets
                val inputStream = assetManager.open("fpccOilStation_place_id.geojson")
                val reader = InputStreamReader(inputStream)
                val content = reader.readText()
                val oilStations = json.decodeFromString<OilStations>(content)
                _stations.value = oilStations.features ?: emptyList()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun toggleFavorite(stationName: String) {
        val currentFavorites = _favoriteStations.value.toMutableSet()
        if (currentFavorites.contains(stationName)) {
            currentFavorites.remove(stationName)
        } else {
            currentFavorites.add(stationName)
        }
        _favoriteStations.value = currentFavorites
    }
}
