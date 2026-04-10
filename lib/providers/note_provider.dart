import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final NoteService noteService = NoteService();

  final TextEditingController addTitleController = TextEditingController();
  final TextEditingController addContentController = TextEditingController();

  final TextEditingController editTitleController = TextEditingController();
  final TextEditingController editContentController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> addNote() async {
    _isLoading = true;
    notifyListeners();
    try {
      await noteService.addNote(
        Note(
          title: addTitleController.text.trim(),
          content: addContentController.text.trim(),
        ),
      );
      addTitleController.clear();
      addContentController.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void initEditControllers(String oldTitle, String oldContent) {
    editTitleController.text = oldTitle;
    editContentController.text = oldContent;
  }

  Future<void> updateNote(String docId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await noteService.updateNote(
        Note(
          id: docId,
          title: editTitleController.text.trim(),
          content: editContentController.text.trim(),
        ),
      );
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
