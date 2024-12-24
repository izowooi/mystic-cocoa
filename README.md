# mystic-cocoa
AI 타로 카드앱


# git
remote 관련 커맨드
git remote -v
git remote set-url origin git@github.com:izowooi/mystic-cocoa.git

태그 관련 커맨드
git tag
git tag -a v1.0.0 -m "버전 1.0.0 태그 생성"
git push origin v1.0.0
git checkout -b <새브랜치이름> <태그이름>

# fcm
23시에는 utc+0 인 사용자에게 보내야해.
00시에는 utc+1 인 사용자에게 보내야해.
01시에는 utc+2 인 사용자에게 보내야해.
02시에는 utc+3 인 사용자에게 보내야해.
...
...
08시에는 utc+9 인 사용자에게 보내야해.
09시에는 utc+10 인 사용자에게 보내야해.
10시에는 utc+11 인 사용자에게 보내야해.
11시에는 utc-12, utc+12 인 사용자에게 보내야해.
12시에는 utc-11, utc+13 인 사용자에게 보내야해.
13시에는 utc-10, utc+14 인 사용자에게 보내야해.
14시에는 utc-9 인 사용자에게 보내야해.
15시에는 utc-8 인 사용자에게 보내야해.
...
...
20시에는 utc-3 인 사용자에게 보내야해.
21시에는 utc-2 인 사용자에게 보내야해.
22시에는 utc-1 인 사용자에게 보내야해.


