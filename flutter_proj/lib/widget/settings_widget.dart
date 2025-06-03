import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystic_cocoa/controller/localize.dart';
import 'package:mystic_cocoa/controller/tarot_data_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mystic_cocoa/notifier/user_settings_notifier.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

final languageProvider = StateProvider<String>((ref) {
  return "ko";
});
final fontSizeProvider = StateProvider<double>((ref) {
  return 16;
});
final cardBackProvider = StateProvider<int>((ref) {
  return 0;
});
final supportThanksProvider = StateProvider<bool>((ref) => false);


class SettingsWidget extends ConsumerStatefulWidget {
  SettingsWidget({super.key});

  @override
  ConsumerState<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget> {
  bool _isPermissionGranted = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  static const String _kBuyMeCoffeeId = 'buy_me_coffee_1000';
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription?.cancel();
    _subscription = _inAppPurchase.purchaseStream.listen(_listenToPurchaseUpdated);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // 권한 상태 확인
  Future<void> _checkNotificationPermission() async {
    _isPermissionGranted = await Permission.notification.isGranted;
  }
  
  Future<bool> subscribeToTopic(String topic) async{
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

  Future<void> unsubscribeFromTopic(String topic) async{
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  handlePushToggle(String pushTopic, bool value) async{
    if(value){
      ref.read(userSettingsProvider.notifier).setPush(true);
      bool subscribed = await subscribeToTopic(pushTopic);
      ref.read(userSettingsProvider.notifier).setPush(subscribed);
    } else {
      ref.read(userSettingsProvider.notifier).setPush(false);
      await unsubscribeFromTopic(pushTopic);
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
  
  void _changeLanguage(String locale) async {
    await Localize().loadLocale(locale);
    TarotDataController().initialize(locale);
    ref.read(userSettingsProvider.notifier).setLocale(locale);
  }

  Future<void> _buyCoffee() async {
    print('=== 구매 프로세스 시작 ===');
    print('상품 ID: $_kBuyMeCoffeeId');
    
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({_kBuyMeCoffeeId});
    print('상품 조회 응답: ${response.productDetails.length}개의 상품 발견');
    print('찾지 못한 상품: ${response.notFoundIDs}');
    
    if (response.notFoundIDs.isNotEmpty) {
      print('상품을 찾을 수 없습니다: ${response.notFoundIDs}');
      return;
    }

    if (response.productDetails.isEmpty) {
      print('상품 정보가 없습니다.');
      return;
    }

    print('상품 정보:');
    print('- 상품명: ${response.productDetails.first.title}');
    print('- 가격: ${response.productDetails.first.price}');
    print('- 설명: ${response.productDetails.first.description}');

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: response.productDetails.first,
    );

    try {
      print('구매 요청 시작...');
      // buyNonConsumable() 함수는 구매 프로세스를 시작하고 구매 요청만 합니다.
      // 실제 구매 완료(acknowledge)는 purchaseStream 리스너에서 처리됩니다.
      // 이 함수는 구매 요청이 성공적으로 시작되었는지 여부만 반환합니다.
      // 소비성 아이템이 아닌 경우에만 사용해야 합니다.
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      print('구매 요청 완료');
    } catch (e) {
      print('결제 중 오류 발생: $e');
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print('=== 구매 상태 업데이트 ===');
    print('구매 상세 정보 수: ${purchaseDetailsList.length}');
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('구매 상태: ${purchaseDetails.status}');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('결제 대기 중...');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print('결제 오류: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        print('결제 완료!');
        print('Product ID: ${purchaseDetails.productID}');
        print('Purchase purchaseID: ${purchaseDetails.purchaseID}');
        print('Purchase verificationData: ${purchaseDetails.verificationData}');
        print('Purchase Token: ${purchaseDetails.verificationData.serverVerificationData}');
        print('Signed Data: ${purchaseDetails.verificationData.localVerificationData}');
        print('Signature: ${purchaseDetails.verificationData.source}');
        if (purchaseDetails.productID == _kBuyMeCoffeeId) {
          ref.read(supportThanksProvider.notifier).state = true;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        print('구매 완료 처리 중...');
        // completePurchase()는 구글 결제의 acknowledge(인정) 단계를 처리합니다.
        // 구글 결제는 구매(purchase) -> 인정(acknowledge) -> 소모(consume) 3단계로 진행되며
        // 이 함수 호출을 통해 구매 완료를 구글에 인정하게 됩니다.
        // 인정되지 않은 구매는 3일 후 자동으로 환불됩니다.
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _restorePurchase() async {
    print('=== 구매 복원 시작 ===');
    await _inAppPurchase.restorePurchases();
    // 복원 결과는 purchaseStream(_listenToPurchaseUpdated)에서 처리됨
  }

  @override
  Widget build(BuildContext context) {
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

    _checkNotificationPermission();

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
                _changeLanguage(value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('日本語'),
            value: 'jp',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('中文'),
            value: 'zh',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(value);
              }
            },
          ),
          const Divider(),

          // 푸시 설정
          SwitchListTile(
            title: Text(Localize().get('push_enable')),
            value: pushEnable,
            onChanged: (value) => 
            handlePushToggle(topic, value),
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
            title: Row(
              children: [
                Text(Localize().get('version_info')),
                const SizedBox(width: 8),
                if (ref.watch(supportThanksProvider))
                  const Text('후원해주셔서 감사합니다.', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(),

          // 구매 복원하기 버튼
          ListTile(
            title: const Text('구매 복원하기'),
            subtitle: const Text('이전에 결제한 내역이 있다면 복원할 수 있습니다.'),
            trailing: ElevatedButton(
              onPressed: () {
                print('=== 구매 복원하기 버튼 클릭 ===');
                _restorePurchase();
              },
              child: const Text('복원하기'),
            ),
          ),
          // Buy Me a Coffee 버튼
          ListTile(
            title: const Text('Buy Me a Coffee'),
            subtitle: const Text('개발자에게 커피 한 잔의 후원을 보내주세요!'),
            trailing: ElevatedButton(
              onPressed: () {
                print('=== Buy Me a Coffee 버튼 클릭 ===');
                _buyCoffee();
              },
              child: const Text('1,000원 후원하기'),
            ),
          ),
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