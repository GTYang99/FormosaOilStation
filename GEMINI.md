# GEMINI.md

## 重要結論 (Important Conclusions)
*   Android專案 (FOS_Android) 的結構正在參照iOS專案 (formosaOilStation) 進行建置。
*   Android專案採用Gradle建置系統，並使用Jetpack Compose進行UI開發。
*   已初步檢查Android專案的核心檔案，包括`build.gradle.kts`、`settings.gradle.kts`、`libs.versions.toml`、`AndroidManifest.xml`和`MainActivity.kt`。
*   為了與iOS專案的架構對應，已在Android專案的`app/src/main/java/com/example/formosaoilstation/`目錄下創建了各個模組的子目錄，如`data/`、`map/`、`near/`、`price/`、`utilities/`、`ui/`、`navigation/`、`network/`。
*   實作了 Android 專案的導覽架構，對應 iOS 的 `MainTabBarController`。
    *   在 `gradle/libs.versions.toml` 中加入了 `navigation-compose`。
    *   在 `navigation/` 目錄下建立了 `NavigationItem` 與 `MainScreen`。
    *   在 `map/`、`near/` 與 `price/` 目錄下建立了佔位畫面：`MapScreen`、`FavoriteScreen`、`NearScreen`、`PriceScreen`。
    *   更新了 `MainActivity` 以使用導覽主畫面。
*   為了實現地圖功能，後續需要加入Google Maps、定位服務和廣告相關的依賴庫。

## 修改內容 (Modifications Made)
*   更新 `gradle/libs.versions.toml` 與 `app/build.gradle.kts`，加入 `androidx.navigation:navigation-compose`。
*   建立 `app/src/main/java/com/example/formosaoilstation/navigation/NavigationItem.kt`：定義底部導覽列項目 (Map, Favorite, Near, Price)。
*   建立 `app/src/main/java/com/example/formosaoilstation/navigation/MainScreen.kt`：包含 `Scaffold`、`NavigationBar` 與 `NavHost`。
*   建立各模組佔位畫面：
    *   `map/MapScreen.kt`
    *   `near/FavoriteScreen.kt`
    *   `near/NearScreen.kt`
    *   `price/PriceScreen.kt`
*   修改 `MainActivity.kt` 以載入 `MainScreen`。

**項目導覽架構已完成。**

## 下次待處理事項 (Next Steps)
*   更新 `gradle/libs.versions.toml` 和 `app/build.gradle.kts`，加入Google Maps、定位服務 (FusedLocationProviderClient) 和 Google AdMob 等必要的依賴庫。
*   實作定位服務，處理權限請求，並獲取使用者目前位置。
*   整合 `Google Maps SDK for Android` 到 `MapScreen.kt`。
*   解析GeoJSON資料，並在Android地圖上顯示客製化的站點標記 (markers)。
*   實作UI元件的點擊事件，例如：定位按鈕、站點列表按鈕、篩選重置按鈕。
*   使用Jetpack Navigation Component設定畫面之間的跳轉，例如從地圖畫面導向站點詳情畫面。

## 資料結構關係 (`formosaOilStation/formosaOilStation/Data/**`)

### 1. `OilStations.swift`
該文件定義了iOS專案中油站資訊的核心資料模型，採用Swift的Codable協議。

