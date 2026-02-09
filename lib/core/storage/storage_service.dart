import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  final _secureStorage = const FlutterSecureStorage();

  // Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Secure storage for sensitive data (tokens)
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Remove operations
  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  Future<bool> clear() async {
    await _secureStorage.deleteAll();
    return await prefs.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Replace these placeholder methods with actual implementations:

  Future<void> saveSecure(String key, String value) async {
    await setSecureString(key, value);
  }

  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    await setJson(key, value);
  }

  Future<void> deleteSecure(String key) async {
    await deleteSecureString(key);
  }

  Future<void> delete(String key) async {
    await remove(key);
  }

  Future<String?> readSecure(String key) async {
    return await getSecureString(key);
  }

  Future<Map<String, dynamic>?> readJson(String key) async {
    return getJson(key);
  }
}
