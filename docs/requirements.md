# Digital Ombuds MVP Requirements Document  
**Version 1.0 — December 2025**  
**Author:** Sonja Chen  

A secure, encrypted visitor–ombuds messaging platform consisting of a mobile app (visitor-facing), a desktop app (ombuds-facing), and a backend system using Supabase.

---

## 1. MVP Purpose & Scope

The goal of this MVP is to deliver the **simplest possible secure communication channel** between a visitor and an organizational ombuds—while reinforcing the IOA Standards of Practice:  
**Confidentiality, Independence, Neutrality, and Informality.**

The MVP focuses exclusively on:

- Secure, encrypted messaging between visitor and ombuds  
- Simple intake workflow  
- Secure, minimal desktop dashboard for ombuds  
- Basic notification system (email alert for ombuds, push notification optional for visitors)  
- Strong privacy boundaries & data separation from institutions

This MVP is **not** a full case management system. That will come in future versions.

---

## 2. System Components Overview

### A. Mobile App (Visitor-Facing)
Purpose: Provide a simple, secure channel for visitors to reach their ombuds.

### B. Desktop Web App (Ombuds-Facing)
Purpose: Provide a simple, secure interface for ombuds to receive and respond to messages.

### C. Backend System (Supabase)
Purpose: Securely store encrypted messages, manage routing, authenticate ombuds, and maintain strict separation between system admin, institutions, visitors, and ombuds.

---

## 3. User Roles

### 3.1 Visitor
- Anonymous by default (system-generated alias)  
- Optionally provides contact info for recovery: phone number or personal email  
- Can send initial message + encrypted messaging thread with ombuds  
- Can export conversation to personal email (optional, opt-in)

### 3.2 Ombuds
- Receives incoming messages securely  
- Responds within encrypted dashboard  
- Organizes messages by: **New**, **Active**, **Resolved**  
- Cannot export messages (MVP)  
- Can rename visitor alias internally for tracking  

### 3.3 System Administrator (Digital Ombuds, Inc.)
- Creates ombuds login credentials  
- Provides institutional onboarding  
- Has extremely limited, auditable access for data recovery *only when requested by the ombuds office*  

---

## 4. Visitor Mobile App – Requirements

### 4.1 Onboarding Flow
1. Visitor scans QR code OR opens app and selects their institution.
2. Confirms institution.
3. Identifies themselves as:  
   - Student  
   - Staff  
   - Faculty  
4. Enters free-text description of their issue (unlimited text).
5. Submits the message.

### 4.2 After Submission
Visitor sees confirmation screen:

> “Your ombuds has been notified. You will receive a response through this secure, encrypted app.”

### 4.3 Messaging Interface
- Simple chat-style layout
- Messages encrypted client-side
- Can send:
  - Text  
  - Files (PDF, images)  
  - Links  
- Push notifications optional (MVP)

### 4.4 Recovery Options
Visitors may optionally provide one of the following:

- Personal email  
- Phone number  

Purpose:
- Recover access if they get a new phone  
- Request secure export of message history

### 4.5 Data Storage on Device
- Minimal local storage  
- App fetches everything from the encrypted backend  
- Losing the phone does **not** lose the conversation  

---

## 5. Ombuds Desktop Web App – Requirements

### 5.1 Login Flow (Two-Step)
1. Ombuds enters username + password created for them by system admin.  
2. Ombuds receives OTP code by email.  
3. Entering OTP grants access.

### 5.2 Dashboard Layout
Three columns:

#### Column 1 — **New Messages**
- First contact messages  
- Unopened threads

#### Column 2 — **Active Messages**
- Ongoing conversations  
- Awaiting ombuds response

#### Column 3 — **Resolved**
- Conversations marked resolved  
- Messages retained for **180 days**, then moved to Archive (future version)

### 5.3 Messaging Capabilities
- Fully encrypted chat with visitor  
- Text, images, PDFs, links  
- Ability to rename visitor alias (internal only)  
- No exporting messages  
- No ability to delete messages

### 5.4 Message Thread Page
When ombuds clicks a thread:

