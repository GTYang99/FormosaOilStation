package com.example.formosaoilstation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.example.formosaoilstation.navigation.MainScreen
import com.example.formosaoilstation.ui.theme.FormosaOilStationTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            FormosaOilStationTheme {
                MainScreen()
            }
        }
    }
}
