import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystic_cocoa/controller/localize.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mystic_cocoa/notifier/user_settings_notifier.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

final languageProvider = StateProvider<String>((ref) {
  return "ko";
});
final fontSizeProvider = StateProvider<double>((ref) {
  return 16;
});
final cardBackProvider = StateProvider<int>((ref) {
  return 0;
});


class SettingsWidget extends ConsumerWidget {

  SettingsWidget({super.key});

  bool _isPermissionGranted = false;

  // 권한 상태 확인
  Future<void> _checkNotificationPermission(WidgetRef ref) async {
    _isPermissionGranted = await Permission.notification.isGranted;
  }
  
  Future<bool> subscribeToTopic(String topic, WidgetRef ref) async{
    bool isPermissionGranted = await Permission.notification.isGranted;
    if(!isPermissionGranted){
      final state = await Permission.notification.request();
      if(state.isGranted){
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

  handlePushToggle(String pushTopic, bool value, WidgetRef ref) async{
    if(value){
      ref.read(userSettingsProvider.notifier).setPush(true);
      bool subscribed = await subscribeToTopic(pushTopic, ref);
      ref.read(userSettingsProvider.notifier).setPush(subscribed);
    } else {
      ref.read(userSettingsProvider.notifier).setPush(false);
      await unsubscribeFromTopic(pushTopic, ref);
    }
  }

  Future<void> _sendCustomEvent() async {
    print("Custom event sent! begin");
    await FirebaseAnalytics.instance.logEvent(
      name: 'custom_event',
      parameters: {
        'user_id': '12345',
        'event_description': 'This is a custom event',
      },
    );
    print("Custom event sent! end");
  }
  
  void _changeLanguage(WidgetRef ref, String locale) async {
    await Localize().loadLocale(locale);
    TarotDataController().initialize(locale);
    ref.read(userSettingsProvider.notifier).setLocale(locale);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(fontSizeProvider);
    final cardBack = ref.watch(userSettingsProvider).cardIndex; 
    var videoEnable = ref.watch(userSettingsProvider).autoPlay;
    final selectedLanguage = ref.watch(userSettingsProvider).locale;
    final pushEnable = ref.watch(userSettingsProvider).push;


    // 현재 타임존 오프셋을 가져와서 UTC 오프셋을 계산
    final timeZoneOffset = DateTime.now().timeZoneOffset;
    final hoursOffset = timeZoneOffset.inHours;
    //aos_utc9_ko, aos_utc-9_en
    var topic = 'aos_utc${hoursOffset}_$selectedLanguage';

    print('build()->topic: $topic');

    _checkNotificationPermission(ref);

    return Scaffold(
      appBar: AppBar(
        title: Text(Localize().get('settings')),
      ),
      body: ListView(
        children: [
ListTile(
            title: Text(Localize().get('language_select')),
          ),
          RadioListTile<String>(
            title: const Text('한국어'),
            value: 'ko',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(ref, value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(ref, value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('日本語'),
            value: 'jp',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(ref, value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('中文'),
            value: 'zh',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(ref, value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(ref, value);
              }
            },
          ),
          const Divider(),

          // 푸시 설정
          SwitchListTile(
            title: Text(Localize().get('push_enable')),
            value: pushEnable,
            onChanged: (value) => 
            handlePushToggle(topic, value, ref),
          ),
          const Divider(),

          // // 글자 크기 조정
          // ListTile(
          //   title: const Text('글자 크기 조정'),
          //   subtitle: Slider(
          //     value: fontSize,
          //     min: 1,
          //     max: 100,
          //     divisions: 99,
          //     label: fontSize.toStringAsFixed(0),
          //     onChanged: (value) =>
          //         ref.read(fontSizeProvider.notifier).state = value,
          //   ),
          // ),
          // const Divider(),

          // 동영상 자동 재생 모드
          SwitchListTile(
            title: Text(Localize().get('auto_play_video')),
            value: videoEnable,
            onChanged: (value) => ref.read(userSettingsProvider.notifier).setAutoPlay(value),
          ),
          const Divider(),

          // 카드 뒷면 선택
          ListTile(
            title: Text(Localize().get('choose_card_back')),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => GestureDetector(
                  onTap: () => {
                    ref.read(cardBackProvider.notifier).state = index,
                    ref.read(userSettingsProvider.notifier).setCardIndex(index),
                  },  
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
          // 버전 정보
          ListTile(
            title: Text(Localize().get('version_info')),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(),

          // const Divider(),
          // ListTile(
          //   title: const Text('test button 1'),
          //   subtitle: ElevatedButton(onPressed: (){
          //     print('hello 1');
          //     Localize().initialize('ko');
          //   }, child: Text('button 1')),
          // ),
          // ListTile(
          //   title: const Text('test button 2'),
          //   subtitle: ElevatedButton(onPressed: (){
          //     var start = Localize().get('start');
          //     print('hello 2 : $start');
          //   }, child: Text('button 2')),
          // )
        ],
      ),
    );
    
  }
}