import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:mystic_cocoa/widget/tarot_result_widget.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystic_cocoa/widget/left_drawer_widget.dart';
import 'package:mystic_cocoa/widget/tarot_action_buttons.dart';

// Define a provider for the interpretation function
final interpretationProvider = Provider<Function(String, int)>((ref) {
  return (String cardIndex,int index) => TarotDataController().getYearlyInterpretation(cardIndex, index);
});

class TarotSelectWidget extends ConsumerStatefulWidget {
  final String titlePath;
  final String pickMessage;
  final List<String> cardIndex;
  final List<FlipCardController> controllers;
  final VoidCallback onShuffle;
  final int maxSelectableCards;

  TarotSelectWidget({
    required this.titlePath,
    required this.pickMessage,
    required this.cardIndex,
    required this.controllers,
    required this.onShuffle,
    required this.maxSelectableCards,
  });

  @override
  _TarotSelectWidgetState createState() => _TarotSelectWidgetState();  
}

class _TarotSelectWidgetState extends ConsumerState<TarotSelectWidget> {
  List<TarotCardData> selectedCards = [];

  bool _isMaxSelectable() {
    if(ref.read(debugModeProvider).enableAllowAllCards) {
      return false;
    }
    return selectedCards.length >= widget.maxSelectableCards;
  }
  // 최대 선택 개수를 초과하면 AlertDialog를 보여줍니다.
  void showMaxSelectionDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('😊주의'),
          content: Text('최대 ${widget.maxSelectableCards}개의 카드만 선택할 수 있습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('✅확인'),
            ),
          ],
        );
      },
    );
  }
  
  void _selectCard(int index) {
    final cardIndex = widget.cardIndex[index];
    final cardPath = 'assets/images/major_arcana_$cardIndex.jpeg';
    final cardTitle = TarotDataController().getMajorArcanaName(cardIndex);
    final cardContent = ref.read(interpretationProvider)(cardIndex, selectedCards.length);

    setState(() {
      selectedCards.add(
        TarotCardData(
        imagePath: cardPath,
        title: cardTitle,
        content: cardContent,)
      );
    });
  }
  
  void _clearSelection() {
    setState(() {
      selectedCards.clear();
    });
  }
  
  void _onFlipEnd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TarotResultWidget(
          title: '올해의 운세',
          cardDataList: selectedCards,
        ),
      ),
    );
    widget.onShuffle(); // 돌아왔을 때 셔플 실행
    _clearSelection(); // selectedCards 초기화
  }

  @override
  Widget build(BuildContext context) {
    final debugModes = ref.watch(debugModeProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Card Image
        // Padding(
        //   padding: const EdgeInsets.all(1.0),
        //   child: Image.asset(widget.titlePath,
        //   width: 300,
        //   height: 90,),
        // ),
        // Instruction Text
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            widget.pickMessage,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        // GridView with 24 cards
        Expanded(
          flex: 5,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal:4.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 3 / 4,
              ),
              itemCount: 22,
              itemBuilder: (context, index) {
                final controller = widget.controllers[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0), // 여백 추가
                  child: GestureDetector(
                    onTap: () {
                      if (_isMaxSelectable()) {
                        showMaxSelectionDialog();
                        return;
                      }

                      controller.flipcard();
                      _selectCard(index);
                      if (selectedCards.length == widget.maxSelectableCards) {
                        Future.delayed(const Duration(milliseconds: 1500), () => _onFlipEnd());
                      }
                    },
                    child: FlipCard(
                      controller: controller,
                      rotateSide: RotateSide.right,
                      animationDuration: const Duration(milliseconds: 300),
                      frontWidget: Card(
                        margin: EdgeInsets.zero,
                        child: Center(child: Image.asset(
                          'assets/images/back_of_card_1.jpeg',
                          //height: 80.0,
                          width: 100.0,
                          fit: BoxFit.cover)
                        ),
                      ),
                      backWidget: Card(
                        margin: EdgeInsets.zero,
                        child: Center(
                          child: Image.asset(
                            'assets/images/major_arcana_${widget.cardIndex[index]}.jpeg',
                            width: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // TarotActionButtons 위젯 사용
        if (debugModes.apiLogging) // 디버그 모드가 켜져 있을 때만 노출
          TarotActionButtons(
            onShuffle: widget.onShuffle,
            selectedCards: selectedCards,
            onClearSelection: _clearSelection,
          ),
      ],
    );
  }
}