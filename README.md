# 🚀 Engezha

**Engezha** is a productivity and daily planning application built with **Flutter** and **Firebase**.

It helps users organize their daily tasks, build habits, track their progress, and manage their day through a simple and clean interface.

> **Plan it. Track it. Engezha.**

---

## ✨ Features

### 🔐 Authentication

* Create a new account
* Login with email and password
* Password reset
* Persistent authentication
* Secure logout

### ✅ Tasks

* Create tasks
* Edit existing tasks
* Delete tasks
* Select task date
* Set start and end times
* Add optional notes
* Choose an emoji for each task
* Mark tasks as completed
* Track completion by date

### 🔥 Habits

* Create daily habits
* Edit and delete habits
* Track daily habit completion
* Maintain completion history
* Organize habits alongside daily tasks

### 📅 Daily Planner

* Browse different days
* View tasks and habits for the selected date
* Track daily completion
* Live synchronization with Firestore

### 📊 Dashboard

* Track completed tasks
* Track completed habits
* View overall completion rate
* Monitor productivity progress using real user data

### 👤 Profile

* User profile information
* Display name and email
* Light and dark themes
* Secure logout

---

## 🛠️ Built With

* **Flutter** — Cross-platform application framework
* **Dart** — Application programming language
* **Firebase Authentication** — User authentication
* **Cloud Firestore** — Cloud database and real-time synchronization
* **Firebase Core** — Firebase integration

---

## 🏗️ Project Structure

```text
lib/
├── app/
│   ├── theme/
│   ├── app.dart
│   └── routes.dart
│
├── core/
│   ├── services/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── home/
│   ├── planner/
│   ├── profile/
│   └── shell/
│
├── firebase_options.dart
└── main.dart
```

The project follows a **feature-first architecture** to keep features separated, maintainable, and easy to extend.

---

## 🔥 Firebase

Engezha uses Firebase for authentication and persistent cloud storage.

Each user has their own data stored separately in Firestore:

```text
users/
└── {userId}/
    ├── name
    ├── email
    │
    └── entries/
        └── {entryId}
            ├── title
            ├── notes
            ├── kind
            ├── date
            ├── startMinutes
            ├── endMinutes
            └── completedDates
```

Firestore Security Rules restrict users to accessing their own data.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Git
* A Firebase project

Check your Flutter installation:

```bash
flutter doctor
```

### 1. Clone the repository

```bash
git clone https://github.com/loai06/engezha-app.git
cd engezha-app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

The application requires a Firebase project with:

* Firebase Authentication
* Email/Password authentication enabled
* Cloud Firestore

Configure the project using FlutterFire:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Run the application

```bash
flutter run
```

---

## 🔒 Firestore Security

Engezha uses Firebase Authentication together with Firestore Security Rules so users can only access their own information.

Never use unrestricted Firestore rules in production.

---

## 🧪 Testing

Run the test suite with:

```bash
flutter test
```

Run static analysis with:

```bash
flutter analyze
```

---

## 🗺️ Roadmap

Engezha is actively being developed. Planned features include:

* 🔥 Habit streaks and longest streak tracking
* 🔔 Task and habit reminders
* 📅 Advanced calendar
* 📈 Advanced productivity analytics
* 🌍 Arabic and English localization
* 🎯 Goals and milestones
* ☁️ Improved synchronization
* 🤖 AI-powered daily planning
* 👑 Engezha Pro

---

## 🤝 Contributing

Contributions are welcome.

If you are working on a new feature, create a separate branch:

```bash
git checkout -b feature/your-feature-name
```

After making your changes:

```bash
git add .
git commit -m "feat: describe your feature"
git push origin feature/your-feature-name
```

Then open a Pull Request on GitHub.

---

## 📱 Platforms

Engezha is built with Flutter and is designed to support:

* Android
* iOS
* Web
* Windows

---

## 📄 License

This project is currently under development.

---

<p align="center">
  <strong>Built with Flutter 💙</strong>
</p>

<p align="center">
  Plan your day. Build better habits. Get things done.
</p>
