package com.example.formosaoilstation.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.Payments
import androidx.compose.ui.graphics.vector.ImageVector

sealed class NavigationItem(val route: String, val icon: ImageVector, val title: String) {
    object Map : NavigationItem("map", Icons.Default.Map, "Map")
    object Favorite : NavigationItem("favorite", Icons.Default.Favorite, "Favorite")
    object Near : NavigationItem("near", Icons.Default.LocationOn, "Near")
    object Price : NavigationItem("price", Icons.Default.Payments, "Price")
    object StationDetail : NavigationItem("stationDetail/{stationName}", Icons.Default.LocationOn, "Station Detail") {
        fun createRoute(stationName: String) = "stationDetail/$stationName"
    }
}
