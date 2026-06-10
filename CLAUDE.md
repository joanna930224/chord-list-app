# 프로젝트명

ChordBox

## 프로젝트 개요

기타 코드 운지법 학습 및 보관 앱 (Flutter, iOS/Android)

## 기술 스택

- Flutter SDK: [3.38.2]
- 상태관리: [Riverpod / Provider]
- 로컬 설정 저장: shared_preferences (테마, 햅틱 전용)
- 코드 데이터 DB: drift (sqflite ORM)
- 라우팅: [go_router]

## 디렉토리 구조

```
lib/
├── core/          # 공통 유틸, 상수, 테마, 햅틱
├── data/          # DB, 레포지토리, 데이터소스
├── features/      # 화면별 기능 모듈
└── main.dart
docs/
├── architecture/  # 아키텍처 규칙 (반드시 숙지)
└── work_plan/   # 이슈별 작업 계획 MD
.claude/
└── commands/      # 커스텀 슬래시 커맨드
```

## 아키텍처 규칙

> 작업 전 반드시 `docs/architecture/` 하위 문서를 전부 읽고 숙지할 것.
> 레이어 구조, 네이밍 컨벤션, 파일 위치 규칙은 해당 문서가 기준이며 이 파일보다 우선한다.

## 네이밍 규칙

- 파일명: `snake_case`
- 클래스명: `PascalCase`
- 변수/함수: `camelCase`
- 화면 위젯: `*_screen.dart`
- 재사용 컴포넌트: `*_widget.dart`

## 빌드 & 코드 생성

```bash
flutter run                                                         # 실행
flutter analyze                                                     # 정적 분석
flutter pub run build_runner build --delete-conflicting-outputs     # 코드 생성 (drift 등)
```

## 절대 금지 (NEVER)

- NEVER: Git 커밋 또는 Push를 직접 실행. Git 작업은 반드시 사용자가 직접 한다
- NEVER: `shared_preferences`를 설정값(테마/햅틱) 외 용도로 사용 (필요할시 사용 승인요청)
- NEVER: 사용자 승인 없이 `pubspec.yaml`에 패키지 추가
- NEVER: 내가 승인하지 않은 상태에서 다음 단계로 넘어가는 것
- NEVER: 여러 파일을 한꺼번에 대규모 수정 (단계별로 나눌 것)

## 작업 방식 (필수 준수)

1. 작업 시작 전 반드시 관련 파일 구조 파악 후 나에게 보고
2. 작업은 `docs/work_plan/` 안의 작업 계획 MD를 기준으로 수행
3. 각 단계 완료 후 반드시 멈추고 나의 확인(approve)을 기다릴 것
4. 코드 수정 후 `flutter analyze` 실행하여 오류 없음을 확인하고 보고
5. Git 커밋/Push는 절대 직접 하지 않음 — 사용자가 직접 수행
