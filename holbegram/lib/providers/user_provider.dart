import 'package:flutter/material.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Users? _user; // Donnée utilisateur
  final AuthMethod _authMethod = AuthMethod(); // Instance d'auth

  // Getter pour accéder au user depuis l'extérieur
  Users? get getUser => _user;

  // Rafraîchissement du user (utile après login/signup)
  Future<void> refreshUser() async {
    Users user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
