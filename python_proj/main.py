import os
import firebase_admin
from firebase_admin import credentials, messaging
from datetime import datetime


# Firebase Admin SDK 초기화
def initialize_firebase():
    # 환경변수에서 경로 가져오기
    service_account_path = os.getenv("FIREBASE_ADMIN_SDK", "../secure/firebase-adminsdk.json")

    print(f"Initializing Firebase with service account: {service_account_path}")
    # Firebase Admin SDK 초기화
    try:
        cred = credentials.Certificate(service_account_path)
        firebase_admin.initialize_app(cred)
        print(f"Firebase initialized with service account: {service_account_path}")
    except Exception as e:
        print(f"Error initializing Firebase with path {service_account_path}: {e}")
        raise e


# FCM 메시지 전송 함수
def send_fcm_message(notification_title, notification_text, notification_image, notification_topic):
    message = messaging.Message(
        notification=messaging.Notification(
            title=notification_title,
            body=notification_text,
            image=notification_image
        ),
        topic=notification_topic,
    )

    try:
        # FCM 메시지 전송
        response = messaging.send(message)
        print(f"Successfully sent message: {response}")
    except Exception as e:
        print(f"Error sending message: {e}")


# 시간에 따른 UTC 토픽 계산
def calculate_utc_topics(current_hour):
    ret = []
    # UTC 오프셋 계산
    utc_offset = current_hour + 1
    if utc_offset > 14:
        utc_offset -= 24
    ret.append(f"morning_utc{utc_offset}_kr")

    if 11 <= current_hour <= 13:
        utc_offset -= 24
        ret.append(f"morning_utc{utc_offset}_kr")

    return ret



# 함수 실행
if __name__ == "__main__":
    # Firebase 초기화
    initialize_firebase()

    # 현재 시간을 기준으로 UTC 오프셋 계산
    now = datetime.now()
    current_hour = now.hour  # 현재 시간 (0~23)

    notification_title = "title"
    notification_text = "text"
    notification_image = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Tarockkarten_in_der_Hand_eines_Spielers.jpg/440px-Tarockkarten_in_der_Hand_eines_Spielers.jpg"
    notification_topics = calculate_utc_topics(current_hour)

    for notification_topic in notification_topics:
        print(f"Sending FCM to topic: {notification_topic}")
        #send_fcm_message(notification_title, notification_text, notification_image, notification_topic)