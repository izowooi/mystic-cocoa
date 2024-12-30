import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.7), // 반투명 배경
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset(
            'assets/images/loading_1.png',
            width: 200,
            height: 400,
            fit: BoxFit.cover,
            ),
          ),
          const Positioned(
              top: 80, // 원하는 만큼 아래로 이동
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 8.0,
              ),
            ),
          // 이미지 배경
          Positioned(
            bottom: 80,
            child: Text(
            message,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),)
        ],
      ),
    );
  }
}