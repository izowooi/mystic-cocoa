import 'package:flutter/material.dart';

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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

          // 로딩 위젯
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5), // 반투명 배경
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 첫 번째 이미지
                  Image.asset(
                    'assets/images/01.jpeg',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 16),
                  // 두 번째 이미지와 텍스트
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // 이미지 배경
                      Image.asset(
                        'assets/images/loading.jpeg',
                        width: 200,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                      // 텍스트
                      const Text(
                        '로딩 중...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}