## 🚀 Project: **Expat Helper AI**

**Goal:** A multilingual Rails-based AI assistant that helps foreigners in Japan with everyday questions (immigration, health insurance, taxes, local services) .A Rails app for expats in Japan: upload official documents (bills, city hall notices, immigration letters) → AI extracts key info, classifies it, explains in plain English, and highlights urgency + next steps. Optional: syncs deadlines into Google Calendar.

**Stack:** Ruby on Rails 7, PostgreSQL + pgvector, Hotwire (Turbo + Stimulus), Tailwind, OpenAI API, Langchain.rb.

---

## 🗓️ 14-Day Roadmap (MVP Phase)

---

### **WEEK 1 — Core Structure + AI Foundations**

---

### 🧩 **Day 1: Setup & Scaffolding**

- Initialize Rails 7 app (`rails new expat_helper_ai --css=tailwind`)
- Configure Postgres & environment variables
- Add gems:
    
    ```ruby
    gem "ruby-openai"
    gem "langchainrb"
    gem "pgvector"
    gem "devise"
    gem "hotwire-rails"
    
    ```
    
- Setup GitHub repo, `.env`, and README with project description

✅ **Deliverable:** Base app running locally, connected to database.

---

### 💬 **Day 2: Authentication + Basic UI**

- Add `User` model via Devise
- Simple navbar: Home / Chat / About
- Implement Tailwind layout
- Add language switcher dropdown (English, 日本語, नेपाली)

✅ **Deliverable:** Working auth + multilingual layout.

---

### 🧠 **Day 3: AI Chat Interface (Hotwire)**

- Create `ChatController` and `ChatMessage` model
- Use Turbo Streams to append messages dynamically
- Create Stimulus controller for auto-scroll
- Basic AI response integration (OpenAI completion API)

✅ **Deliverable:** Real-time AI chat working end-to-end.

---

### 📚 **Day 4: Knowledge Base Model**

- Add `Document` and `Chunk` models
- Enable ActiveStorage for uploading PDF/TXT files
- Parse uploads into small “chunks” (~300 tokens each)
- Generate embeddings for each chunk and store in pgvector column

✅ **Deliverable:** Admin can upload docs, embeddings stored in DB.

---

### ⚙️ **Day 5: Context Retrieval (RAG)**

- Create a service `AiAnswerService`
- Implement vector similarity search to find relevant chunks
- Merge context with user query → send to GPT
- Display contextual answers in chat interface

✅ **Deliverable:** Context-aware AI replies from uploaded data.

---

### 🌍 **Day 6: Multilingual Support**

- Integrate OpenAI translation for user queries
- Let user select interface language (i18n + dropdown)
- AI replies in selected language
- Add localization for nav, buttons, labels

✅ **Deliverable:** Multilingual chat fully working.

---

### 🧪 **Day 7: Testing + Seed Data**

- Add 2–3 example docs (e.g., “Residency Guide.pdf”, “Health Insurance.pdf”)
- Test context retrieval (ask: “How to renew residence card?”)
- Write initial RSpec tests for AiAnswerService
- Push to GitHub with clean commits and demo video (optional)

✅ **Deliverable:** Week 1 MVP completed 🎯

---

### **WEEK 2 — UX, Insights & Community Layer**

---

### 📈 **Day 8: Dashboard & Analytics**

- Create `Admin::DashboardController`
- Display usage stats: number of questions, top queries
- Simple charts using Chartkick
- Store question + AI response in DB for tracking

✅ **Deliverable:** Analytics dashboard for insights.

---

### 💬 **Day 9: FAQ & Quick Prompts**

- Add sidebar of “Popular Questions” (seeded from usage logs)
- Allow one-click insert into chat input
- Add “regenerate answer” button via Stimulus

✅ **Deliverable:** Better UX & interaction flow.

---

### 🗂️ **Day 10: Community Knowledge Base (Optional but Valuable)**

- Add `CommunityTip` model (title, content, user_id)
- Allow logged-in users to share helpful info (“How I renewed my visa in Saitama”)
- AI can cite community tips in answers

✅ **Deliverable:** Adds social/community impact dimension.

---

### 🎨 **Day 11: UI/UX Polish**

- Chat bubbles with Tailwind
- Add icons for AI vs. User messages
- Responsive layout for mobile
- Add loading animation while AI is “thinking”
- Add light/dark mode toggle

✅ **Deliverable:** Polished, demo-ready UI.

---

### 🔍 **Day 12: API Integration (Optional)**

- Integrate Google Maps API for local search (e.g., “nearest ward office”)
- Integrate Add to Calendar Button to set the payment date or paypay
- Optional: Add button for “Find on Map”

✅ **Deliverable:** Adds business + data depth (if time allows).