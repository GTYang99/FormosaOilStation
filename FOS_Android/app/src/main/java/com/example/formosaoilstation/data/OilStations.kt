package com.example.formosaoilstation.data

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class OilStations(
    val type: String? = null,
    val features: List<Feature>? = null
)

@Serializable
data class Feature(
    val type: String? = null,
    val geometry: Geometry? = null,
    val properties: Properties? = null
)

@Serializable
data class Geometry(
    val type: String? = null,
    val coordinates: List<Double>? = null
)

@Serializable
data class Properties(
    @SerialName("城市") val city: String? = null,
    @SerialName("站名") val name: String? = null,
    @SerialName("地址") val address: String? = null,
    @SerialName("電話") val phone: String? = null,
    @SerialName("營業時間") val openTime: String? = null,
    @SerialName("類型") val types: List<String>? = null,
    @SerialName("the98無鉛") val has98: Boolean? = null,
    @SerialName("98無鉛") val fuel98: Boolean? = null,
    @SerialName("the95Plus無鉛") val has95Plus: Boolean? = null,
    @SerialName("95Plus無鉛") val fuel95: Boolean? = null,
    @SerialName("the92無鉛") val has92: Boolean? = null,
    @SerialName("92無鉛") val fuel92: Boolean? = null,
    @SerialName("超級柴油") val hasDiesel: Boolean? = null,
    @SerialName("洗車服務") val carWash: Boolean? = null,
    @SerialName("打氣機") val airPump: Boolean? = null,
    @SerialName("車用尿素水") val urea: Boolean? = null,
    @SerialName("台塑石油PAY") val fpccPay: Boolean? = null,
    @SerialName("自助加油設備") val selfService: Boolean? = null,
    @SerialName("不斷電加油服務") val upsService: Boolean? = null,
    @SerialName("帝雉卡儲值") val pheasantCard: Boolean? = null,
    @SerialName("國旅卡") val travelCard: Boolean? = null,
    @SerialName("悠遊卡") val easyCard: Boolean? = null,
    @SerialName("一卡通") val iPass: Boolean? = null,
    @SerialName("愛金卡") val icash: Boolean? = null,
    @SerialName("Pi拍錢包") val piPay: Boolean? = null,
    @SerialName("街口支付") val jkoPay: Boolean? = null,
    @SerialName("LINE Pay") val linePay: Boolean? = null,
    @SerialName("悠遊付") val easyPay: Boolean? = null,
    @SerialName("台塑石油APP") val fpccApp: Boolean? = null,
    @SerialName("台塑聯名卡") val coBrandedCard: Boolean? = null,
    @SerialName("台塑商務卡") val businessCard: Boolean? = null,
    @SerialName("國民旅遊卡") val nationalTravelCard: Boolean? = null,
    @SerialName("Taxi卡") val taxiCard: Boolean? = null,
    @SerialName("place_id") val placeId: String? = null
)
