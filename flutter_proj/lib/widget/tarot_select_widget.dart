import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_proj/widget/tarot_result_widget.dart';

class TarotSelectWidget extends StatefulWidget {
  final List<String> imagePaths;
  final List<FlipCardController> controllers;
  final VoidCallback onShuffle;

  TarotSelectWidget({
    required this.imagePaths,
    required this.controllers,
    required this.onShuffle,
  });

  @override
  _TarotSelectWidgetState createState() => _TarotSelectWidgetState();  
}

class _TarotSelectWidgetState extends State<TarotSelectWidget> {
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
                              widget.imagePaths[index],
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
                var tarotList = [
                    TarotCardData(
                      imagePath: 'assets/images/01.jpeg',
                      title: 'The Fool',
                      content: 'This card represents new beginnings and potential.',
                    ),
                ];
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TarotResultWidget(
                    title: '올해의 운세',
                    cardDataList: tarotList,)
                    ),
                );
                widget.onShuffle(); // 돌아왔을 때 셔플 실행
              },
              child: Text('확인하기'),
            ),
            ],
          ),
          // Spacer
          SizedBox(height: 5),
        ],
      );
  }
}