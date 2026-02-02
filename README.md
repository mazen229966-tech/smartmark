# SmartMark – AI Marketing Plan Generator (Flutter, Arabic RTL)

SmartMark is a Flutter mobile application designed to help small businesses create complete marketing plans in minutes.
The app supports Arabic language (RTL) and focuses on simplicity, usability, and real value for non-technical users.

It provides both **local plan generation** and an **optional AI-powered plan enhancement** using Google Gemini API.

---

## ✨ Features

- Arabic UI with full RTL support
- Onboarding flow (shown only once)
- User setup (store username locally)
- Create marketing plans based on simple inputs
- Generate:
  - Content ideas
  - Ad copies with CTA
  - Hashtags
  - Weekly content calendar
  - Budget suggestion
- AI-powered full plan enhancement (optional – Gemini API)
- Copy individual sections or the full plan
- Save plans locally using Sqflite
- View plan details including content calendar
- Brand Kit (add logo/product image and attach it to plans)
- Bottom Navigation (Home / Plans / Tips / Settings)
- Settings:
  - Dark / Light mode
  - Clear local data
  - Reset application
- Loading indicators and user feedback (Snackbars, Dialogs)

---

## 🧠 AI Integration (Optional)

The application integrates with **Google Gemini API** to enhance the entire marketing plan using generative AI.

AI features include:
- Improving content ideas
- Enhancing ad copies
- Generating optimized hashtags
- Creating a complete weekly content calendar
- Suggesting budget distribution and KPIs

> 🔐 **Security Note**  
> API keys are NOT included in this repository.  
> They are stored locally and excluded from version control following best practices.

---

## 🏗️ Architecture & Best Practices

- **State Management:** Provider
- **Local Storage:**
  - SharedPreferences (user data, onboarding, settings)
  - Sqflite (saved marketing plans)
- **Clean Architecture:**
  - Separation of UI, logic, and data layers
- **Reusable widgets**
- **Clear navigation using named routes**

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Provider
- Sqflite
- SharedPreferences
- Image Picker
- HTTP
- Google Gemini API (optional)

---

## 🔐 API Key Setup (For AI Feature)

Create the following file locally (do NOT commit it):

## Setup
1. Clone the repo
2. Copy `lib/core/config/api_keys.example.dart`
   to `lib/core/config/api_keys.dart`
3. Add your Gemini API key
4. Run `flutter pub get`
5. Run `flutter run`