import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:mystic_cocoa/controller/localize.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:mystic_cocoa/widget/loading_overlay.dart';
import 'tarot_select_widget.dart';

class MonthlyWidget extends ConsumerStatefulWidget {
  MonthlyWidget({Key? key}) : super(key: key);

  @override
  _MonthlyWidgetState createState() => _MonthlyWidgetState();
}

class _MonthlyWidgetState extends ConsumerState<MonthlyWidget> {
  List<String> cardIndex = List.generate(
    22,
    (index) => index.toString().padLeft(2, '0'),
  );

  List<FlipCardController> controllers = List.generate(24, (_) => FlipCardController());

  @override
  void initState() {
    super.initState();
    cardIndex.shuffle(); // 초기화 시 리스트를 섞습니다.
  }

  void shuffleImages() async{
    for (var controller in controllers) {
      if (controller.state?.isFront == false) {
        await controller.flipcard(); // 플립된 카드를 원래대로 되돌립니다.
      }
    }
    setState(() {
      cardIndex.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showLoadingOverlay = ref.watch(isLoading);

    return ProviderScope(
      overrides: [
        interpretationProvider.overrideWithValue((String cardIndex, int index) => TarotDataController().getMonthlyInterpretation(cardIndex, index)),
      ],
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(Localize().get('monthly_tarot_fortune')),
              backgroundColor: Colors.lightBlue.shade100,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: TarotSelectWidget(
                appBarTitle: Localize().get('monthly_tarot_fortune'),
                titlePath: 'assets/images/teenage_magician.jpeg',
                pickMessage: [Localize().get('choose_carefully_one_card'), ].toList(),
                cardIndex: cardIndex,
                controllers: controllers,
                onShuffle: shuffleImages,
                maxSelectableCards: 1,
              ),
            ),
          ),
          if (showLoadingOverlay)
            const LoadingOverlay(), // 로딩 화면 위젯
        ]
      )
    );
  }
}