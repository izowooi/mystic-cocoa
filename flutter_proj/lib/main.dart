// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:mystic_cocoa/widget/left_drawer_widget.dart';
import 'package:mystic_cocoa/widget/today_widget.dart';
import 'package:mystic_cocoa/widget/monthly_widget.dart';
import 'package:mystic_cocoa/widget/yearly_widget.dart';
import 'package:mystic_cocoa/widget/settings_widget.dart';
import 'dart:io';

final sceneNameProvider = StateProvider<String>((ref) {
  return "";
});

final navigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화
  final String defaultLocale = Platform.localeName;
  print('Default locale: $defaultLocale');

  final TarotDataController tarotController = TarotDataController();
  await Firebase.initializeApp();
  // Initialize controller
  await tarotController.initialize();

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

    return MaterialApp(
      home: Builder(builder: (context){
        Locale locale = Localizations.localeOf(context);
        print('Language code: ${locale.languageCode}');
        return Scaffold(
        bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.wb_sunny), label: '오늘의 운세'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: '이달의 운세'),
          NavigationDestination(icon: Icon(Icons.timeline), label: '올해의 운세'),
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
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