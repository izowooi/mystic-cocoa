import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyWidget extends ConsumerStatefulWidget {
  MonthlyWidget({Key? key}) : super(key: key);

  @override
  _MonthlyWidgetState createState() => _MonthlyWidgetState();
}

class _MonthlyWidgetState extends ConsumerState<MonthlyWidget> {
  @override
  void initState() {
    super.initState();
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
            child: Padding(padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 3/4,
                ),
                itemCount: 24,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container( 
                      width: 5,
                      height: 5,
                      //child:  Center(child: Text('Card ${index + 1}'))
                      ),
                  );
                },
              ),
            ),
          ),
          // Spacer
          SizedBox(height: 5),
          // Row with 5 empty cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return Card(
                child: Container(
                  width: 40,
                  height: 60,
                ),
              );
            }),
          ),
          // Spacer
          SizedBox(height: 5),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
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