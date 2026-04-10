import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Get all users
  Stream<QuerySnapshot> getUsers() {
    return _firestore.collection('users').snapshots();
  }

  // ✅ Make admin using UID
  Future<void> makeUserAdmin(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'role': 'admin',
    });
  }
}