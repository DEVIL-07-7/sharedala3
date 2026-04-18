import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Notes widget demonstrating List<String> storage.
/// Shows how to store, retrieve, update, and delete items in a list.
class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  final StorageService _storage = StorageService();
  final _noteController = TextEditingController();
  List<String> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _storage.getNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _addNote() async {
    if (_noteController.text.trim().isEmpty) return;

    final notes = await _storage.addNote(_noteController.text.trim());
    setState(() => _notes = notes);
    _noteController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note added (${notes.length} total)'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _removeNote(int index) async {
    final notes = await _storage.removeNote(index);
    setState(() => _notes = notes);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _editNote(int index) async {
    final controller = TextEditingController(text: _notes[index]);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Note text',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                _notes[index] = controller.text.trim();
                await _storage.saveNotes(_notes);
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                await _storage.saveNotes([]);
                _loadNotes();
              },
              tooltip: 'Clear all notes',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Add note form
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a note...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.edit_note),
                          ),
                          onSubmitted: (_) => _addNote(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _addNote,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                // Notes list
                Expanded(
                  child: _notes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.note_add,
                                  size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'No notes yet',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(_notes[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editNote(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _removeNote(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
