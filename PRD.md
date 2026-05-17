# Product Requirements Document (PRD)
## JapanBuddy AI

| Field | Value |
|-------|-------|
| **Product Name** | JapanBuddy AI |
| **Version** | 1.0 |
| **Document Status** | Active |
| **Last Updated** | 2026-05-17 |
| **Owner** | Mandil Khadka ([@mandilkhadka](https://github.com/mandilkhadka)) |
| **Repository** | https://github.com/mandilkhadka/JapanBuddy-Ai |
| **License** | MIT |

---

## 1. Executive Summary

JapanBuddy AI is a multilingual, AI-powered web assistant that helps foreign residents (expats) navigate everyday life in Japan. The product answers questions about visas, taxes, health insurance, and daily-life procedures in **English, Japanese (日本語), and Nepali (नेपाली)** through a real-time chat interface backed by Retrieval Augmented Generation (RAG) over user-uploaded official documents.

**Tagline:** *Your friendly AI assistant for navigating life in Japan.*

---

## 2. Problem Statement

Foreign residents in Japan face significant friction when dealing with bureaucratic, legal, and daily-life procedures:

- Official documents are predominantly in Japanese and use specialized terminology.
- Information is fragmented across municipal offices, immigration bureaus, tax offices, and pension agencies.
- Existing translation tools lack domain context and cannot reason over a user's own documents.
- Generic chatbots hallucinate on Japan-specific legal/administrative facts.
- Non-English-speaking expats (e.g., Nepali-speakers) are particularly underserved.

**JapanBuddy AI solves this** by combining domain-focused AI chat with personal-document RAG, delivered in the user's native language.

---

## 3. Goals & Non-Goals

### 3.1 Goals
1. Deliver accurate, context-aware answers to Japan-life questions in EN / JA / NE.
2. Let users upload their own official documents and receive plain-language explanations grounded in those documents.
3. Provide a fast, responsive, mobile-friendly chat experience with real-time streaming updates.
4. Cover the four highest-friction topic areas: **Immigration & Visas, Health Insurance, Taxes & Pension, Daily Life**.
5. Preserve conversation history so users can return to past answers.

### 3.2 Non-Goals (v1.0)
- Providing legally binding advice (the product is informational; users are directed to professionals for legal decisions).
- Replacing human translators, immigration lawyers, or tax advisors.
- Native mobile apps (roadmap item — v2).
- Community/social features (roadmap item — v2).
- Real-time admin analytics (roadmap item — v2).

---

## 4. Target Users & Personas

### Persona 1 — "Newly Arrived Worker"
- Recently moved to Japan on a work visa.
- Limited Japanese reading ability.
- Needs: residence card procedures, health insurance enrollment, opening a bank account.

### Persona 2 — "Long-term Resident"
- Has lived in Japan 3+ years.
- Functional Japanese but struggles with bureaucratic kanji.
- Needs: visa renewals/changes, year-end tax adjustments (年末調整), filing taxes.

### Persona 3 — "Leaving Japan"
- Returning home after working in Japan.
- Needs: pension lump-sum withdrawal (脱退一時金), final tax filing, closing accounts.

### Persona 4 — "Nepali Expat"
- Native Nepali speaker; English is a second language.
- Wants information directly in Nepali to avoid double-translation loss.

---

## 5. User Stories

### 5.1 Authentication & Onboarding
- As a **visitor**, I can land on the home page and read about the product in EN / JA / NE.
- As a **visitor**, I can switch the UI language instantly via a dropdown without reloading.
- As a **visitor**, I can sign up for a free account via email/password.
- As a **returning user**, I can sign in and see a "Welcome back!" greeting in my chosen language.

### 5.2 AI Chat
- As a **user**, I can start a new conversation from the chat page.
- As a **user**, I can pick a quick-suggestion prompt to get started fast.
- As a **user**, I can type a question in EN / JA / NE and receive a streamed AI response in real time.
- As a **user**, I see a "Thinking…" indicator while the model is working.
- As a **user**, I can scroll back through prior messages within a conversation.
- As a **user**, I can view a list of all my past conversations and reopen any of them.

### 5.3 Document Upload & RAG
- As a **user**, I can upload PDF or TXT files (e.g., my residence card paperwork, tax forms).
- As a **user**, I can see the processing status of each document (Processing → Ready).
- As a **user**, I can ask questions and have the AI answer using my uploaded documents as context.
- As a **user**, I can see which documents are in my personal knowledge base.

### 5.4 Preferences
- As a **user**, I can toggle between light and dark mode.
- As a **user**, I can switch languages at any time and have the entire UI re-localize.
- As a **user**, I can sign out and see a localized farewell message.

---

## 6. Feature Specification (0 → 100)

### 6.1 AI-Powered Chat
| ID | Feature | Description | Priority |
|----|---------|-------------|----------|
| F-CHAT-01 | Multilingual input | Accept and understand questions in English, Japanese, or Nepali. | P0 |
| F-CHAT-02 | Multilingual output | Respond in the language of the user's question (or UI locale). | P0 |
| F-CHAT-03 | RAG context | Retrieve relevant chunks from user documents before generating each answer. | P0 |
| F-CHAT-04 | Real-time streaming | Stream the assistant's response token-by-token via Hotwire Turbo Streams. | P0 |
| F-CHAT-05 | Quick suggestions | Four prefilled prompts on the empty-chat state, localized per language. | P0 |
| F-CHAT-06 | Conversation list | Sidebar/page listing all conversations belonging to the signed-in user. | P0 |
| F-CHAT-07 | Conversation history | Persist every user/assistant message; reopenable later. | P0 |
| F-CHAT-08 | "Thinking…" indicator | Animated indicator while awaiting model output. | P1 |
| F-CHAT-09 | Empty state greeting | "Hello! I'm JapanBuddy" localized per language. | P1 |

**Quick-Suggestion Prompts (must ship in v1.0):**
| English | 日本語 | नेपाली |
|---------|--------|--------|
| How do I renew my residence card? | 在留カードの更新方法は？ | निवास कार्ड कसरी नवीकरण गर्ने? |
| Explain Japanese health insurance | 日本の健康保険について教えて | जापानको स्वास्थ्य बीमा बारे बताउनुहोस् |
| What taxes do foreigners pay? | 外国人の税金について | विदेशीहरूले कति कर तिर्नुपर्छ? |
| How to open a bank account? | 銀行口座の開設方法は？ | बैंक खाता कसरी खोल्ने? |

### 6.2 Document Analysis
| ID | Feature | Description | Priority |
|----|---------|-------------|----------|
| F-DOC-01 | Upload (PDF) | Accept PDF uploads via ActiveStorage. | P0 |
| F-DOC-02 | Upload (TXT) | Accept plain-text uploads. | P0 |
| F-DOC-03 | Chunking | Split documents into semantic chunks suitable for embedding. | P0 |
| F-DOC-04 | Embedding | Generate vector embeddings (OpenAI `text-embedding-ada-002`) and store in pgvector. | P0 |
| F-DOC-05 | Status display | Show "Processing" / "Ready" state per document. | P0 |
| F-DOC-06 | Document list | Show all documents belonging to the user with timestamps. | P0 |
| F-DOC-07 | Plain-language explanation | When asked, AI summarizes complex Japanese documents in plain language. | P0 |
| F-DOC-08 | Personal knowledge base | Per-user scoping — a user's documents only influence their own conversations. | P0 |
| F-DOC-09 | Upload & Analyze CTA | Single-click flow to upload and trigger processing. | P1 |

### 6.3 Topic Coverage (Knowledge Domains)
The AI must be tuned/prompted to handle, at minimum, the following domains:

1. **Immigration & Visas** — residence card renewals, visa status changes (e.g., engineer/specialist in humanities → permanent residency), work permits, re-entry permits.
2. **Health Insurance** — National Health Insurance (国民健康保険 / NHI), Shakai Hoken (社会保険), choosing hospitals, foreign insurance acceptance.
3. **Taxes & Pension** — 確定申告 (tax filing), 年末調整 (nenmatsu chosei / year-end adjustment), 脱退一時金 (pension lump-sum refund for those leaving Japan).
4. **Daily Life** — utilities setup (gas/electric/water), bank account opening, city hall (市役所) procedures, residence registration (住民登録).

### 6.4 User Experience
| ID | Feature | Description | Priority |
|----|---------|-------------|----------|
| F-UX-01 | Responsive design | Mobile-first; usable from 360px width to desktop. | P0 |
| F-UX-02 | Dark mode | Toggle between light and dark themes; persisted per browser. | P0 |
| F-UX-03 | Language switcher | Dropdown in nav; switches locale instantly without page reload. | P0 |
| F-UX-04 | Conversation history access | Always one click away from the chat view. | P0 |
| F-UX-05 | Modern landing page | Hero, feature cards, CTA to sign up / start chat. | P0 |
| F-UX-06 | Localized errors | "Something went wrong" surfaces in user's language. | P1 |

### 6.5 Internationalization (i18n)
- Three locale files maintained under `config/locales/`:
  - `en.yml` (English)
  - `ja.yml` (日本語)
  - `ne.yml` (नेपाली)
- All user-facing strings (nav, buttons, headings, errors, empty states, greetings) must be keyed and translated in all three locales — **no hardcoded copy in views**.
- Adding a new language must be possible by dropping a new YAML file and registering the locale in app config.

### 6.6 Authentication
- Built on **Devise**.
- Email/password sign-up and sign-in.
- Localized auth-flow copy: "Sign In / ログイン / लग इन", "Sign Up / 無料で始める / निःशुल्क सुरु गर्नुहोस्", "Sign Out / ログアウト / लग आउट".
- Localized session messages: "Welcome back! / おかえりなさい！/ फेरि स्वागत छ!" and "See you next time! / またのご利用をお待ちしています！/ फेरि भेटौंला!".

---

## 7. Detailed UI / Copy Specification

### 7.1 Navigation
| Element | EN | JA | NE |
|--------|----|----|----|
| Home | Home | ホーム | गृहपृष्ठ |
| Chat | Chat | チャット | च्याट |
| Documents | Documents | 書類 | कागजातहरू |
| Sign In | Sign In | ログイン | लग इन |
| Sign Up | Sign Up | 無料で始める | निःशुल्क सुरु गर्नुहोस् |
| Sign Out | Sign Out | ログアウト | लग आउट |
| Language | Language | 言語 | भाषा |
| Menu | Menu | メニュー | मेनु |

### 7.2 Home Page
| Element | EN | JA | NE |
|--------|----|----|----|
| Hero Headline | Navigate Japan with Confidence | 日本での生活、もう迷わない | जापानमा जीवन अब सजिलो |
| Subhead | AI-Powered Assistant | AI搭載アシスタント | AI सहायक |
| Primary CTA | Start Chatting | チャットを始める | च्याट सुरु गर्नुहोस् |
| Secondary CTA | Learn More | 詳しく見る | कसरी काम गर्छ हेर्नुहोस् |

### 7.3 Feature Cards (Home)
| Card | EN | JA | NE |
|------|----|----|----|
| Immigration | Immigration & Visas | 在留資格・ビザ | भिसा र निवास |
| Health | Health Insurance | 健康保険 | स्वास्थ्य बीमा |
| Taxes | Taxes & Finances | 税金・年金 | कर र पेन्सन |
| Documents | Document Help | 書類サポート | कागजात मद्दत |

### 7.4 Chat Interface
| Element | EN | JA | NE |
|---------|----|----|----|
| New chat button | New Chat | 新規チャット | नयाँ च्याट |
| History header | Your Conversations | チャット履歴 | च्याट इतिहास |
| Send button | Send | 送信 | पठाउनुहोस् |
| Loading state | Thinking... | 考え中... | सोचिरहेको छ... |
| Empty state greeting | Hello! I'm JapanBuddy | こんにちは！JapanBuddyです | नमस्ते! म JapanBuddy हुँ |

### 7.5 Documents Page
| Element | EN | JA | NE |
|---------|----|----|----|
| Page header | Your Documents | アップロードした書類 | मेरा कागजातहरू |
| Upload button | Upload Document | 書類をアップロード | कागजात अपलोड |
| Status (in-progress) | Processing | 処理中 | प्रक्रियामा |
| Status (done) | Ready | 完了 | तयार |
| Primary CTA | Upload & Analyze | アップロードして分析 | अपलोड गरी विश्लेषण गर्नुहोस् |

### 7.6 Common / Error Copy
| Element | EN | JA | NE |
|---------|----|----|----|
| Welcome back | Welcome back! | おかえりなさい！ | फेरि स्वागत छ! |
| Farewell | See you next time! | またのご利用をお待ちしています！ | फेरि भेटौंला! |
| Generic error | Something went wrong | エラーが発生しました | केही समस्या भयो |
| Auth required | Please sign in | ログインしてください | कृपया लग इन गर्नुहोस् |

### 7.7 Example Use Cases (for marketing / docs)
| Use Case | EN | JA | NE |
|----------|----|----|----|
| Visa | "How do I extend my work visa?" | "就労ビザの延長方法は？" | "मेरो कार्य भिसा कसरी विस्तार गर्ने?" |
| Health | "Which hospital accepts foreign insurance?" | "外国の保険が使える病院は？" | "कुन अस्पताल विदेशी बीमा स्वीकार्छ?" |
| Tax | "When is the tax filing deadline?" | "確定申告の締切はいつ？" | "कर फाइलिङको अन्तिम मिति कहिले हो?" |

---

## 8. Technical Architecture

### 8.1 Tech Stack
| Layer | Technology |
|-------|------------|
| Web framework | Ruby on Rails 7.1 |
| Language | Ruby 3.2+ |
| Database | PostgreSQL 15+ with **pgvector** extension |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS |
| AI / ML | OpenAI API, Langchain.rb |
| Auth | Devise |
| File storage | ActiveStorage |
| JS runtime (build) | Node.js 18+ / Yarn |

### 8.2 External APIs
- **OpenAI Chat Completions** — GPT-4 for response generation.
- **OpenAI Embeddings** — `text-embedding-ada-002` for document vectors.

### 8.3 RAG Pipeline
1. User submits a question.
2. Question text → embedding vector via OpenAI Embeddings.
3. Vector similarity search in pgvector against the user's `chunks` table.
4. Top-K relevant chunks + the question are assembled into a prompt.
5. Prompt is sent to GPT-4.
6. Generated response is streamed back to the browser via Turbo Streams and persisted as a `chat_message`.

### 8.4 Domain Model (high level)
| Model | Purpose |
|-------|---------|
| `User` | Devise-backed authentication; owns conversations and documents. |
| `Conversation` | A chat thread belonging to a user. |
| `ChatMessage` | An individual user or assistant message inside a conversation. |
| `Document` | An uploaded PDF/TXT file (ActiveStorage attachment). |
| `Chunk` | A piece of a document with its embedding vector (pgvector). |

### 8.5 Service Layer
| Service | Responsibility |
|---------|----------------|
| `AiAnswerService` | Orchestrates RAG: embed query, retrieve chunks, call GPT-4, return response. |
| `EmbeddingService` | Wraps OpenAI embedding calls. |
| `DocumentProcessorService` | Parses uploads (PDF/TXT), chunks content, persists `Chunk` rows. |

### 8.6 Controllers
| Controller | Responsibility |
|------------|----------------|
| `ConversationsController` | CRUD for chat conversations. |
| `ChatMessagesController` | Receive user messages, dispatch to `AiAnswerService`, broadcast updates. |
| `DocumentsController` | Document upload, listing, processing status. |
| `PagesController` | Static / marketing pages (home). |

### 8.7 JavaScript Controllers (Stimulus)
| Controller | Responsibility |
|------------|----------------|
| `chat_controller.js` | Chat input UX, auto-scroll, submission. |
| `dropdown_controller.js` | Navigation dropdowns (language, account). |
| `theme_controller.js` | Light/dark mode toggle + persistence. |

### 8.8 Project Structure (canonical)
```
app/
├── controllers/
│   ├── conversations_controller.rb
│   ├── chat_messages_controller.rb
│   ├── documents_controller.rb
│   └── pages_controller.rb
├── models/
│   ├── user.rb
│   ├── conversation.rb
│   ├── chat_message.rb
│   ├── document.rb
│   └── chunk.rb
├── services/
│   ├── ai_answer_service.rb
│   ├── embedding_service.rb
│   └── document_processor_service.rb
├── javascript/controllers/
│   ├── chat_controller.js
│   ├── dropdown_controller.js
│   └── theme_controller.js
└── views/
    ├── pages/home.html.erb
    ├── conversations/
    └── documents/
```

---

## 9. Setup & Environment Requirements

### 9.1 Prerequisites
- Ruby 3.2+
- PostgreSQL 15+ with the `pgvector` extension installed
- Node.js 18+
- A valid OpenAI API key

### 9.2 Environment Variables
| Var | Purpose |
|-----|---------|
| `OPENAI_API_KEY` | Auth for OpenAI Chat + Embeddings. |
| `DATABASE_URL` | e.g. `postgres://localhost/japanbuddy_development`. |

### 9.3 Bring-up Sequence
```bash
git clone https://github.com/mandilkhadka/JapanBuddy-Ai.git
cd JapanBuddy-Ai
bundle install
yarn install
cp .env.example .env        # then fill in keys
rails db:create
rails db:migrate
rails db:seed
bin/dev                     # http://localhost:3000
```

---

## 10. Acceptance Criteria (Definition of Done for v1.0)

A v1.0 build is considered **shippable** when **all** of the following are true:

### 10.1 Functional
- [ ] User can sign up, sign in, and sign out (Devise).
- [ ] User can switch between EN / JA / NE without page reload, and every visible string updates.
- [ ] User can toggle between light and dark mode, and the choice persists.
- [ ] User can start a new conversation from the chat page.
- [ ] User sees four localized quick-suggestion prompts on an empty conversation.
- [ ] User can send a message and receive a streamed AI response (Turbo Streams).
- [ ] User sees a "Thinking…" (localized) indicator while waiting.
- [ ] User can view a list of all previous conversations and reopen any.
- [ ] User can upload a PDF or TXT document.
- [ ] Each document shows a Processing → Ready status transition.
- [ ] Documents are chunked, embedded, and stored in pgvector.
- [ ] When the user asks a question, the AI retrieves relevant chunks from the user's own documents before answering.
- [ ] All four topic domains (Immigration, Health, Taxes/Pension, Daily Life) return on-topic answers to the sample prompts in §7.7.

### 10.2 Non-Functional
- [ ] Mobile layout works at 360px width without horizontal scroll.
- [ ] No hardcoded user-facing strings in views — every string flows through `I18n.t`.
- [ ] All three locale YAMLs have the same key coverage (no missing translations).
- [ ] Dark mode passes basic contrast checks on all primary surfaces.
- [ ] OpenAI key is read from env; never committed.
- [ ] Document chunks are scoped per-user — no cross-user leakage in retrieval.

### 10.3 Screenshots / Docs
- [ ] Home page, chat interface, documents page, and mobile view screenshots exist under `docs/screenshots/` and are referenced in README.

---

## 11. Success Metrics (post-launch)

| Metric | Target |
|--------|--------|
| Weekly active users (WAU) | Trending up week-over-week in first 90 days |
| Average questions per user per week | ≥ 3 |
| Documents uploaded per active user | ≥ 1 within first session |
| Response satisfaction (thumbs-up rate, if added) | ≥ 75% |
| Language distribution | Real usage from all three locales (EN/JA/NE > 0) |
| P95 first-token latency | < 3s on warm OpenAI path |

---

## 12. Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| LLM hallucination on legal/tax facts | RAG over user-uploaded official docs; add disclaimer copy directing users to professionals. |
| OpenAI cost spikes | Track tokens per user; consider rate limiting per account in v1.x. |
| PDF parsing variance (scanned vs. native) | v1.0: native PDFs only; OCR is a v2 roadmap item. |
| pgvector performance at scale | Index `chunks.embedding`; chunk size tuned during processing. |
| Translation quality (especially NE) | Native-speaker review of YAML files before launch; community contributions accepted via PR. |
| Cross-user data leakage in retrieval | All retrieval queries must filter `chunks` by `user_id`; covered by integration tests. |

---

## 13. Roadmap

### Shipped in v1.0
- [x] Core AI chat functionality
- [x] Document upload and processing
- [x] RAG-powered responses
- [x] Multilingual support (EN / JA / NE)
- [x] Dark / light mode
- [x] Responsive design

### Planned (post-v1.0)
- [ ] **Google Calendar integration** — push visa, tax, and renewal deadlines to the user's calendar.
- [ ] **Community tips sharing** — opt-in, moderated user-submitted tips per topic.
- [ ] **Admin analytics dashboard** — usage, top questions, error rates, cost.
- [ ] **Mobile app (React Native)** — native iOS/Android clients on the same Rails backend.
- [ ] **OCR pipeline** — scanned PDFs and photo uploads.
- [ ] **Additional locales** — Vietnamese, Tagalog, Indonesian (largest expat populations in Japan).

---

## 14. Out of Scope (v1.0)

- Legally binding advice or signed legal documents.
- Direct integrations with Japanese government APIs (e.g., MyNumber portal).
- Voice input / audio replies.
- Payments / paid tiers.
- Multi-user / team accounts.

---

## 15. Contribution Workflow

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/AmazingFeature`.
3. Commit changes (project convention: emoji-prefixed Japanese commit messages, e.g. `✨ AIチャット機能を追加`).
4. Push the branch: `git push origin feature/AmazingFeature`.
5. Open a Pull Request against `master`.

---

## 16. Open Questions

1. Should anonymous (signed-out) users get a limited free-trial chat? (Currently: no — sign-in required.)
2. Do we want per-conversation document scoping (attach docs to a single chat), or only the current global per-user knowledge base?
3. Will we expose a public API for third-party integrations in v2?
4. Do we add a "report inaccurate answer" feedback button in v1.0 to seed the satisfaction metric, or defer to v1.1?

---

## 17. Glossary

| Term | Meaning |
|------|--------|
| **RAG** | Retrieval Augmented Generation — retrieving relevant context and giving it to an LLM at inference time. |
| **pgvector** | PostgreSQL extension that adds a `vector` column type and similarity-search operators. |
| **Hotwire / Turbo Streams** | Rails real-time UI updates over websockets without a heavy JS framework. |
| **Devise** | Standard Rails authentication gem. |
| **Shakai Hoken (社会保険)** | Japan's employer-based social insurance (health + pension). |
| **NHI (国民健康保険)** | Japan's National Health Insurance, for those not on Shakai Hoken. |
| **Nenmatsu Chosei (年末調整)** | Japan's year-end tax adjustment done by employers. |
| **Dattai Ichijikin (脱退一時金)** | Lump-sum pension refund for foreigners leaving Japan. |

---

*Acknowledgments: Built for expats navigating life in Japan. Powered by OpenAI's GPT-4 and embedding models. UI inspired by modern SaaS applications.*
