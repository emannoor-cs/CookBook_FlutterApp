# CookBook

A recipe management app built with Flutter featuring a dark UI, smart search, and full recipe management across 5 screens.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-6C63FF?style=for-the-badge)](https://flutter.dev)

---

## Screenshots

| Home | Recipe Detail | Add Recipe |
|------|--------------|------------|
| <img src="assets/screenshots/home.jpeg" width="200"> | <img src="assets/screenshots/details.jpeg" width="200"> | <img src="assets/screenshots/addrecipe.jpeg" width="200"> |

| Favorites | Settings |
|-----------|----------|
| <img src="assets/screenshots/favourites.jpeg" width="200"> | <img src="assets/screenshots/settings.jpeg" width="200"> |
---

## Features

| Screen | Description |
|--------|-------------|
| Home | Featured hero card, category filters, 2-column recipe grid |
| Recipe Detail | Ingredients, difficulty chip, cook time, start cooking CTA |
| Add Recipe | Form validation, difficulty selector, dynamic ingredients list |
| Favorites | Save and manage favorite recipes with empty state |
| Settings | Dark theme, notifications, auto sync, data export/import |

---

## Getting Started

```bash
# Clone the repo
git clone https://github.com/emannoor-cs/CookBook_FlutterApp.git

# Install dependencies
flutter pub get

# Run the app
flutter run
```

**Platforms**

```bash
flutter run -d android
flutter run -d chrome
flutter run -d windows
```

---

## Project Structure

```
lib/
└── main.dart
    ├── AppColors              # Color tokens
    ├── MainNavigation         # Bottom nav + shared state
    ├── HomeScreen             # Search, filters, recipe grid
    ├── RecipeDetailScreen     # Full recipe view
    ├── AddRecipeScreen        # Recipe creation form
    ├── FavoritesScreen        # Saved recipes
    └── SettingsScreen         # Preferences
```

---

## Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** setState
- **Packages:** None — pure Flutter

---

## Author

**Eman Noor**  
[![GitHub](https://img.shields.io/badge/GitHub-emannoor--cs-181717?style=for-the-badge&logo=github)](https://github.com/emannoor-cs)
