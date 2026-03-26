import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<User?>? _authSubscription;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _authService.currentUser;

  AuthViewModel() {
    _authSubscription = _authService.user.listen((_) {
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signIn(email, password);
      return true;
    } on FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? error.code;
      return false;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signUp(email, password);
      return true;
    } on FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? error.code;
      return false;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
