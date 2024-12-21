import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 사용자 설정을 담는 데이터 클래스
class UserSettings {
  final int cardIndex;
  final bool autoPlay;
  final String locale;

  const UserSettings({
    required this.cardIndex,
    required this.autoPlay,
    required this.locale,
  });

  UserSettings copyWith({int? cardIndex, bool? autoPlay, String? locale}) {
    return UserSettings(
      cardIndex: cardIndex ?? this.cardIndex,
      autoPlay: autoPlay ?? this.autoPlay,
      locale: locale ?? this.locale,
    );
  }
}

/// UserSettings 상태를 관리하는 StateNotifier
class UserSettingsNotifier extends StateNotifier<UserSettings> {
  UserSettingsNotifier() : super(const UserSettings(cardIndex: 0, autoPlay: false, locale: 'ko')) {
    _loadFromPreferences();
  }

  /// SharedPreferences에서 기존 설정값 로딩
  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCardIndex = prefs.getInt('cardIndex') ?? 0;
    final savedAutoPlay = prefs.getBool('autoPlay') ?? false;
    final locale = prefs.getString('locale') ?? 'ko';
    state = UserSettings(cardIndex: savedCardIndex, autoPlay: savedAutoPlay, locale: locale);
  }


  /// 카드 인덱스 설정
  Future<void> setCardIndex(int index) async {
    state = state.copyWith(cardIndex: index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cardIndex', index);
  }

  /// 자동 재생 모드 설정
  Future<void> setAutoPlay(bool value) async {
    state = state.copyWith(autoPlay: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoPlay', value);
  }
  
  Future<void> setLocale(String locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }
}

/// UserSettingsNotifier를 제공하는 전역 Provider
final userSettingsProvider = StateNotifierProvider<UserSettingsNotifier, UserSettings>((ref) {
  return UserSettingsNotifier();
});