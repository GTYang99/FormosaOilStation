# 台塑油價追蹤與 Firebase 整合專案 (FPCC Oil Price Tracker)

## 1. 專案開發生命週期 (SDLC)

- **1. 需求分析 (Requirement Analysis)**
  - 資料來源：台塑石化油價公告網頁 (https://www.fpcc.com.tw/tw/price)
  - 目標資料：各項油品 (92/95/98無鉛汽油、超級柴油) 最新價格與生效日期。
  - 儲存目標：Firebase (供行動 APP 讀取)。
  - 自動化：定時背景執行更新。

- **2. 系統設計 (System Design)**
  - 語言：Python 3.x
  - 核心套件：`requests`, `BeautifulSoup4` (網頁解析), `firebase-admin` (資料庫通訊)。
  - 資料結構：JSON 格式，包含更新時間與各項油價對應數值。

- **3. 實作與開發 (Implementation)**
  - Phase 3.1：開發爬蟲核心 (`scraper.py`)，確保能穩定解析目標網頁。
  - Phase 3.2：建立與設定 Firebase 專案，取得 Service Account 憑證。
  - Phase 3.3：整合爬蟲與 Firebase，完成資料上傳邏輯。

- **4. 測試 (Testing)**
  - 單元測試：針對網頁 DOM 節點進行防呆測試。
  - 整合測試：寫入 Firebase 測試區，確保資料格式正確且不影響線上運作。

- **5. 部署與維運 (Deployment & Maintenance)**
  - 部署：使用 Windows 工作排程器或雲端環境 (如 GitHub Actions) 設定定時任務。
  - 監控：加入 Error Logging 機制，在爬取失敗時發出通知。

---

## 2. Gemini AI 協作開發流程與守則 (AI Agentic Workflow & Rules)

為了確保 AI 助手與開發者能高效且安全地協作，本專案將遵循以下 Agentic AI 流程與守則：

### 🔄 標準協作流程 (Workflow)

1. **對齊與規劃 (Plan & Align)**：
   - 確認需求，並以本計畫書 (`plan.md`) 作為 **Single Source of Truth (單一真實來源)**。任何重大變更都會優先更新此文件。
2. **環境與上下文探索 (Context Discovery)**：
   - AI 在執行動作 (如修改程式碼) 前，必須先檢視現有資料夾結構與檔案內容，確保不破壞既有架構。
3. **迭代開發 (Iterative Execution)**：
   - 採用**小步開發 (Small Steps)**。每次只實作並驗證一個小模組（例如：先確保能抓到 HTML，再開發解析價格的邏輯）。
   - AI 會主動運用終端機指令 (Shell commands) 安裝套件與執行測試。
4. **驗證與回饋 (Verify & Feedback)**：
   - AI 寫完一段程式後會自動執行驗證。
   - 若遇到需要決策、需要外部資訊（例如 Firebase 憑證設定），AI 會暫停操作並向開發者 (User) 請求指示。
5. **紀錄與重構 (Document & Refactor)**：
   - 程式碼需包含適當註解。功能確認無誤後，將進度同步更新於計畫書中。

### 📜 AI 協作開發守則 (Rules)

- **Rule 1: 絕不盲目覆寫 (No Blind Overwrites)**
  - 在修改任何現有程式碼之前，AI 必須先讀取檔案，並使用精確替換工具 (Replace/Edit) 而非整檔覆蓋。
- **Rule 2: 本地端獨立驗證 (Self-Verification)**
  - AI 應盡可能在背景執行腳本來自我驗證，確認執行輸出符合預期後，再回報給使用者。
- **Rule 3: 資安至上 (Security First)**
  - 遇到如 Firebase 金鑰、API Keys 等機密資訊時，**絕對禁止**將機密寫死 (Hardcode) 在程式碼中。AI 會引導使用者將其設定為環境變數或獨立的 `.env` 檔案並加入 `.gitignore`。
- **Rule 4: 透明溝通 (Transparent Communication)**
  - 遇到套件衝突或網站改版導致抓取失敗時，AI 必須誠實回報錯誤 Logs，並提出可行的解決方案供使用者選擇。
