import json
import os
import firebase_admin
from firebase_admin import credentials, messaging
from datetime import datetime
import random



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
def convert_hour_to_utc(current_hour):
    ret_utc_offset = []
    # UTC 오프셋 계산
    utc_offset = current_hour + 1
    if utc_offset > 14:
        utc_offset -= 24
    #ret.append(f"morning_utc{utc_offset}_kr")
    ret_utc_offset.append(utc_offset)

    if 11 <= current_hour <= 13:
        utc_offset -= 24
        #ret.append(f"morning_utc{utc_offset}_kr")
        ret_utc_offset.append(utc_offset)

    return ret_utc_offset



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
    utc_offsets = convert_hour_to_utc(current_hour)
    valid_language = ["ko", "en", "jp", "zh", "ar"]
    title_dict = {}
    message_dict = {}
    random_num = f"{random.randint(0, 19):02}"

    #   valid_language 의 내용을 순회하면서 fcm_message_{language}.json 파일을 읽어서 title_dict, message_dict에 저장
    #이 때 키값은 language 가 된다.
    for language in valid_language:
        with open(f"fcm_title_{language}.json", "r", encoding="utf-8") as infile:
            data = json.load(infile)
            title_dict[language] = data

        with open(f"fcm_message_{language}.json", "r", encoding="utf-8") as infile:
            data = json.load(infile)
            message_dict[language] = data

    for language in valid_language:
        print(f"language: {language}, title: {title_dict[language][random_num]}, message: {message_dict[language]["00"]}")


    for utc_offset in utc_offsets:
        for language in valid_language:
            topic = f"aos_utc{utc_offset}_{language}"
            title_text = title_dict[language][random_num]
            message_text = message_dict[language][random_num]
            print(f"utc_offset:{utc_offset}, topic: {topic}, title: {title_text}, message: {message_text}")
            #"aos_utc{utc_offset}_kr")
            send_fcm_message(title_text, message_text, notification_image, topic)