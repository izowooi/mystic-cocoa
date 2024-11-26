import 'package:flutter/material.dart';

class TarotResultWidget extends StatelessWidget {
  final String title; // 결과 화면의 제목
  final List<TarotCardData> cardDataList; // 사용자가 고른 카드 데이터 리스트

  const TarotResultWidget({
    required this.title,
    required this.cardDataList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarot Result"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 상단 제목
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/love.jpeg',
              fit: BoxFit.cover,
              ),
            ),

            // 사용자가 고른 카드 설명
            ...cardDataList.map((cardData) => TarotCardDescription(data: cardData)).toList(),
          ],
        ),
      ),
    );
  }
}

class TarotCardDescription extends StatelessWidget {
  final TarotCardData data;

  const TarotCardDescription({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카드 이미지
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Image.asset(data.imagePath,
              fit: BoxFit.cover,),
            ),

            const SizedBox(height: 8.0),

            // 카드 제목
            Text(
              data.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8.0),

            // 카드 내용
            Text(
              data.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class TarotCardData {
  final String imagePath;
  final String title;
  final String content;

  TarotCardData({
    required this.imagePath,
    required this.title,
    required this.content,
  });
}