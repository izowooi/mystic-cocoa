import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:mystic_cocoa/widget/loading_overlay.dart';
import 'tarot_select_widget.dart';

class YearlyWidget extends ConsumerStatefulWidget {
  YearlyWidget({Key? key}) : super(key: key);

  @override
  _YearlyWidgetState createState() => _YearlyWidgetState();
}

class _YearlyWidgetState extends ConsumerState<YearlyWidget> {
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
        interpretationProvider.overrideWithValue((String cardIndex, int index) => TarotDataController().getYearlyInterpretation(cardIndex, index)),
      ],
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('올해의 타로 운세'),
              backgroundColor: Colors.yellow.shade100,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow.shade100, Colors.yellow.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: TarotSelectWidget(
                appBarTitle: '올해의 타로 운세',
                titlePath: 'assets/images/adult_magician.jpeg',
                pickMessage: ['재물운 카드를 1개 골라주세요 ( 1|4 )', '건강운 카드를 1개 골라주세요 ( 2|4 )', '연애운 카드를 1개 골라주세요 ( 3|4 )', '직장운 카드를 1개 골라주세요 ( 4|4 )', ].toList(),
                cardIndex: cardIndex,
                controllers: controllers,
                onShuffle: shuffleImages,
                maxSelectableCards: 4,
              ),
            ),
          ),
          if (showLoadingOverlay)
            const LoadingOverlay(), // 로딩 화면 위젯
        ],
      )
    );
  }
}