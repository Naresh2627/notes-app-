import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference<Note> notes = FirebaseFirestore.instance
      .collection('notes')
      .withConverter<Note>(
        fromFirestore: (snapshot, _) => Note.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (note, _) => note.toMap(),
      );

  String _requireUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('User not logged in');
    }
    return user.uid;
  }

  Future<void> addNote(Note note) async {
    final noteWithUser = note.copyWith(
      userId: _requireUserId(),
      createdAt: Timestamp.now(),
    );
    await notes.add(noteWithUser);
  }

  Stream<QuerySnapshot<Note>> getNotes() {
    return notes
        .where('userId', isEqualTo: _requireUserId())
        .snapshots();
  }

  Future<void> updateNote(Note note) async {
    if (note.id == null) return;
    await notes.doc(note.id).set(note, SetOptions(merge: true));
  }

  Future<void> deleteNote(String docId) async {
    await notes.doc(docId).delete();
  }
}
