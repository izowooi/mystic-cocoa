import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyWidget extends ConsumerStatefulWidget {

  MonthlyWidget({
    Key? key
  }) : super(key: key);

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
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(6.0),
                //color: Colors.blueAccent,
                child: Text(
                  "test",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}