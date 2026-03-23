package com.example.formosaoilstation.near

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable
fun NearScreen(
    onStationClick: (String) -> Unit,
    viewModel: NearViewModel = viewModel()
) {
    val stations by viewModel.stations.collectAsState()
    val favoriteStations by viewModel.favoriteStations.collectAsState()

    Column(modifier = Modifier.fillMaxSize()) {
        Text(
            text = "Near Station",
            fontSize = 32.sp,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(16.dp)
        )

        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 8.dp)
        ) {
            items(stations) { feature ->
                StationItem(
                    feature = feature,
                    distance = null, // Placeholder for now
                    isFavorite = favoriteStations.contains(feature.properties?.name ?: ""),
                    onFavoriteClick = { viewModel.toggleFavorite(feature.properties?.name ?: "") },
                    onDirectionClick = { /* Handle direction */ },
                    onItemClick = { onStationClick(feature.properties?.name ?: "") }
                )
            }
        }
    }
}
