import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _service = AdminService();

  bool isLoading = false;

  // 🔥 Stream all users
  Stream<QuerySnapshot> getUsers() {
    return _service.getUsers();
  }

  Future<void> makeAdmin(String uid) async {
    await _service.makeUserAdmin(uid);
  }
}