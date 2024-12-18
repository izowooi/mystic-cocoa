import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Localize {
  static final Localize _instance = Localize._internal();

  factory Localize() {
    return _instance;
  }

  Localize._internal();

  Map<String, String>? _localizedStrings;

  Future<void> initialize(String locale) async {
    final jsonPath = 'assets/locale/locale_$locale.json';
    const fallbackPath = 'assets/locale/locale_ko.json';

    final pathToLoad = await _isAssetExists(jsonPath) ? jsonPath : fallbackPath;

    try {
      String jsonString = await rootBundle.loadString(pathToLoad);
      
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      
      print('Loaded locale file: $pathToLoad');
    } catch (e) {
      
      print('Error loading locale file $pathToLoad: $e');
      
      _localizedStrings = {}; // 실패 시 빈 맵 설정
    }
  }
  
  Future<bool> _isAssetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 특정 키의 로컬라이즈된 값 가져오기
  String get(String key) {
    return _localizedStrings?[key] ?? key; // 키가 없으면 그대로 반환
  }
}