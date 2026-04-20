import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.read<NoteProvider>();
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
    final cardColor = isDark ? const Color(0xFF2A2E36) : Colors.white;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
       
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: background),
        child: StreamBuilder<QuerySnapshot<Note>>(
          stream: noteProvider.noteService.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong: ${snapshot.error}"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final notes = snapshot.data!.docs.map((doc) => doc.data()).toList()
              ..sort((a, b) {
                final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
                final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
                return bTime.compareTo(aTime);
              });

            if (notes.isEmpty) {
              return const Center(child: Text("No notes yet"));
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 96, 16, 100),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.content,
                              style: TextStyle(color: subtitleColor),
                            ),
                            if (note.youtubeTitle != null || note.youtubeThumbnailUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF0F2F7),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? Colors.white12 : Colors.black12,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (note.youtubeThumbnailUrl != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            note.youtubeThumbnailUrl!,
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.video_library),
                                          ),
                                        ),
                                      if (note.youtubeTitle != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            note.youtubeTitle!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          _ActionButton(
                            icon: Icons.edit,
                            background: isDark
                                ? const Color(0xFF3A3F4A)
                                : const Color(0xFFF0F2F7),
                            iconColor: isDark
                                ? Colors.white
                                : const Color(0xFF6C6C6C),
                            onTap: () {
                              noteProvider.initEditControllers(
                                note.title,
                                note.content,
                              );
                              Navigator.pushNamed(
                                context,
                                '/edit_note',
                                arguments: note.id!,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          _ActionButton(
                            icon: Icons.delete,
                            background: isDark
                                ? const Color(0xFF523333)
                                : const Color(0xFFFFE8E6),
                            iconColor: isDark
                                ? const Color(0xFFFFA6A0)
                                : const Color(0xFFD35450),
                            onTap: () async {
                              await noteProvider.deleteNote(note.id!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Clear any previous values when adding new note
          noteProvider.addTitleController.clear();
          noteProvider.addContentController.clear();
          Navigator.pushNamed(context, '/add_note');
        },
        backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFFDCD8FF),
        foregroundColor: isDark ? Colors.white : Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}
