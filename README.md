<<<<<<< HEAD
# sharedp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# Shared Preferences Demo App

A simple Flutter application demonstrating local data storage using `shared_preferences`. This app allows users to store, retrieve, update, and clear basic user information (name, age, login status) locally on their device.

## ✨ Features

*   **Store Data:** Save user's name, age, and login status.
*   **Retrieve Data:** Load previously saved data and display it.
*   **Update Data:** Modify existing data (saving new values for existing keys).
*   **Clear Data:** Remove all stored application data.
*   **Intuitive UI:** Easy-to-use interface with input fields and action buttons.

## 🚀 Technologies Used

*   **Flutter:** Framework for building cross-platform mobile applications.
*   **Dart:** Programming language.
*   **`shared_preferences` package:** For persistent key-value storage of simple data.


## 📦 Installation

To get a local copy up and running, follow these simple steps:

1.  **Clone the repository:**
    ```bash
    https://github.com/DEVIL-07-7/sharedala3.git
    cd shared_prefs_demo
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```

## 💡 Usage

1.  **Initial Load:** When the app starts, it attempts to load any previously saved data and displays "N/A" or "0" if nothing is found.
2.  **Input Data:** Use the "Name" and "Age" text fields, and the "Is Logged In" switch to enter or modify data.
3.  **Save/Update Data:** Click the "Save/Update Data" button to store the current input values. This will overwrite any existing data for the same keys.
4.  **Load Data:** Click the "Load Data" button to explicitly reload data from `shared_preferences` and update the displayed values. (This happens automatically on app start and after saving/clearing).
5.  **Clear All Data:** Click "Clear All Data" to remove all user-specific data stored by this application.
>>>>>>> 1e9d74485467ce3f16e516bff6475adf7a38d577
