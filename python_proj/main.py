print('hello world')


def process_file(input_file, output_file):
    with open(input_file, "r", encoding="utf-8") as infile, open(output_file, "w", encoding="utf-8") as outfile:
        result_lines = []  # 최종 결과를 저장할 리스트
        current_card = []  # "오늘의 카드:"를 포함한 현재 카드 내용

        for line in infile:
            # 1. 따옴표 치환
            line = line.replace('"', '\\"')
            # 2. 탭 치환
            line = line.replace("\t", " ")
            # 3. "오늘의 카드:" 확인
            if "오늘의 카드:" in line:
                # 이전 카드 내용이 있으면 합쳐서 저장
                if current_card:
                    result_lines.append("".join(current_card) + "\n")
                    current_card = []
                # 새로운 카드 시작
                current_card.append(line.strip())
            else:
                # "오늘의 카드:"가 없으면 맨 앞에 "\n" 추가
                current_card.append("\\n" + line.strip())

        # 마지막 카드 처리
        if current_card:
            result_lines.append("".join(current_card) + "\n")

        # 4. 결과를 합치고 파일로 저장
        outfile.writelines(result_lines)


# 실행 예제
input_file = "/Users/izowooi/Downloads/temp/input.txt"  # 입력 파일 경로
output_file = "/Users/izowooi/Downloads/temp/output.txt"  # 출력 파일 경로
process_file(input_file, output_file)