*   **`OilStations`**: 頂層結構，包含 `type` (String) 和 `features` (一個 `Feature` 物件陣列)。
*   **`Feature`**: 代表單一油站點。包含 `type` (FeatureType enum)、`geometry` (Geometry struct) 和 `properties` (Properties struct)。
*   **`Geometry`**: 包含 `type` (GeometryType enum，固定為 "Point") 和 `coordinates` (一個包含經緯度的 [Double] 陣列，順序為 [longitude, latitude])。
*   **`Properties`**: 包含油站的詳細資訊，例如：
    *   **基本資訊**: `城市`、`站名`、`地址`、`電話`、`營業時間` (皆為可選String)。
    *   **油站類型**: `類型` (一個 `類型` enum 陣列，如 "人工加油站據點", "自助加油站據點" 等)。
    *   **油品種類**: `the98無鉛`、`the95Plus無鉛`、`the92無鉛`、`超級柴油` (皆為Bool)。另外有 `fuel98`, `fuel95`, `fuel92` 作為別名。
    *   **服務與支付方式**: `洗車服務`、`打氣機`、`車用尿素水`、`台塑石油Pay`、`自助加油設備`、`不斷電加油服務`、`帝雉卡儲值`、`國旅卡`、`悠遊卡`、`一卡通`、`愛金卡`、`Pi拍錢包`、`街口支付`、`LINE Pay`、`悠遊付` (皆為Bool)。
    *   **其他相關資訊**: `台塑石油APP`、`台塑聯名卡`、`台塑商務卡`、`國民旅遊卡` (重複)、`Taxi卡` (皆為Bool)。
    *   **Google地點ID**: `place_id` (可選String)。
*   **Enums**: `GeometryType` (幾何類型), `類型` (油站營運類型), `FeatureType` (GeoJSON Feature類型), `加油站廠牌` (油站品牌), `油種` (油品種類)。
*   **Extension `Feature`**: 提供 `coordinate` 計算屬性，方便將 `geometry.coordinates` 轉換為 `CLLocationCoordinate2D`。
*   **API相關結構**: `MainAPI`, `ConnectAPI` (包含 `ParserURL` enum，用於油價和新聞), `NewsResponse`。這些用於從 `https://www.fpcc.com.tw` 獲取資料。

### 2. `fpccOilStation.geojson` 與 `fpccOilStation_place_id.geojson`
這些是GeoJSON格式的檔案。

*   **GeoJSON結構**: 包含一個 `FeatureCollection`，其中包含一個 `Feature` 物件陣列。
*   **`Feature` 物件**: 其結構與 `OilStations.swift` 中定義的 `Feature` 結構一致，包含 `type`、`geometry` (Point，包含 `coordinates` [longitude, latitude]) 和 `properties`。
*   **`properties` 內容**: 與 `OilStations.swift` 中的 `Properties` 結構相符，包含各油站的詳細資訊。
*   **`fpccOilStation_place_id.geojson` 的差異**: 此文件在 `properties` 中額外包含了 `place_id` 欄位，這表示它是一個包含Google地點ID的增強版資料。

### 3. `stations_data.json` 與 `stations_data_geojson.geojson`
*   **`stations_data.json`**: 這是JSON陣列，每個元素代表一個城市。
    *   **城市物件**: 包含 `城市` (城市名稱 String) 和 `站點資料` (一個油站物件陣列)。
    *   **油站物件**: 包含 `站名`、`地址`、`電話`、`營業時間`、油品種類 (如 "98無鉛")、服務 (如 "洗車服務")、支付方式 (如 "台塑石油PAY")、`緯度` (Latitude)、`經度` (Longitude) 和 `類型`。
    *   **注意**: 這裡的 `緯度` 和 `經度` 是獨立的欄位，與GeoJSON文件中的 `geometry.coordinates` 不同。
*   **`stations_data_geojson.geojson`**: 這是一個GeoJSON `FeatureCollection`。
    *   **GeoJSON結構**: 類似於 `fpccOilStation.geojson`，包含帶有 `geometry` (Point，包含 `coordinates` [longitude, latitude]) 和 `properties` 的 `Feature` 物件。
    *   **`properties` 內容**: 包含 `城市` 欄位以及 `stations_data.json` 中所有詳細的油站資訊。這表示 `stations_data_geojson.geojson` 是 `stations_data.json` 內容的GeoJSON表示形式，其中經緯度已整合到GeoJSON的 `geometry` 結構中。

### 資料關係總結:
*   `OilStations.swift` 定義了用於iOS應用中解析和處理油站資料的Codable結構，是這些資料的程式碼藍圖。
*   `fpccOilStation.geojson` 和 `fpccOilStation_place_id.geojson` 是GeoJSON格式的資料集，包含油站的位置和屬性。後者是包含Google Place ID的增強版。這些文件可能是地圖功能的主要地理資料來源。
*   `stations_data.json` 以城市分組的結構化列表形式提供站點資料，其中包含獨立的緯度和經度欄位。
*   `stations_data_geojson.geojson` 是 `stations_data.json` 內容的GeoJSON表示形式，更適合與支援GeoJSON的地理繪圖庫一起使用。

