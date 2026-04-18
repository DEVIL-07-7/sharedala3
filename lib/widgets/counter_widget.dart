import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Counter widget demonstrating persistent integer storage.
/// The counter value persists even after app restarts.
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final StorageService _storage = StorageService();
  int _counter = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final count = await _storage.getCounter();
    setState(() {
      _counter = count;
      _isLoading = false;
    });
  }

  Future<void> _increment() async {
    final count = await _storage.incrementCounter();
    setState(() => _counter = count);
  }

  Future<void> _reset() async {
    final count = await _storage.resetCounter();
    setState(() => _counter = count);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Counter reset to 0'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _loadCounter,
            tooltip: 'Reload from storage',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Counter value (persisted):',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_counter',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: _increment,
                        icon: const Icon(Icons.add),
                        label: const Text('Increment'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline,
                            size: 18, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Value persists across app restarts!',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
