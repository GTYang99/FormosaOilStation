import requests
import json
from bs4 import BeautifulSoup

def fetch_city_data(url):
    """
    提取縣市資料
    """
    # 先發送 GET 請求來獲取頁面內容
    headers = {
        "User-Agent": "Mozilla/5.0"
    }

    cities_list = []

    response = requests.get(url, headers=headers)

    # 用 BeautifulSoup 解析 HTML
    soup = BeautifulSoup(response.text, "html.parser")

    # 找到縣市選單的表單或相關資料
    city_select = soup.find("select", {"name": "dc_srhzipadr_0"})
    if city_select:
        # 列出所有可選的縣市
        cities = {option.text.strip(): option["value"].strip() for option in city_select.find_all("option") if option["value"].strip()}
        # print("可選縣市:", cities)
        cities_list.append(cities)
        return cities_list

def fetch_table_data(city_name, url, city_code):
    """
    提取表格資料
    """
    headers = {
        "User-Agent": "Mozilla/5.0"
    }

    form_data = {
        "dc_srhzipadr_0": city_name,
        "dc_srhtype_0": city_code,
        "dc_btn_0": "Func_Search"
    }

    response = requests.post(url, headers=headers, data=form_data)
    soup = BeautifulSoup(response.text, "html.parser")

    table = soup.find("table")
    if not table:
        return [], []

    # 提取表頭
    header_row = []
    thead = table.find("thead")
    if thead:
        header_rows = thead.find_all("tr")
        if len(header_rows) == 1:  # 確保有第二個 <tr>
            header_row = [th.text.strip() for th in header_rows[0].find_all("th")]
        if len(header_rows) > 1:
            header_row = [th.text.strip() for th in header_rows[1].find_all("th")]

    # 提取表格內容
    result_list = []
    rows = table.find_all("tr")[1:]  # 跳過表頭
    for row in rows:
        row_data = []
        colsTD = row.find_all("td")
        for col in colsTD:
            img = col.find("img")
            if img and "circle_orange.png" in img.get("src", ""):
                row_data.append(True)
            else:
                text = col.text.strip().replace("\r\n\t\t\t\t\t\t\t\t\t\t-\r\n\t\t\t\t\t\t\t\t\t\t", "-")
                row_data.append(text if text else False)
        if any(row_data):  # 避免空列
            result_list.append(row_data)
    print(f'result_list:{result_list}')
    return header_row, result_list

def save_to_json(data, filename):
    """
    將資料保存為 JSON 檔案
    """
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    print(f"資料已保存至 {filename}")

    
def get_coordinates(address):
    """
    使用 Google Maps Geocoding API 將地址轉換為經緯度座標
    """

    base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    api_key = "AIzaSyBs36elTzemAznF6xG0uwYY0pBwPkoauPY"

    params = {
        "address": address,
        "key": api_key
    }
    response = requests.get(base_url, params=params)
    print(f"請求 URL: {response.url}")  # 輸出請求的完整 URL 以便調試
    if response.status_code == 200:
        data = response.json()
        if data["status"] == "OK":
            location = data["results"][0]["geometry"]["location"]
            return location["lat"], location["lng"]
        else:
            print(f"地理編碼失敗: {data['status']}")
            return None, None
    else:
        print(f"HTTP 請求失敗，狀態碼: {response.status_code}")
        return None, None

