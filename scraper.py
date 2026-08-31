# -*- coding: utf-8 -*-
from curl_cffi import requests
from bs4 import BeautifulSoup
import json
import re
import sys

# 強制輸出為 UTF-8
sys.stdout.reconfigure(encoding='utf-8')

def get_fpcc_oil_price():
    url = "https://www.fpcc.com.tw/tw/price"
    
    # 關鍵：使用 curl_cffi 模擬真實 Chrome 瀏覽器的 TLS 特徵
    response = requests.get(url, impersonate="chrome110", timeout=15)
    response.raise_for_status()
    
    # 解析 HTML
    soup = BeautifulSoup(response.content, 'html.parser')
    
    target_block = None
    for block in soup.find_all('div', class_='price-block'):
        h3 = block.find('h3')
        if h3 and '加盟加油站' in h3.text:
            target_block = block
            break
            
    if not target_block:
        raise ValueError("無法找到 '加盟加油站' 區塊。這可能意味著仍被 WAF 阻擋，或網頁結構已改變。")
        
    date_str = ""
    for p_tag in target_block.find_all('p'):
        if '實施日期' in p_tag.text:
            match = re.search(r'實施日期：西元\s*(.*起)', p_tag.text)
            if match:
                date_str = match.group(1).strip()
            break
            
    prices = {}
    for gps in target_block.find_all('div', class_='gps'):
        price_val = gps.find('h2').text.replace('$', '').strip()
        oil_type = gps.find('p').text.replace('\n', '').strip()
        prices[oil_type] = float(price_val)
        
    result = {
        "update_date": date_str,
        "prices": prices
    }
    return result

if __name__ == "__main__":
    try:
        data = get_fpcc_oil_price()
        print(json.dumps(data, ensure_ascii=False, indent=2))
    except Exception as e:
        print(f"Error: {e}")
