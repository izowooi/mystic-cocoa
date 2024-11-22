import 'package:flutter/material.dart';
import 'package:flutter_proj/widget/loading_widget.dart';

class LoadingTestWidget extends StatelessWidget {
  const LoadingTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 기본 화면
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 텍스트 위
                const Text(
                  '위 텍스트입니다.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 40),
                // 이미지
                Image.asset(
                  'assets/images/01.jpeg',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                // 텍스트 아래
                const Text(
                  '아래 텍스트입니다.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          const LoadingWidget(message: '선택한 카드를 분석 중입니다')
        ],
      ),
    );
  }
}