總體而言，`.swift` 文件提供了程式設計介面，而 `.geojson` 和 `.json` 文件則是相同油站資料的不同序列化形式，分別針對地理顯示和結構化列表等不同用途進行了優化。

## 模組架構 (`formosaOilStation/formosaOilStation/Map/**`)

此模組負責在地圖上顯示加油站資訊、處理使用者位置、篩選加油站以及導航至加油站詳情。

### 1. `FormosaViewModel.swift`
該類別作為地圖及其他相關功能的 ViewModel。
*   **核心職責：**
    *   **資料解析：** 將 GeoJSON 資料 (`fpccOilStation_place_id.geojson`) 解析為 `OilStations` 物件。
    *   **位置管理：** 使用 `CLLocationManager` 獲取並記錄使用者當前位置。
    *   **資料轉換：** 將 `Feature` 物件轉換為 `StagtionMKA` (MapKit 註解/標記)。
    *   **篩選和排序：** 提供按品牌、油品類型、營業時間和距離使用者位置篩選加油站的方法。它也根據距離對特徵進行排序。
    *   **API 呼叫：** 使用 `SwiftSoup` 進行 HTML 解析，從遠端 API 獲取油價和新聞。
    *   **Google Places API 整合：** 根據 `place_id` 使用 Google Places API 獲取加油站照片。
*   **回呼：** 使用各種回呼閉包 (`decoderCallBack`、`filterCallBack`、`locationCallBack`、`fuelPriceCallBack`、`newsCallBack`、`imageCallBack`、`imageFetchError`) 將結果傳回給 ViewController。
*   **資料儲存：** 儲存已解析的 `OilStations` 資料 (`dataJSON`)、篩選後的資料 (`filterData`) 和新聞資料 (`newsData`)。

### 2. `MapVC.swift`
這是負責顯示地圖並與 `FormosaViewModel` 互動的主要 ViewController。
*   **UI 元件：**
    *   `MKMapView`：顯示地圖和加油站註解/標記。
    *   `btnLocation`：將地圖中心定位到使用者當前位置的按鈕。
    *   `btnNearList`：用於顯示附近加油站列表 (`OilNearListVC`) 的按鈕。
    *   `btnDisfilter`：清除活動篩選條件並顯示所有加油站的按鈕。
    *   `bannerView`：使用 Google Mobile Ads SDK 顯示廣告。
*   **地圖互動：**
    *   處理 `MKMapViewDelegate` 方法以進行區域更改和註解視圖創建。
    *   `putStationMarker`：根據 ViewModel 的資料在地圖上添加和刪除加油站註解/標記。
    *   `navigateTo`：打開 Apple Maps 導航到選定的加油站。
*   **與 ViewModel 整合：** 觀察 `vm.filterCallBack` 和 `vm.locationCallBack` 以更新地圖和使用者位置。
*   **依賴項：** 使用 `MapKit`、`CoreLocation`、`SnapKit`（用於 UI 佈局）和 `GoogleMobileAds`。

### 3. `PinMKAView.swift`
這個自定義的 `MKAnnotationView` 用於在地圖上顯示單個加油站標記。
*   **自定義 UI：**
    *   使用自定義圖像 (`stationPin2`) 作為圖釘。
    *   包含一個 `calloutView`，當圖釘被選中時，顯示加油站標題、副標題（電話號碼）和標誌圖像。
    *   `drawTriangleView`：為呼出氣泡創建一個小的三角形圖形。
*   **互動：** 當自定義呼出氣泡被點擊時，觸發 `tappedCallOut` 閉包，通常用於導航到 `StationDetailVC`。

