import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'tarot_select_widget.dart';

class MonthlyWidget extends ConsumerStatefulWidget {
  MonthlyWidget({Key? key}) : super(key: key);

  @override
  _MonthlyWidgetState createState() => _MonthlyWidgetState();
}

class _MonthlyWidgetState extends ConsumerState<MonthlyWidget> {
  List<String> imagePaths = List.generate(
    24,
    (index) => 'assets/images/major_arcana_${index.toString().padLeft(2, '0')}.jpeg',
  );

  List<FlipCardController> controllers = List.generate(24, (_) => FlipCardController());

  @override
  void initState() {
    super.initState();
    imagePaths.shuffle(); // 초기화 시 리스트를 섞습니다.
  }

  void shuffleImages() async{
    for (var controller in controllers) {
      if (controller.state?.isFront == false) {
        await controller.flipcard(); // 플립된 카드를 원래대로 되돌립니다.
      }
    }
    setState(() {
      imagePaths.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MisticCocoa'),
      ),
      body: TarotSelectWidget(
        imagePaths: imagePaths,
        controllers: controllers,
        onShuffle: shuffleImages,
      ),
    );
  }
}