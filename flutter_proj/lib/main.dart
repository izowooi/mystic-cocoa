// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_proj/widget/monthly_widget.dart';

final navigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(ProviderScope(child: MainApp()));
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
          NavigationDestination(icon: Icon(Icons.snowing), label: '올해의 운세'),
          NavigationDestination(icon: Icon(Icons.snowshoeing), label: '12월'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: '오늘의 운세'),
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
        },
        ),
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            MonthlyWidget(),
            MonthlyWidget(),
            MonthlyWidget(),
            MonthlyWidget(),
          ],
        ),
      )
    );
  }
}