// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Curious_Cookie/controller/user_settings_notifier.dart';
import 'package:Curious_Cookie/model/user_settings.dart';
import 'package:Curious_Cookie/widget/setting_widget.dart';
import 'package:Curious_Cookie/widget/home_widget.dart';
import 'package:Curious_Cookie/widget/story_widget.dart';

final navigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(const ProviderScope(child: MainApp()));
  });
  
}

class MainApp extends ConsumerWidget {

  MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = ref.watch(navigationIndexProvider);

      return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Quiz'),
          NavigationDestination(icon: Icon(Icons.info), label: 'News'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
        },
        ),
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            MonthlyWidget(),
            YearlyWidget(),
            TodayWidget(),
            SettingsWidget(),
          ],
        ),
      )
    );
  }
}