import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/note_service.dart';
import '../services/graphql_service.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final NoteService noteService = NoteService();
  final GraphQLService _graphQLService = GraphQLService();

  final TextEditingController addTitleController = TextEditingController();
  final TextEditingController addContentController = TextEditingController();

  final TextEditingController editTitleController = TextEditingController();
  final TextEditingController editContentController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ✅ Extract YouTube URL from text
  String? extractYoutubeUrl(String text) {
    final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
    final match = urlRegex.firstMatch(text);
    return match?.group(0);
  }

  // ✅ ADD NOTE (UPDATED)
    Future<void> addNote(BuildContext context) async {
      _isLoading = true;
      notifyListeners();

      try {
        final content = addContentController.text.trim();

        // 🔍 extract youtube url
        final url = extractYoutubeUrl(content);

        Map<String, dynamic>? data;

        // 📡 call API only if url exists
        if (url != null) {
          data = await _graphQLService.getYoutubeData(url);
        }

        await noteService.addNote(
          Note(
            title: addTitleController.text.trim(),
            content: content,
            youtubeThumbnailUrl: data?['thumbnail']?.toString(),
            youtubeTitle: data?['title']?.toString(),
            youtubeDescription: data?['description']?.toString(),
          ),
        );

        addTitleController.clear();
        addContentController.clear();
    } catch (e) {
      debugPrint("Error adding note: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void initEditControllers(String oldTitle, String oldContent) {
    editTitleController.text = oldTitle;
    editContentController.text = oldContent;
  }

  // ✅ UPDATE NOTE (UPDATED)
  Future<void> updateNote(String docId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final content = editContentController.text.trim();

      final url = extractYoutubeUrl(content);

      Map<String, dynamic>? data;

      if (url != null) {
        data = await _graphQLService.getYoutubeData(url);
      }

      await noteService.updateNote(
        Note(
          id: docId,
          title: editTitleController.text.trim(),
          content: content,
          youtubeThumbnailUrl: data?['thumbnail']?.toString(),
          youtubeTitle: data?['title']?.toString(),
          youtubeDescription: data?['description']?.toString(),
        ),
      );
    } catch (e) {
      debugPrint("Error updating note: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String docId) async {
    await noteService.deleteNote(docId);
  }

  @override
  void dispose() {
    addTitleController.dispose();
    addContentController.dispose();
    editTitleController.dispose();
    editContentController.dispose();
    super.dispose();
  }
}