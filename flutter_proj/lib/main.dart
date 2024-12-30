// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystic_cocoa/controller/localize.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:mystic_cocoa/notifier/user_settings_notifier.dart';
import 'package:mystic_cocoa/widget/left_drawer_widget.dart';
import 'package:mystic_cocoa/widget/today_widget.dart';
import 'package:mystic_cocoa/widget/monthly_widget.dart';
import 'package:mystic_cocoa/widget/yearly_widget.dart';
import 'package:mystic_cocoa/widget/settings_widget.dart';


final sceneNameProvider = StateProvider<String>((ref) {
  return "";
});

final navigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화
  String languageCode = await Localize().initialize();

  final TarotDataController tarotController = TarotDataController();
  await Firebase.initializeApp();
  // Initialize controller
  await tarotController.initialize(languageCode);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(ProviderScope(child: MainApp()));
  });
  
}

class MainApp extends ConsumerWidget {

  MainApp({super.key});

  final List<String> sceneNames = ['today', 'monthly', 'yearly', 'settings'];

  // 탭별 색상 설정
  Color getSelectedItemColor(int index) {
    switch (index) {
      case 0:
        return Colors.lightGreen.shade300;
      case 1:
        return Colors.lightBlue.shade300;
      case 2:
        return Colors.yellow.shade300;
      default:
        return Colors.black12;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentPageIndex = ref.watch(navigationIndexProvider);
    final selectedLanguage = ref.watch(userSettingsProvider).locale;
    return MaterialApp(
      home: Builder(builder: (context){
        Locale locale = Localizations.localeOf(context);
        print('Language code: ${locale.languageCode}');
        return Scaffold(
        bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: const Icon(Icons.wb_sunny), label: Localize().get('today_fortune')),
          NavigationDestination(icon: const Icon(Icons.calendar_month), label: Localize().get('monthly_fortune')),
          NavigationDestination(icon: const Icon(Icons.timeline), label: Localize().get('yearly_fortune')),
          NavigationDestination(icon: const Icon(Icons.settings), label: Localize().get('settings')),
        ],
        selectedIndex: currentPageIndex,
        indicatorColor: getSelectedItemColor(currentPageIndex),
        onDestinationSelected: (index) {
            ref.read(sceneNameProvider.notifier).state = sceneNames[index];
            ref.read(navigationIndexProvider.notifier).state = index;
          },
        ),
        
        drawer: LeftDrawerWidget(),
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            TodayWidget(),
            MonthlyWidget(),
            YearlyWidget(),
            SettingsWidget(),
          ],
        ),
      );
    })
    );
  }
}