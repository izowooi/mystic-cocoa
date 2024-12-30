import 'package:flutter/material.dart';
import 'package:mystic_cocoa/widget/tarot_result_widget.dart';

class TarotActionButtons extends StatelessWidget {
  final VoidCallback onShuffle;
  final List<TarotCardData> selectedCards;
  final VoidCallback onClearSelection;

  const TarotActionButtons({
    super.key,
    required this.onShuffle,
    required this.selectedCards,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Spacer
        const SizedBox(height: 5),
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onShuffle,
              child: const Text('셔플'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TarotResultWidget(
                      title: '올해의 운세',
                      titlePath: 'assets/images/child_magician.jpeg',
                      cardDataList: selectedCards,
                    ),
                  ),
                );
                onShuffle(); // 돌아왔을 때 셔플 실행
                onClearSelection(); // selectedCards 초기화
              },
              child: const Text('확인하기'),
            ),
          ],
        ),
        // Spacer
        const SizedBox(height: 5),
      ],
    );
  }
}