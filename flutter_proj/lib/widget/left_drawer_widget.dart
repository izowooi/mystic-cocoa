import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final debugModeProvider = ChangeNotifierProvider<DebugModes>((ref) {
  return DebugModes();
});


// DebugModes 상태 클래스
class DebugModes extends ChangeNotifier {
  bool apiLogging = false;
  bool enableAllowAllCards = false;
  bool showPerformanceOverlay = false;
  bool enableMockData = false;

  DebugModes() {
    _loadFromPreferences(); // SharedPreferences에서 데이터 불러오기
  }

  // API Logging 상태 변경
  void toggleApiLogging(bool value) {
    apiLogging = value;
    _saveToPreferences(); // SharedPreferences에 저장
    notifyListeners();
  }
  
  // API Logging 상태 변경
  void toggleAllowAllCards(bool value) {
    enableAllowAllCards = value;
    _saveToPreferences(); // SharedPreferences에 저장
    notifyListeners();
  }

  // Performance Overlay 상태 변경
  void togglePerformanceOverlay(bool value) {
    showPerformanceOverlay = value;
    _saveToPreferences();
    notifyListeners();
  }

  // Mock Data 상태 변경
  void toggleMockData(bool value) {
    enableMockData = value;
    _saveToPreferences();
    notifyListeners();
  }

  // SharedPreferences에 저장
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('apiLogging', apiLogging);
    prefs.setBool('enableAllowAllCards', enableAllowAllCards);
    prefs.setBool('showPerformanceOverlay', showPerformanceOverlay);
    prefs.setBool('enableMockData', enableMockData);
  }

  // SharedPreferences에서 데이터 불러오기
  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    apiLogging = prefs.getBool('apiLogging') ?? false;
    showPerformanceOverlay = prefs.getBool('showPerformanceOverlay') ?? false;
    enableMockData = prefs.getBool('enableMockData') ?? false;
    notifyListeners(); // 데이터 로드 후 UI 업데이트
  }
}

class LeftDrawerWidget extends ConsumerStatefulWidget {
  const LeftDrawerWidget({super.key});

  @override
  _LeftDrawerWidgetState createState() => _LeftDrawerWidgetState();
}


class _LeftDrawerWidgetState extends ConsumerState<LeftDrawerWidget> {

  @override
  Widget build(BuildContext context) {
    var debugModes = ref.watch(debugModeProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Debugging Options',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.api),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('Show Debug Button'),), 
                Consumer(builder: (context, ref, _) {
                  return Switch(
                    value: debugModes.apiLogging,
                    onChanged: (value) {
                      debugModes.toggleApiLogging(value); // 메서드 호출
                    },
                  );
                }),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.select_all),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('Allow All Cards'),), 
                Consumer(builder: (context, ref, _) {
                  return Switch(
                    value: debugModes.enableAllowAllCards,
                    onChanged: (value) {
                      debugModes.toggleAllowAllCards(value); // 메서드 호출
                    },
                  );
                }),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.speed),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('Show Performance Overlay'),), 
                Consumer(builder: (context, ref, _) {
                  final performanceOverlay =
                      ref.watch(debugModeProvider).showPerformanceOverlay;
                  return Switch(
                    value: debugModes.showPerformanceOverlay,
                    onChanged: (value) {
                      debugModes.togglePerformanceOverlay(value);
                    },
                  );
                }),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text('Enable Mock Data'),), 
                Consumer(builder: (context, ref, _) {
                  return Switch(
                    value: debugModes.enableMockData,
                    onChanged: (value) {
                      debugModes.toggleMockData(value);
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}