import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  Future<void> saveNote(BuildContext context) async {
    try {
      await context.read<NoteProvider>().addNote();
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save note: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1E1E24), Color(0xFF0F1115)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFF2F3F7), Color(0xFFE9ECF4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: background),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              children: [
                TextField(
                  controller: noteProvider.addTitleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    filled: true,
                    fillColor: isDark ? const Color(0xFF2A2E36) : Colors.white,
                    border: fieldBorder,
                    enabledBorder: fieldBorder,
                    focusedBorder: fieldBorder.copyWith(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteProvider.addContentController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: "Content",
                    filled: true,
                    fillColor: isDark ? const Color(0xFF2A2E36) : Colors.white,
                    border: fieldBorder,
                    enabledBorder: fieldBorder,
                    focusedBorder: fieldBorder.copyWith(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: noteProvider.isLoading ? null : () => saveNote(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? const Color(0xFF4F7DDA) : const Color(0xFF6D6BEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 2,
                    ),
                    child: noteProvider.isLoading 
                        ? const SizedBox(
                            width: 24, 
                            height: 24, 
                            child: CircularProgressIndicator(strokeWidth: 2)
                          )
                        : const Text(
                            "Save Note",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
