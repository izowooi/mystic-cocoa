import json
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# 서비스 계정 인증
try:
    credentials = service_account.Credentials.from_service_account_file(
        'mystic-cocoa-435539be25f8.json',  # 새로 생성한 서비스 계정 파일명으로 변경
        scopes=['https://www.googleapis.com/auth/androidpublisher']
    )

    service = build('androidpublisher', 'v3', credentials=credentials)
except Exception as e:
    print(f"서비스 계정 인증 실패: {str(e)}")
    exit(1)


def verify_and_consume_purchase(package_name, product_id, purchase_token):
    try:
        # 1. 구매 검증
        result = service.purchases().products().get(
            packageName=package_name,
            productId=product_id,
            token=purchase_token
        ).execute()

        # 2. 구매 상태 확인
        if result['purchaseState'] == 0:  # 구매 완료
            # 3. Acknowledge 처리 (필요한 경우)
            if result['acknowledgementState'] == 0:
                service.purchases().products().acknowledge(
                    packageName=package_name,
                    productId=product_id,
                    token=purchase_token
                ).execute()

            # 4. Consume 처리
            if result['consumptionState'] == 0:  # 아직 소비되지 않음
                service.purchases().products().consume(
                    packageName=package_name,
                    productId=product_id,
                    token=purchase_token
                ).execute()

                return True, "Purchase verified and consumed"
        print('Purchase verification result:', json.dumps(result, indent=2))
        return False, "Purchase not valid"

    except Exception as e:
        print('Error during purchase verification:', str(e))
        return False, f"Verification failed: {str(e)}"


      # "packageName": "com.edge.tpb",
      # "productId": "tpb_cash_1",
      # "purchaseTime": 1748936221903,
      # "purchaseState": 0,
      # "purchaseToken": "mjcmaohenfhfnmkmjckpoedi.AO-J1Ox0DSF3KXwWGrjSsVHZrKqSGt3HQo23qPDsdS6xhklugTt5q0-biIi8c045Vo4VyEpJcK3z3bTQPtB9XGbKpt_S5GO4KQ",

productId = 'buy_me_coffee_1000'
packageName = 'com.izowooi.mystic_cocoa'
purchaseToken = 'lbcdaijmaakfdkjpckcmfbbk.AO-J1OylBUEN5FhvoWAYOf7Ut-XpI8oW3rYZeErswxQ_R7XMNkR-NG3UBmZ9g47OUQJZZ4HeG7o2ETsWjwnHFpQ0ZKMOv9xHbPR7YO6efldsVn2f6jnxEKQ'

verify_and_consume_purchase(packageName, productId, purchaseToken)

