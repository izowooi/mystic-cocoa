// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:mystic_cocoa/widget/left_drawer_widget.dart';
import 'package:mystic_cocoa/widget/today_widget.dart';
import 'package:mystic_cocoa/widget/monthly_widget.dart';
import 'package:mystic_cocoa/widget/yearly_widget.dart';
import 'package:mystic_cocoa/widget/tarot_result_widget.dart';
import 'package:mystic_cocoa/widget/loading_test_widget.dart';

final navigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화

  final TarotDataController tarotController = TarotDataController();

  // Initialize controller
  await tarotController.initialize();

  // Example usage
  print(tarotController.getWealthInterpretation("00")); // 재물운 해석
  print(tarotController.getMajorArcanaName("01")); // 카드 이름
  print(tarotController.getMinorArcanaName("Wands", 3));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(ProviderScope(child: MainApp()));
  });
  
}

class MainApp extends ConsumerWidget {

  MainApp({super.key});

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

    var tarotList = [
        TarotCardData(
          imagePath: 'assets/images/01.jpeg',
          title: 'The Fool',
          content: 'This card represents new beginnings and potential.',
        ),
        TarotCardData(
          imagePath: 'assets/images/01.jpeg',
          title: 'The Magician',
          content: 'This card signifies power and resourcefulness.',
        ),
        TarotCardData(
          imagePath: 'assets/images/01.jpeg',
          title: 'The High Priestess',
          content: 'This card stands for wisdom and intuition.',
        ),
        TarotCardData(
          imagePath: 'assets/images/01.jpeg',
          title: 'The Empress',
          content: 'This card symbolizes abundance and nurturing.',
        ),
      ];
      return MaterialApp(
      home: Scaffold(
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
            TarotResultWidget(
              title: 'Tarot Result',
              cardDataList: tarotList,
            ),
            //const LoadingTestWidget(),
            
          ],
        ),
      )
    );
  }
}