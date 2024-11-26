import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_proj/widget/tarot_result_widget.dart';
import 'package:flutter_proj/controller/tarot_data_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for the interpretation function
final interpretationProvider = Provider<Function(String, int)>((ref) {
  return (String cardIndex,int index) => TarotDataController().getYearlyInterpretation(cardIndex, index);
});

class TarotSelectWidget extends ConsumerStatefulWidget {
  final List<String> cardIndex;
  final List<FlipCardController> controllers;
  final VoidCallback onShuffle;

  TarotSelectWidget({
    required this.cardIndex,
    required this.controllers,
    required this.onShuffle,
  });

  @override
  _TarotSelectWidgetState createState() => _TarotSelectWidgetState();  
}

class _TarotSelectWidgetState extends ConsumerState<TarotSelectWidget> {
  List<TarotCardData> selectedCards = [];

  void _selectCard(int index) {
    final cardIndex = widget.cardIndex[index];
    final cardPath = 'assets/images/major_arcana_$cardIndex.jpeg';
    final cardTitle = TarotDataController().getMajorArcanaName(cardIndex);
    final cardContent = ref.read(interpretationProvider)(cardIndex, index);

    setState(() {
      selectedCards.add(
        TarotCardData(
        imagePath: cardPath,
        title: cardTitle,
        content: cardContent,)
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card Image
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset('assets/images/01.jpeg',
            width: 50,
            height: 90,),
          ),
          // Instruction Text
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "신중하게 카드 5개를 골라주세요",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          // GridView with 24 cards
          Expanded(
            flex: 5,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal:4.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: 24,
                itemBuilder: (context, index) {
                  final controller = widget.controllers[index];
                  return Padding(
                    padding: const EdgeInsets.all(1.0), // 여백 추가
                    child: GestureDetector(
                      onTap: () {
                        controller.flipcard();
                        _selectCard(index);
                      },
                      child: FlipCard(
                        controller: controller,
                        rotateSide: RotateSide.right,
                        frontWidget: Card(
                          color: Colors.blue,
                          child: Center(child: Image.asset(
                            'assets/images/back_of_card_1.jpeg',
                            fit: BoxFit.fill)
                          ),
                        ),
                        backWidget: Card(
                          child: Center(
                            child: Image.asset(
                              'assets/images/major_arcana_${widget.cardIndex[index]}.jpeg',
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
          // Spacer
          SizedBox(height: 5),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onShuffle,
                child: Text('셔플'),
              ),
              ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TarotResultWidget(
                    title: '올해의 운세',
                    cardDataList: selectedCards,)
                    ),
                );
                widget.onShuffle(); // 돌아왔을 때 셔플 실행
                setState(() {
                  selectedCards.clear(); // selectedCards 초기화
                });
              },
              child: const Text('확인하기'),
            ),
            ],
          ),
          // Spacer
          SizedBox(height: 5),
        ],
      );
  }
}