def convert_to_geojson(data):
    """
    將站點資料轉換為 GeoJSON 格式
    """
    geojson = {
        "type": "FeatureCollection",
        "features": []
    }

    for city_data in data:
        city_name = city_data["城市"]
        for station in city_data["站點資料"]:
            經度 = station["經度"]
            緯度 = station["緯度"]
            feature = {
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [float(經度), float(緯度)]
                },
                "properties": {
                    "城市": city_name,
                    "站名": station["站名"],
                    "地址": station["地址"],
                    "電話": station["電話"],
                    "營業時間": station["營業時間"],
                    "類型": station["類型"],
                    "98無鉛": station["98無鉛"],
                    "95Plus無鉛": station["95Plus無鉛"],
                    "92無鉛": station["92無鉛"],
                    "超級柴油": station["超級柴油"],
                    "洗車服務": station["洗車服務"],
                    "打氣機": station["打氣機"],
                    "車用尿素水": station["車用尿素水"],
                    "台塑石油PAY": station["台塑石油PAY"],
                    "帝雉卡儲值": station["帝雉卡儲值"],
                    "國旅卡": station["國旅卡"],
                    "悠遊卡": station["悠遊卡"],
                    "一卡通": station["一卡通"],
                    "愛金卡": station["愛金卡"],
                    "Pi拍錢包": station["Pi拍錢包"],
                    "街口支付": station["街口支付"],
                    "LINE Pay": station["LINE Pay"],
                    "悠遊付": station["悠遊付"]
                }
            }
            geojson["features"].append(feature)

    return geojson

# 主程式
if __name__ == "__main__":
    input_filename = "stations_data.json"
    output_filename = "stations_data_geojson.geojson"

    try:
        with open(input_filename, "r", encoding="utf-8") as f:
            all_data = json.load(f)
            print(f"成功讀取 {input_filename}")
    except FileNotFoundError:
        print(f"找不到檔案 {input_filename}")
        exit(1)

    # 轉換為 GeoJSON 格式
    geojson_data = convert_to_geojson(all_data)

    # 保存為 GeoJSON 檔案
    with open(output_filename, "w", encoding="utf-8") as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=4)

    print(f"GeoJSON 資料已保存至 {output_filename}")

    '''
    cities_set = set()  # 用於存放所有縣市的集合
    all_data = []

    base_url = "https://www.formosaoil.com.tw/j2tk/cus/sta/"
     # 根據 dc_srhtype_0 的值決定 action URL
    action_map = {
        "F": ["Cc1s01.do", "人工加油站據點"],
        "S": ["Cc1s02.do","自助加油站據點"],
        "T": ["Cc1s03.do","帝雉儲值卡據點"],
        "C": ["Cc1s04.do","車用尿素水據點"]
    }

    for key, action in action_map.items():
        full_url = f"{base_url}{action[0]}"
        # 提取城市資料
        cities = fetch_city_data(full_url)


        if cities:  # 確保有資料
            for city_dict in cities:  # 遍歷 fetch_city_data 返回的列表
                for city_name in city_dict.keys():  # 提取縣市名稱
                    cities_set.add(city_name)

    print(f'可選縣市: {cities_set}')
    # 遍歷所有縣市和站點類型，提取資料並合併
    for city_name in cities_set:
        city_data = {
            "城市": city_name,
            "站點資料": []
        }
        station_map = {}  # 用於合併相同站點的資料

        for key, value in action_map.items():
            full_url = f"{base_url}{value[0]}"
            print(f"正在處理 {value[1]}, {city_name} 的站點...")
            header_row, result_list = fetch_table_data(city_name, full_url, key)
            print(f"表頭: {header_row}, 表格資料: {result_list}")

            if header_row and result_list:
                for row in result_list:
                    station_data = {header_row[i]: row[i] for i in range(len(header_row))}
                    station_name = station_data["站名"]
                    address = station_data["地址"]

                    # 獲取經緯度
                    lat, lng = get_coordinates(address)
                    if lat and lng:
                        station_data["緯度"] = lat
                        station_data["經度"] = lng
                    else:
                        print(f"無法獲取地址 {address} 的經緯度")

                    # 如果站點已存在，合併資料
                    if station_name in station_map:
                        station_map[station_name]["類型"].append(value[1])
                    else:
                        # 新增站點資料
                        station_map[station_name] = station_data
                        station_map[station_name]["類型"] = [value[1]]

        # 將合併後的站點資料加入城市資料
        city_data["站點資料"] = list(station_map.values())
        all_data.append(city_data)
    # 保存所有資料為 JSON
    save_to_json(all_data, "stations_data.json")
    '''