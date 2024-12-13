import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TarotResultWidget extends StatelessWidget {
  final String title; // 결과 화면의 제목
  final String titlePath; // 결과 화면의 이미지 경로
  final List<TarotCardData> cardDataList; // 사용자가 고른 카드 데이터 리스트

  const TarotResultWidget({
    required this.title,
    required this.titlePath,
    required this.cardDataList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                titlePath,
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

class TarotCardDescription extends StatefulWidget {
  final TarotCardData data;

  const TarotCardDescription({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _TarotCardDescriptionState createState() => _TarotCardDescriptionState();
}

class _TarotCardDescriptionState extends State<TarotCardDescription>{
  
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // 동영상 경로를 사용하여 컨트롤러 초기화
    _controller = VideoPlayerController.asset(widget.data.videoPath)
      ..initialize().then((_) {
        setState(() {
        });
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
        // 초기에는 play()를 호출하지 않음 -> 탭할 때 play() 진행
      }).catchError((error) {
        debugPrint('Video initialization error: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isInitialized) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }

      setState(() {}); // UI 갱신
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.data.videoPath),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 동영상 재생
            GestureDetector(
              onTap: _togglePlayPause,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: AspectRatio(
                  aspectRatio: _controller.value.isInitialized
                      ? _controller.value.aspectRatio
                      : 9 / 16, // 세로 비율 유지
                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : const Center(child: CircularProgressIndicator()), // 로딩 중
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // 카드 제목
            Text(
              widget.data.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),

            // 카드 내용
            Text(
              widget.data.content,
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
  final String videoPath; // 동영상 경로 추가
  final String title;
  final String content;

  TarotCardData({
    required this.imagePath,
    required this.videoPath,
    required this.title,
    required this.content,
  });
}