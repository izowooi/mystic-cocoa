import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_proj/controller/tarot_data_controller.dart';
import 'tarot_select_widget.dart';

class TodayWidget extends ConsumerStatefulWidget {
  TodayWidget({Key? key}) : super(key: key);

  @override
  _TodayWidgetWidgetState createState() => _TodayWidgetWidgetState();
}

class _TodayWidgetWidgetState extends ConsumerState<TodayWidget> {
  List<String> cardIndex = List.generate(
    24,
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
    return ProviderScope(
      overrides: [
        interpretationProvider.overrideWithValue((String cardIndex, int index) => TarotDataController().getTodayInterpretation(cardIndex, index)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('오늘의 타로 운세'),
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
            pickMessage: '신중하게 카드 1개를 골라주세요',
            cardIndex: cardIndex,
            controllers: controllers,
            onShuffle: shuffleImages,
            maxSelectableCards: 1,
          ),
        ),
      ),
    );
  }
}