### 4. `StagtionMKA.swift`
這個自定義的 `NSObject` 符合 `MKAnnotation` 協議，表示地圖註解/標記中的加油站。
*   **註解的資料模型：**
    *   儲存 `coordinate` (CLLocationCoordinate2D)、`title`（站名）、`subtitle`（站點電話）和 `img`（站點標誌），用於在地圖上顯示。
    *   儲存 GeoJSON 資料中的原始 `Feature` 和 `Properties` 物件，將註解直接連結到其原始資料。
    *   `configuare`：從 `Feature` 物件填充其屬性。

### 5. `StationDetailVC.swift`
此 ViewController 顯示有關所選加油站的詳細資訊。
*   **UI 元件：**
    *   `topImageView`：加油站圖像的佔位符（目前使用“佔位圖”）。
    *   `stationTitleLabel`、`addressLabel`、`distanceLabel`、`openInfoLabel`：顯示加油站詳細資訊。
    *   `logoImageView`：顯示加油站的品牌標誌。
    *   `buttonStack`：包含“收藏”（添加到收藏夾）、“分享”和“導航”按鈕。
*   **功能：**
    *   `configure`：使用 `Feature` 物件的資料設置 UI。
    *   `addToFavorites`：使用 `MainManager.shared.saveFavoriteStations` 將加油站保存到使用者收藏夾。
    *   `direction`：使用 Apple Maps 啟動導航到加油站位置（通過設置 `MapVC` 上的 `directionLocation`）。
    *   `shareStation`：呈現 `UIActivityViewController` 以分享加油站詳細資訊。
*   **依賴項：** 使用 `MapKit` 進行導航，並使用 `MainManager` 進行實用功能（如 `transICON` 和保存收藏夾）。

**關係和流程：**

*   `MapVC` 實例化並持有 `FormosaViewModel`。
*   `FormosaViewModel` 獲取並處理原始 GeoJSON 資料、使用者位置和其他 API 資料。
*   `FormosaViewModel` 將 `Feature` 物件轉換為 `StagtionMKA` 註解。
*   `MapVC` 使用 `StagtionMKA` 物件將標記添加到其 `MKMapView`。
*   `PinMKAView` 是 `StagtionMKA` 在地圖上的自定義視覺表示。
*   點擊 `PinMKAView` 的呼出氣泡會觸發導航到 `StationDetailVC`，並傳遞 `Feature` 資料。
*   `StationDetailVC` 顯示詳細資訊並允許執行保存到收藏夾、分享或導航等操作。
*   `StationDetailVC` 還可以通過 `directionLocation` 在 `MapVC` 上觸發導航。

## 模組架構 (`formosaOilStation/formosaOilStation/Near/**`)

此模組負責顯示附近或收藏的加油站列表，以及顯示加油站的詳細屬性。

### 1. `NearVC.swift`
這是顯示加油站列表的主要 ViewController。
*   **功能：**
    *   **雙重用途：** 根據 `isNearShown` 標記，顯示「附近加油站」或「收藏加油站」。
    *   **資料顯示：** 使用 `UITableView` 展示加油站。
    *   **與 ViewModel 整合：** 使用 `FormosaViewModel` 獲取、排序並格式化距離資訊。
    *   **互動：** 
        *   點擊 Cell 導覽至 `NearStationDetailVC`。
        *   Cell 內的導航按鈕可切換回地圖並定位。
        *   支援左滑刪除（僅限收藏列表）。
*   **UI 元件：** `tbNearby` (UITableView), `lbTitle` (UILabel)。

### 2. `NearStationCell.swift`
自定義的 `UITableViewCell`，用於列表項目的顯示。
*   **顯示內容：** 品牌圖示、站名、地址、營業時間、距離。
*   **互動元件：**
    *   `btnDirection`：觸發導航回地圖的回呼。
    *   `btnFavorite`：將站點加入或移除收藏。
*   **佈局：** 使用 `SnapKit` 進行響應式佈局。

### 3. `NearStationDetailVC.swift`
顯示選定加油站詳細資訊的 ViewController。
*   **呈現方式：** 使用 `UITableView` (靜態樣式) 列出各項屬性。
*   **顯示內容：**
    *   站名、地址、電話、營業時間。
    *   油品類型（92, 95+, 98, 柴油等）。
    *   其他服務（洗車、打氣機、尿素水等）。
    *   支付方式（LINE Pay, 悠遊付, 聯名卡等）。