- Opens in a new secure tab  
- Shows entire encrypted conversation  
- Shows visitor category (student/staff/faculty)  
- Response box at bottom  
- Ability to mark as **Resolved**

### 5.5 Notification System
#### Ombuds:
- Receives email:  
  **“New secure message received. Log in to view.”**  
  (Contains no content, only alert + link)

#### Visitor:
- Receives push notification (if enabled):  
  **“You have a new message from your ombuds.”**

---

## 6. Backend Requirements (Supabase)

### 6.1 Core Tables
#### `institutions`
- id  
- name  
- qr_code_id  

#### `visitors`
- id  
- institution_id  
- alias  
- recovery_email (optional)  
- recovery_phone (optional)  
- recovery_key (encrypted)  

#### `messages`
- id  
- visitor_id  
- ombuds_id  
- role (visitor/ombuds)  
- body (encrypted)  
- timestamp  
- read_status  

#### `threads`
- id  
- visitor_id  
- ombuds_id  
- status (new/active/resolved)  
- resolved_at  

#### `ombuds_users`
- id  
- institution_id  
- email  
- password_hash  
- role = 'ombuds'

### 6.2 Security Model
- Row-Level Security ON  
- Ombuds can only see rows belonging to their institution  
- Visitors can only see their own thread  
- System admin cannot access messages unless ombuds requests recovery

### 6.3 Encryption
Messages are encrypted either:
- Client-side with per-thread key **OR**
- Server-side with strong AES encryption (MVP)

Future versions move to full E2EE.

---

## 7. Additional MVP Constraints

### 7.1 No Data Exports for Ombuds
To comply with confidentiality requirements, ombuds cannot export:
- Full threads  
- PDFs  
- Reports  

Eventually, IOA-compliant aggregate reporting will be added.

### 7.2 No Handling of Emergencies
App includes disclaimer:

> “This tool is not monitored 24/7.  
> If you are in immediate danger, contact emergency services.”

### 7.3 Minimal CO₂ Brain Load UI
- Simple  
- Large buttons  
- Very high contrast  
- Designed for ombuds who may not be tech-forward  

---

## 8. Success Criteria (MVP)

### Technical Success
- Visitor can send first contact securely  
- Ombuds receives notification and can reply  
- Both can message back and forth  
- All data is encrypted  
- Ombuds dashboard shows correct message states  
- Visitor can recover account if device is lost  

### Product Success
- Ombuds say:  
  **“This is simple enough that I could use it today.”**  
- Visitors say:  
  **“I feel safer using this than email.”**  
- IOA-aligned practitioners affirm confidentiality + independence support  

---

## 9. Future Versions (Post-MVP)

### MVP v1.1
- Push notifications stable  
- Light attachment handling  
- Typing indicators  
- Visitor end-of-interaction survey

### MVP v2.0
- Full archive system  
- Basic analytics for ombuds (non-identifying)  
- Institutional super-admin accounts  
- Multi-ombuds routing

### MVP v3.0+
- Full visitor intake form (your original drill-down model)  
- Case management system  
- Document library  
- Institution-wide reporting (IOA compliant)

---

# End of MVP Requirements Document v1.0
## 10. MVP Message Flow Contract

This section defines the exact data exchange between the Visitor Mobile App, Backend, and Ombuds Desktop.

### Visitor → Backend
On first submission, the mobile app sends:

- institution_slug
- role (student / staff / faculty)
- message_text (string)
- recovery_key_hash

Backend creates:
- visitor record
- case record (status = "new")
- message record (sender = "visitor")

### Backend → Ombuds Dashboard
Dashboard queries:
- cases where institution_id matches ombuds_user.institution_id
- status IN ("new", "active")

Displayed per case:
- alias
- role
- last_message_timestamp

### Ombuds → Backend
Ombuds sends:
- case_id
- message_text

Backend:
- inserts message (sender = "ombuds")
- updates case.status = "active"

### Backend → Visitor
Visitor fetches:
- messages by case_id
- ordered by created_at
