package com.example.formosaoilstation.near

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Divider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.formosaoilstation.data.Feature

@Composable
fun StationDetailScreen(feature: Feature) {
    val properties = feature.properties

    Column(modifier = Modifier
        .fillMaxSize()
        .padding(16.dp)) {
        Text(
            text = properties?.name ?: "",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        LazyColumn {
            item { DetailItem(label = "地址", value = properties?.address ?: "") }
            item { DetailItem(label = "電話", value = properties?.phone ?: "") }
            item { DetailItem(label = "營業時間", value = properties?.openTime ?: "") }
            item { DetailItem(label = "油品類型", value = getOilTypes(properties)) }
            item { DetailItem(label = "其他服務", value = getServices(properties)) }
            item { DetailItem(label = "支付方式", value = getPaymentMethods(properties)) }
        }
    }
}

@Composable
fun DetailItem(label: String, value: String) {
    Column(modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp)) {
        Text(
            text = label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.height(4.dp))
        Text(
            text = value,
            style = MaterialTheme.typography.bodyLarge,
            fontWeight = FontWeight.Medium
        )
        Divider(modifier = Modifier.padding(top = 8.dp))
    }
}

private fun getOilTypes(properties: com.example.formosaoilstation.data.Properties?): String {
    val oilTypes = mutableListOf<String>()
    properties?.has92?.let { if (it) oilTypes.add("92") }
    properties?.fuel92?.let { if (it) oilTypes.add("92") }
    properties?.has95Plus?.let { if (it) oilTypes.add("95Plus") }
    properties?.fuel95?.let { if (it) oilTypes.add("95Plus") }
    properties?.has98?.let { if (it) oilTypes.add("98") }
    properties?.fuel98?.let { if (it) oilTypes.add("98") }
    properties?.hasDiesel?.let { if (it) oilTypes.add("超級柴油") }
    return oilTypes.distinct().joinToString("、").ifEmpty { "N/A" }
}

private fun getServices(properties: com.example.formosaoilstation.data.Properties?): String {
    val services = mutableListOf<String>()
    properties?.airPump?.let { if (it) services.add("打氣機") }
    properties?.carWash?.let { if (it) services.add("洗車服務") }
    properties?.urea?.let { if (it) services.add("車用尿素水") }
    properties?.selfService?.let { if (it) services.add("自助加油設備") }
    properties?.upsService?.let { if (it) services.add("不斷電加油服務") }
    return services.distinct().joinToString("、").ifEmpty { "N/A" }
}

private fun getPaymentMethods(properties: com.example.formosaoilstation.data.Properties?): String {
    val payments = mutableListOf<String>()
    properties?.linePay?.let { if (it) payments.add("Line Pay") }
    properties?.piPay?.let { if (it) payments.add("Pi拍錢包") }
    properties?.iPass?.let { if (it) payments.add("一卡通") }
    properties?.fpccPay?.let { if (it) payments.add("台塑石油Pay") }
    properties?.travelCard?.let { if (it) payments.add("國旅卡") }
    properties?.pheasantCard?.let { if (it) payments.add("帝雉卡儲值") }
    properties?.easyPay?.let { if (it) payments.add("悠遊付") }
    properties?.easyCard?.let { if (it) payments.add("悠遊卡") }
    properties?.icash?.let { if (it) payments.add("愛金卡") }
    properties?.fpccApp?.let { if (it) payments.add("台塑石油APP") }
    properties?.coBrandedCard?.let { if (it) payments.add("台塑聯名卡") }
    properties?.businessCard?.let { if (it) payments.add("台塑商務卡") }
    properties?.nationalTravelCard?.let { if (it) payments.add("國民旅遊卡") }
    properties?.taxiCard?.let { if (it) payments.add("Taxi卡") }
    return payments.distinct().joinToString("、").ifEmpty { "N/A" }
}
