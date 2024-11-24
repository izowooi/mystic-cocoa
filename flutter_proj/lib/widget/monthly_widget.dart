import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

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
        await controller.flipcard();
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
      body: Column(
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
                  final controller = controllers[index];
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
                              imagePaths[index],
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
                onPressed: shuffleImages,
                child: Text('셔플'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('확인하기'),
              ),
            ],
          ),
          // Spacer
          SizedBox(height: 5),
        ],
      ),
    );
  }
}