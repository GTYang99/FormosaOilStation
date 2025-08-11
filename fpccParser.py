from ast import literal_eval
from re import I
import requests
import json
from bs4 import BeautifulSoup
from dotenv import load_dotenv
import os

load_dotenv()  # 讀取 .env 檔案


def make_request(url) -> BeautifulSoup:
    """
    提取縣市資料
    """
    # 先發送 GET 請求來獲取頁面內容，有些會有防火牆擋攻擊
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3.1 Safari/605.1.15" 
        , "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        , "Accept-Encoding": "gzip, deflate, br"
        , "Accept-Language": "zh-TW,zh-Hant;q=0.9"
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    return soup

def fetch_select_data(soup: BeautifulSoup) -> (dict, dict, dict):

    scity = fetch_select_options(soup, "scity")
    sservice = fetch_select_options(soup, "sservice")
    scard = fetch_select_options(soup, "scard")

    return scity, sservice, scard


def fetch_select_options(soup, select_name):

    select = soup.find("select", {"name": select_name})
    if not select:
        print(f"找不到 select: {select_name}")
        return []

    dict = {}
    for option in select.find_all("option"):
        item = {option.get("value", "").strip(): option.text.strip()}
        dict.update(item)

    return dict
    #return {"value": option.get("value", "").strip(), "text": option.text.strip()} for option in select.find_all("option")
    
def fetch_locator(soup: BeautifulSoup) -> list:
    items = soup.find_all('li', class_='li-item')
    # 建立結果列表
    stations = []

    for item in items:
        name = item.find('h2').text.strip()
        ps = item.find_all('p')
        address = ps[0].text.strip() if len(ps) > 0 else ''
        phone = ps[1].text.strip() if len(ps) > 1 else ''
        coords = item.get('data-id', '').strip()
        lat, lon = coords.split(",")
        station = {
            'name': name,
            'address': address,
            'phone': phone,
            'latitude': lat,
            'longitude': lon
        }
        stations.append(station)

    return stations


def fetch_table_data(soup: BeautifulSoup):
    table = soup.find('div', class_='locator-list')
    if not table:
        return []

    stations_raw = soup.find_all('li', class_='reload-content')[1:]

    stations = []

    for station in stations_raw:
        data = {}
        divs = station.find_all('div')

        for div in divs:
            key = div.get('data-title')
            if not key:
                continue

            # 取得所有 <p> 的內容
            ps = div.find_all('p')
            values = [p.text.strip() for p in ps if p.text.strip()]

            # 判斷是單一欄位還是服務項目
            if key in ['站名', '地址', '電話', '營業時間']:
                data[key] = values[0] if values else ''
            else:
                # ◯ 表示有提供，╳ 表示無提供
                data[key] = '◯' in values

        stations.append(data)
    
    
    return stations


def convert_to_geojson(data: list, loactor: list):
    """
    將站點資料轉換為 GeoJSON 格式
    """
    geojson = {
        "type": "FeatureCollection",
        "features": []
    }

    for city_data in data:
        station_name = city_data["站名"]
        result = next((s for s in loactor if s['name'] == station_name), None)
        lat = 0.0
        lon = 0.0
        
        if result:
            lat = result['latitude']
            lon = result['longitude']
            print(f"{station_name} → Latitude: {lat}, Longitude: {lon}")
        else:
            print("找不到該站名")

        feature = {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [float(lon), float(lat)]
            },
            "properties": {
                "站名": city_data["站名"],
                "地址": city_data["地址"],
                "電話": city_data["電話"],
                "營業時間": city_data["營業時間"],
                # "98無鉛": city_data["98無鉛汽油"],
                # "95Plus無鉛": city_data["95+無鉛汽油"],
                # "92無鉛": city_data["92無鉛汽油"],
                "98無鉛": city_data.get("98無鉛") or city_data.get("98無鉛汽油"),
                "95Plus無鉛": city_data.get("95Plus無鉛") or city_data.get("95+無鉛汽油"),
                "92無鉛": city_data.get("92無鉛") or city_data.get("92無鉛汽油"),
                "超級柴油": city_data["超級柴油"],
                "自助加油設備": city_data["自助加油設備"],
                "不斷電加油服務": city_data["不斷電加油服務"],
                "台塑石油APP": city_data["台塑石油APP"],
                "台塑聯名卡": city_data["台塑聯名卡"],
                "台塑商務卡": city_data["台塑商務卡"],
                "國民旅遊卡": city_data["國民旅遊卡"],
                "Taxi卡": city_data["Taxi卡"]
            }
        }
        geojson["features"].append(feature)

    return geojson

def save_to_json(data, filename):
    """
    將資料保存為 JSON 檔案
    """
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    print(f"資料已保存至 {filename}")



def open_from_json(filename):
    with open(filename, "r", encoding="utf-8") as f:
        return json.load(f) 

def get_place_id(geojson: dict, api_key: str):
    """
    依據 geojson 結構，對每個加油站地址查詢 Google Maps Geocoding API，取得 place_id。
    回傳格式: 塞回原本的 geojson 中
    """
    results = {
        "type": "FeatureCollection",
        "features": []
    }
    for index, feature in enumerate(geojson.get("features", [])):
        props = feature.get("properties", {})
        name = props.get("站名", "")
        address = props.get("地址", "")
        if not address:
            # results.append({"站名": name, "地址": address, "place_id": None})
            props['place_id'] = None
            continue
        # 組成 components 參數
        components = f"country:TW|address:{address}"
        url = f"https://maps.googleapis.com/maps/api/geocode/json?components={components}&key={api_key}"
        try:
            response = requests.get(url)
            data = response.json()
            if data.get("status") == "OK" and data.get("results"):
                place_id = data["results"][0]["place_id"]
            else:
                place_id = None
        except Exception as e:
            place_id = None
        # results.append({"站名": name, "地址": address, "place_id": place_id})
        props['place_id'] = place_id
        feature = geojson["features"][index]
        feature["properties"] = props
        results["features"].append(feature)
    return results


def main():

    key_path = os.getenv("GEOCODING_KEY")
    # print(f"🔑 Test key path: {key_path}")

    
    url = "https://www.fpcc.com.tw/tw/events/stations/"
    soup =  make_request(url)
    city_list, service_list, card_list = fetch_select_data(soup)
    station_citys = []
    table_citys = []

    # table = fetch_table_data(soup)
    # print(f"table:{table}")

    
    for city, _ in city_list.items():
        temp_url = f"{url}{city}"
        soup_city =  make_request(temp_url)
        station = fetch_locator(soup_city)
        station_citys += station
        table = fetch_table_data(soup_city)
        table_citys += table
    
    # print(f'station_citys:{station_citys}')

    file = convert_to_geojson(table_citys, station_citys)
    # print(f'Stations:{file}')
    save_to_json(file, "fpccOilStation.geojson")

    # geojson = open_from_json("fpccOilStation.geojson")
    newGeoJSON = get_place_id(file, 'key_path')
    # print(f"geojson:{newGeoJSON}")
    save_to_json(newGeoJSON, "fpccOilStation_place_id.geojson")

    # print(f'Stations:{station_citys}')

if __name__ == "__main__":
    main()