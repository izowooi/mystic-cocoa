import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';


final notificationEnableProvider = StateProvider<bool>((ref) {
  return false;
});
final languageProvider = StateProvider<String>((ref) {
  return "ko";
});
final morningPushProvider = StateProvider<bool>((ref) {
  return false;
});
final lunchPushProvider = StateProvider<bool>((ref) {
  return false;
});
final eveningPushProvider = StateProvider<bool>((ref) {
  return false;
});
final fontSizeProvider = StateProvider<double>((ref) {
  return 16;
});
final cardBackProvider = StateProvider<int>((ref) {
  return 0;
});


class SettingsWidget extends ConsumerWidget {

  SettingsWidget({Key? key}) : super(key: key);
  final String morningTopic = 'morning_utc9_kr';//ex) morning_utc-9_en
  final String lunchTopic = 'lunch_utc9_kr';
  final String eveningTopic = 'evening_utc9_kr';

  bool _isPermissionGranted = false;

  // 권한 상태 확인
  Future<void> _checkNotificationPermission(WidgetRef ref) async {
    _isPermissionGranted = await Permission.notification.isGranted;
    ref.read(notificationEnableProvider.notifier).state = _isPermissionGranted;
  }
  
  Future<bool> subscribeToTopic(String topic, WidgetRef ref) async{
    bool isPermissionGranted = await Permission.notification.isGranted;
    if(!isPermissionGranted){
      final state = await Permission.notification.request();
      if(state.isGranted){
        ref.read(notificationEnableProvider.notifier).state = true;
      } else if(state.isDenied){
        return false;
      } else if(state.isPermanentlyDenied){
        openAppSettings();
        return false;
      }
    }
    FirebaseMessaging.instance.subscribeToTopic(topic);
    return true;
  }

  Future<void> unsubscribeFromTopic(String topic, WidgetRef ref) async{
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  handlePushToggle(String pushTopic, StateProvider pushProvider, bool value, WidgetRef ref) async{
    if(value){
      ref.read(pushProvider.notifier).state = true;
      bool subscribed = await subscribeToTopic(pushTopic, ref);
      ref.read(pushProvider.notifier).state = subscribed;
    } else {
      ref.read(pushProvider.notifier).state = false;
      await unsubscribeFromTopic(pushTopic, ref);
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationEnable = ref.watch(notificationEnableProvider);
    final language = ref.watch(languageProvider);
    final morningPush = ref.watch(morningPushProvider);
    final lunchPush = ref.watch(lunchPushProvider);
    final eveningPush = ref.watch(eveningPushProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final cardBack = ref.watch(cardBackProvider);
    
    _checkNotificationPermission(ref);

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
            value: notificationEnable && morningPush,
            onChanged: (value) => 
            handlePushToggle(morningTopic, morningPushProvider, value, ref),
          ),
          SwitchListTile(
            title: const Text('점심 푸시 설정'),
            value: notificationEnable && lunchPush,
            onChanged: (value) =>
            handlePushToggle(lunchTopic, lunchPushProvider, value, ref),
          ),
          SwitchListTile(
            title: const Text('저녁 푸시 설정'),
            value: notificationEnable && eveningPush,
            onChanged: (value) =>
            handlePushToggle(eveningTopic, eveningPushProvider, value, ref),
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
                        color: cardBack == index ? Colors.blue : Colors.transparent,
                        width: 6,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/card_back_$index.png'),
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