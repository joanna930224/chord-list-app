# Issue #21 - Google Analytics 설정

## 이슈 요약

> Firebase Analytics를 Flutter 앱(iOS/Android)에 연동하여 사용자 행동 데이터를 수집할 수 있도록 설정한다.

---

## 관련 파일

**기존 파일 (수정)**
- `lib/core/initialization.dart` — `Firebase.initializeApp()` 호출 추가
- `android/build.gradle` — google-services classpath 추가
- `android/app/build.gradle` — google-services plugin 적용

**신규 파일 (생성)**
- `lib/shared/providers/analytics_provider.dart` — `FirebaseAnalytics` 인스턴스 Provider
- `ios/Runner/GoogleService-Info.plist` — Firebase iOS 설정 파일
- `android/app/google-services.json` — Firebase Android 설정 파일

**패키지 추가 필요 (사용자 승인 필요)**
- `firebase_core` — Firebase 초기화
- `firebase_analytics` — Analytics 이벤트 수집

---

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지

---

## 작업 단계

### Phase 1: Firebase 콘솔 설정 + 플랫폼 설정 파일 추가

**목표:** Firebase 프로젝트를 생성하고 iOS/Android 앱을 등록한 뒤, 설정 파일을 프로젝트에 추가한다. 코드 변경 없이 빌드 환경을 준비한다.

> 아래 작업은 `flutterfire configure` CLI를 사용하면 대부분 자동화할 수 있다.
> 수동 진행 시 순서대로 따른다.

**Firebase 콘솔 작업 (수동):**
- [ ] Firebase Console에서 프로젝트 생성 (또는 기존 프로젝트 선택)
- [ ] iOS 앱 등록 — Bundle ID: `com.example.chordListApp` (실제 값 확인 후 입력)
- [ ] `GoogleService-Info.plist` 다운로드 → `ios/Runner/` 에 추가 + Xcode 파일 참조 확인
- [ ] Android 앱 등록 — Package name: `com.example.chord_list_app` (실제 값 확인 후 입력)
- [ ] `google-services.json` 다운로드 → `android/app/` 에 추가
- [ ] Firebase Console → Analytics 활성화 확인

**작업 파일:**
- `android/build.gradle` — `classpath 'com.google.gms:google-services:...'` 추가
- `android/app/build.gradle` — `apply plugin: 'com.google.gms.google-services'` 추가
- `ios/Runner/GoogleService-Info.plist` — 추가
- `android/app/google-services.json` — 추가

**완료 조건:**
- [ ] Firebase 콘솔에서 iOS/Android 앱 등록 완료
- [ ] 설정 파일이 각 플랫폼 경로에 존재
- [ ] Android build.gradle 설정 완료
- [ ] `flutter build apk --debug` 빌드 오류 없음 (Android 확인용)
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `chore: Firebase 프로젝트 설정 파일 추가 (#21)`

---

### Phase 2: 패키지 추가 + Firebase 초기화 코드

**목표:** `firebase_core`, `firebase_analytics` 패키지를 추가하고 앱 시작 시 Firebase를 초기화한다. Analytics Provider를 생성하여 전역에서 사용할 수 있게 한다.

**사전 작업:**
- `firebase_core`, `firebase_analytics` 패키지 추가 (사용자 승인 후 진행)

**작업 파일:**
- `pubspec.yaml` — `firebase_core`, `firebase_analytics` 추가
- `lib/core/initialization.dart` — `Firebase.initializeApp()` 호출 추가
- `lib/shared/providers/analytics_provider.dart` — `FirebaseAnalytics` Provider 생성

**완료 조건:**
- [ ] 앱 실행 시 Firebase 초기화 오류 없음
- [ ] `analyticsProvider`가 전역에서 참조 가능
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: Firebase Analytics 초기화 및 Provider 추가 (#21)`

---

### Phase 3: 주요 화면 이벤트 로깅 연결

**목표:** 주요 화면 진입 시 Analytics 이벤트를 로깅한다. 로깅할 이벤트 목록은 작업 시작 전 확인 필요.

**대상 화면 (작업 시작 전 이벤트명 확정 필요):**
- `HomeScreen` (탭 화면)
- `BoxScreen`, `BoxDetailScreen`
- `LibraryScreen`
- `ChordDetailScreen`
- `MyScreen`

**작업 파일:**
- 위 각 screen 파일 — 화면 진입 시 `analytics.logScreenView()` 호출

**완료 조건:**
- [ ] 각 화면 진입 시 Firebase Console → DebugView에서 이벤트 확인
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 주요 화면 Analytics 이벤트 로깅 연결 (#21)`

---

## 주의사항

- **Bundle ID / Package name 확인 필수**: Firebase 앱 등록 시 실제 앱과 정확히 일치해야 함. `android/app/build.gradle`의 `applicationId`, Xcode의 Bundle Identifier 확인 후 입력
- **`GoogleService-Info.plist` 커밋 주의**: 민감 정보가 포함되어 있으므로 공개 저장소 여부 확인 후 커밋 결정. 필요시 `.gitignore`에 추가하고 별도 관리
- **`google-services.json` 커밋 주의**: 위와 동일
- **flutterfire CLI 활용 권장**: `dart pub global activate flutterfire_cli` 후 `flutterfire configure` 실행 시 설정 파일 생성 + build.gradle 수정까지 자동화
- **로깅 이벤트 목록**: Phase 3 시작 전 어떤 화면/액션을 로깅할지 사전 확정 필요
- **패키지 추가 전 반드시 사용자 승인**: `firebase_core`, `firebase_analytics` 모두 승인 필요

## 작업 시작 전 체크리스트

- [ ] docs/architecture/ 문서 숙지 완료
- [ ] 앱 Bundle ID (iOS) 및 Package name (Android) 확인
- [ ] Firebase 콘솔 접근 권한 확인
- [ ] 로깅할 이벤트 목록 사전 확정
- [ ] 패키지 추가 사용자 승인 완료
