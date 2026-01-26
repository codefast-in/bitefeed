import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _otp = '';
  String get otp => _otp;

  final List<String> _selectedPreferences = ['Vegetarian', 'Dessert Lover'];
  List<String> get selectedPreferences => _selectedPreferences;

  final List<String> _availablePreferences = [
    'Vegetarian',
    'Coffee Lover',
    'Vegan',
    'Dessert Lover',
    'Street Food',
    'Healthy',
  ];
  List<String> get availablePreferences => _availablePreferences;

  void setOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  void togglePreference(String preference) {
    if (_selectedPreferences.contains(preference)) {
      _selectedPreferences.remove(preference);
    } else {
      _selectedPreferences.add(preference);
    }
    notifyListeners();
  }

  void addCustomPreference(String preference) {
    if (preference.isNotEmpty && !_availablePreferences.contains(preference)) {
      _availablePreferences.add(preference);
      _selectedPreferences.add(preference);
      notifyListeners();
    }
  }
}
