import firebase_admin
from firebase_admin import credentials, messaging

# Firebase Admin SDK 초기화
cred = credentials.Certificate("../secure/firebase-adminsdk.json")
firebase_admin.initialize_app(cred)


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


# 함수 실행
if __name__ == "__main__":
    notification_title = "titlew"
    notification_text = "textw"
    notification_image = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Tarockkarten_in_der_Hand_eines_Spielers.jpg/440px-Tarockkarten_in_der_Hand_eines_Spielers.jpg"
    notification_topic = "morning_utc9_kr"
    send_fcm_message(notification_title, notification_text, notification_image, notification_topic)