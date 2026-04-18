import 'package:shared_preferences/shared_preferences.dart';

/// A service class that wraps SharedPreferences operations.
/// This demonstrates proper separation of concerns in Flutter.
class StorageService {
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyAge = 'age';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLastLogin = 'last_login';
  static const String _keyNotes = 'notes';
  static const String _keyCounter = 'counter';
  static const String _keyIsDarkMode = 'is_dark_mode';

  /// Get the SharedPreferences instance
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // ==================== USER PROFILE ====================

  /// Save the user's username
  Future<bool> saveUsername(String username) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyUsername, username);
  }

  /// Retrieve the saved username, or null if not set
  Future<String?> getUsername() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUsername);
  }

  /// Save the user's email address
  Future<bool> saveEmail(String email) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyEmail, email);
  }

  /// Retrieve the saved email, or null if not set
  Future<String?> getEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_keyEmail);
  }

  /// Save the user's age
  Future<bool> saveAge(int age) async {
    final prefs = await _prefs;
    return await prefs.setInt(_keyAge, age);
  }

  /// Retrieve the saved age, or null if not set
  Future<int?> getAge() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyAge);
  }

  // ==================== AUTHENTICATION ====================

  /// Set login state to true
  Future<bool> login() async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsLoggedIn, true);
    return await prefs.setString(
        _keyLastLogin, DateTime.now().toString());
  }

  /// Set login state to false
  Future<bool> logout() async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// Check if the user is currently logged in
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Get the timestamp of the last login
  Future<String?> getLastLogin() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLastLogin);
  }

  // ==================== PREFERENCES ====================

  /// Save theme mode preference
  Future<bool> saveThemeMode(String mode) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyThemeMode, mode);
  }

  /// Get saved theme mode (default: 'light')
  Future<String> getThemeMode() async {
    final prefs = await _prefs;
    return prefs.getString(_keyThemeMode) ?? 'light';
  }

  /// Save dark mode toggle
  Future<bool> saveDarkMode(bool isDark) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyIsDarkMode, isDark);
  }

  /// Get dark mode state
  Future<bool> getDarkMode() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsDarkMode) ?? false;
  }

  // ==================== COUNTER ====================

  /// Increment the counter and save it
  Future<int> incrementCounter() async {
    final prefs = await _prefs;
    int current = prefs.getInt(_keyCounter) ?? 0;
    int updated = current + 1;
    await prefs.setInt(_keyCounter, updated);
    return updated;
  }

  /// Get current counter value
  Future<int> getCounter() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyCounter) ?? 0;
  }

  /// Reset the counter to zero
  Future<int> resetCounter() async {
    final prefs = await _prefs;
    await prefs.setInt(_keyCounter, 0);
    return 0;
  }

  // ==================== NOTES ====================

  /// Save a list of notes (stored as JSON string)
  Future<bool> saveNotes(List<String> notes) async {
    final prefs = await _prefs;
    return await prefs.setStringList(_keyNotes, notes);
  }

  /// Retrieve saved notes
  Future<List<String>> getNotes() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyNotes) ?? [];
  }

  /// Add a single note to the list
  Future<List<String>> addNote(String note) async {
    List<String> notes = await getNotes();
    notes.add(note);
    await saveNotes(notes);
    return notes;
  }

  /// Remove a note by index
  Future<List<String>> removeNote(int index) async {
    List<String> notes = await getNotes();
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
      await saveNotes(notes);
    }
    return notes;
  }

  // ==================== OPERATIONS ====================

  /// Remove a specific key from storage
  Future<bool> removeKey(String key) async {
    final prefs = await _prefs;
    return await prefs.remove(key);
  }

  /// Clear ALL data from SharedPreferences
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }

  /// Get all keys currently in storage
  Future<Set<String>> getAllKeys() async {
    final prefs = await _prefs;
    return prefs.getKeys();
  }

  /// Check if a specific key exists
  Future<bool> hasKey(String key) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }
}
