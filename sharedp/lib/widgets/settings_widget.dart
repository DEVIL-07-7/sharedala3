import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Settings widget demonstrating boolean and string preferences,
/// plus the ability to clear all stored data.
class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final StorageService _storage = StorageService();
  String _themeMode = 'light';
  bool _darkMode = false;
  bool _isLoggedIn = false;
  String? _lastLogin;
  Set<String> _allKeys = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final theme = await _storage.getThemeMode();
    final dark = await _storage.getDarkMode();
    final loggedIn = await _storage.isLoggedIn();
    final lastLogin = await _storage.getLastLogin();
    final keys = await _storage.getAllKeys();

    setState(() {
      _themeMode = theme;
      _darkMode = dark;
      _isLoggedIn = loggedIn;
      _lastLogin = lastLogin;
      _allKeys = keys;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    await _storage.saveDarkMode(value);
    await _loadSettings();
  }

  Future<void> _changeTheme(String mode) async {
    await _storage.saveThemeMode(mode);
    setState(() => _themeMode = mode);
  }

  Future<void> _handleLogin() async {
    if (_isLoggedIn) {
      await _storage.logout();
    } else {
      await _storage.login();
    }
    _loadSettings();
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will remove ALL data from SharedPreferences. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.clearAll();
      _loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark theme'),
                    value: _darkMode,
                    onChanged: _toggleDarkMode,
                    secondary: const Icon(Icons.dark_mode),
                  ),
                  ListTile(
                    title: const Text('Theme Mode'),
                    subtitle: Text('Current: $_themeMode'),
                    trailing: DropdownButton<String>(
                      value: _themeMode,
                      items: const [
                        DropdownMenuItem(
                          value: 'light',
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: 'dark',
                          child: Text('Dark'),
                        ),
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) _changeTheme(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Authentication',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Login Status'),
                    subtitle: Text(_isLoggedIn
                        ? 'Logged in${_lastLogin != null
                            ? ' (Last: ${_lastLogin!.substring(0, 19)})'
                            : ''}'
                        : 'Not logged in'),
                    trailing: FilledButton(
                      onPressed: _handleLogin,
                      child: Text(_isLoggedIn ? 'Logout' : 'Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Storage Info',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Stored Keys'),
                    subtitle: Text(_allKeys.isEmpty
                        ? 'No data stored'
                        : _allKeys.join(', ')),
                    leading: const Icon(Icons.storage),
                  ),
                  ListTile(
                    title: const Text('Total Keys'),
                    subtitle: Text('${_allKeys.length} keys in storage'),
                    leading: const Icon(Icons.key),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danger Zone',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Clear All Data'),
                    subtitle: const Text(
                      'Remove all SharedPreferences data',
                    ),
                    trailing: FilledButton(
                      onPressed: _clearAllData,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
