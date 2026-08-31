# Requirement: 第一階段 - 爬取台塑油價 (Phase 1)

## 目標 (Goal)
撰寫一個 Python 爬蟲腳本，從台塑石化官方網站提取最新的油價資訊。

## 範圍 (Scope)
- **資料來源**: https://www.fpcc.com.tw/tw/price
- **目標欄位**: 
  - 價格生效日期
  - 92 無鉛汽油價格
  - 95 無鉛汽油價格
  - 98 無鉛汽油價格
  - 超級柴油價格
- **輸出格式**: 終端機印出 Python Dictionary 或 JSON 格式。

## 排除範圍 (Out of Scope)
- 暫不串接 Firebase (這將是第二階段任務)。
- 暫不設定系統排程 (這將是最終發布任務)。
