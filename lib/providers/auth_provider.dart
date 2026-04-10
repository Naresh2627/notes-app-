import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _role = '';
  String get role => _role;

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.login(
        loginEmailController.text.trim(),
        loginPasswordController.text.trim(),
      );
      if (user != null) {
        final fetchedRole = await _authService.getUserRole(user.uid);
        _role = fetchedRole ?? 'user';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.register(
        registerEmailController.text.trim(),
        registerPasswordController.text.trim(),
      );
      if (user != null) {
        _role = 'user';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _role = '';
    loginEmailController.clear();
    loginPasswordController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.dispose();
  }
}
