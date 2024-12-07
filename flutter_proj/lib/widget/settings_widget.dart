import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = StateProvider<String>((ref) {
  return "ko";
});
final morningPushProvider = StateProvider<bool>((ref) {
  return true;
});
final lunchPushProvider = StateProvider<bool>((ref) {
  return true;
});
final eveningPushProvider = StateProvider<bool>((ref) {
  return true;
});
final fontSizeProvider = StateProvider<double>((ref) {
  return 16;
});
final cardBackProvider = StateProvider<int>((ref) {
  return 0;
});

class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final morningPush = ref.watch(morningPushProvider);
    final lunchPush = ref.watch(lunchPushProvider);
    final eveningPush = ref.watch(eveningPushProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final cardBack = ref.watch(cardBackProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 언어 설정
          ListTile(
            title: const Text('언어 설정'),
            subtitle: Text(language),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['ko', 'en', 'ja']
                        .map(
                          (lang) => ListTile(
                            title: Text(lang),
                            onTap: () {
                              ref.read(languageProvider.notifier).state = lang;
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
          const Divider(),

          // 푸시 설정
          SwitchListTile(
            title: const Text('아침 푸시 설정'),
            value: morningPush,
            onChanged: (value) =>
                ref.read(morningPushProvider.notifier).state = value,
          ),
          SwitchListTile(
            title: const Text('점심 푸시 설정'),
            value: lunchPush,
            onChanged: (value) =>
                ref.read(lunchPushProvider.notifier).state = value,
          ),
          SwitchListTile(
            title: const Text('저녁 푸시 설정'),
            value: eveningPush,
            onChanged: (value) =>
                ref.read(eveningPushProvider.notifier).state = value,
          ),
          const Divider(),

          // 글자 크기 조정
          ListTile(
            title: const Text('글자 크기 조정'),
            subtitle: Slider(
              value: fontSize,
              min: 1,
              max: 100,
              divisions: 99,
              label: fontSize.toStringAsFixed(0),
              onChanged: (value) =>
                  ref.read(fontSizeProvider.notifier).state = value,
            ),
          ),
          const Divider(),

          // 버전 정보
          ListTile(
            title: const Text('버전 정보'),
            subtitle: Text('1.0.0'),
          ),
          const Divider(),

          // 카드 뒷면 선택
          ListTile(
            title: const Text('카드 뒷면 선택'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => GestureDetector(
                  onTap: () =>
                      ref.read(cardBackProvider.notifier).state = index,
                  child: Container(
                    width: 50,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: cardBack == index ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/card_back_$index.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}