*   **互動：** 
    *   點擊地址：切換回地圖並設定導航目標。
    *   點擊電話：觸發撥號功能。


**關係和流程：**
*   `NearVC` 根據應用狀態決定顯示哪些站點。
*   `NearStationCell` 封裝了單個站點的概覽資訊與快速操作按鈕。
*   `NearStationDetailVC` 透過表格形式展示 GeoJSON 中 `properties` 的完整細節。
*   此模組與 `MapVC` 緊密連動，許多操作（如導航）會將使用者帶回地圖畫面。

## Android 專案 Near 模組實作 (Android Project Near Module Implementation)

### 1. 依賴庫更新 (`gradle/libs.versions.toml` & `app/build.gradle.kts`)
*   在 `gradle/libs.versions.toml` 中新增 `kotlinxSerialization = "1.6.3"` 和 `playServicesLocation = "21.3.0"`。
*   在 `app/build.gradle.kts` 的 `plugins` 區塊加入 `alias(libs.plugins.kotlin.serialization)`。
*   在 `app/build.gradle.kts` 的 `dependencies` 區塊加入 `implementation(libs.kotlinx.serialization.json)` 和 `implementation(libs.play.services.location)`。

### 2. 資料模型 (`data/OilStations.kt`)
*   根據 iOS 專案的 `OilStations.swift`，建立了 `OilStations.kt`、`Feature.kt`、`Geometry.kt` 和 `Properties.kt` 資料類別，使用 `kotlinx.serialization` 進行 JSON 解析。
*   `fpccOilStation_place_id.geojson` 資料檔案已複製到 `app/src/main/assets/` 目錄下。

### 3. ViewModel (`near/NearViewModel.kt`)
*   創建了 `NearViewModel.kt`，負責：
    *   從 `fpccOilStation_place_id.geojson` 載入並解析加油站資料。
    *   管理收藏加油站的狀態 (`_favoriteStations`)。
    *   提供 `toggleFavorite` 方法來新增/移除收藏。

### 4. UI 元件 (`near/StationItem.kt`)
*   創建了 `StationItem.kt` Compose Composable，對應 iOS 的 `NearStationCell.swift`。
*   顯示加油站的名稱、地址、營業時間和距離 (目前為佔位符)。
*   包含導航按鈕和收藏按鈕，並處理點擊事件。

### 5. 畫面 (`near/NearScreen.kt` & `near/FavoriteScreen.kt`)
*   更新 `near/NearScreen.kt` 顯示所有加油站列表，並整合 `NearViewModel` 和 `StationItem`。
*   更新 `near/FavoriteScreen.kt` 顯示收藏的加油站列表，並整合 `NearViewModel` 和 `StationItem`。

### 6. 詳情畫面 (`near/StationDetailScreen.kt`)
*   創建了 `StationDetailScreen.kt` Compose Composable，對應 iOS 的 `NearStationDetailVC.swift`。
*   顯示單一加油站的詳細資訊，包括地址、電話、營業時間、油品類型、其他服務和支付方式。

### 7. 導航整合 (`navigation/NavigationItem.kt` & `navigation/MainScreen.kt`)
*   在 `navigation/NavigationItem.kt` 中新增 `StationDetail` 路由，用於導航到加油站詳情畫面，並帶有 `stationName` 參數。
*   修改 `navigation/MainScreen.kt` 中的 `NavigationGraph`，將 `onStationClick` 回呼傳遞給 `NearScreen` 和 `FavoriteScreen`，以便導航到 `StationDetailScreen`。
*   `MainScreen.kt` 新增 `StationDetailScreenWrapper` Composable，用於從 `NearViewModel` 獲取 `Feature` 資料並傳遞給 `StationDetailScreen`。

### 8. 權限更新 (`AndroidManifest.xml`)
*   在 `AndroidManifest.xml` 中新增 `ACCESS_FINE_LOCATION` 和 `ACCESS_COARSE_LOCATION` 權限，為後續定位服務的實作做準備。

