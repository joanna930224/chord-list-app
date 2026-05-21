# Issue #22 - Firebase Crashlytics 연동

## 이슈 요약

> Firebase Crashlytics를 Flutter 앱(iOS/Android)에 연동하여 앱 크래시 및 비치명적 오류 데이터를 수집한다.

---

## 관련 파일

**기존 파일 (수정)**

- `pubspec.yaml` — `firebase_crashlytics` 추가
- `lib/core/initialization.dart` — `FlutterError.onError`, `PlatformDispatcher.instance.onError` 설정
- `android/build.gradle.kts` — Crashlytics Gradle plugin classpath 추가
- `android/app/build.gradle.kts` — Crashlytics plugin 적용 + 의존성 추가

**플랫폼 수동 작업**

- iOS Xcode — dSYM 자동 업로드 Build Phase 스크립트 추가

**패키지 추가 필요 (사용자 승인 필요)**

- `firebase_crashlytics` — 크래시 및 오류 수집

---

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지

---

## 작업 단계

### Phase 1: 패키지 추가 + Flutter 초기화 코드 연결

**목표:** `firebase_crashlytics` 패키지를 추가하고, Flutter/Dart 레이어의 오류를 Crashlytics로 전달하는 초기화 코드를 작성한다.

**사전 작업:**

- `firebase_crashlytics` 패키지 추가 (사용자 승인 후 진행)

**작업 파일:**

- `pubspec.yaml` — `firebase_crashlytics` 추가
- `lib/core/initialization.dart` — 아래 두 핸들러 등록
  - `FlutterError.onError` → Flutter 프레임워크 오류 전달
  - `PlatformDispatcher.instance.onError` → 비동기/Zone 오류 전달 (Flutter 3.3+ 권장)

**완료 조건:**

- [x] 앱 실행 시 Crashlytics 초기화 오류 없음
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Firebase Crashlytics 초기화 코드 연결 (#22)`

---

### Phase 2: 플랫폼 네이티브 설정

**목표:** Android Gradle에 Crashlytics 플러그인을 적용하고, iOS에서 dSYM 자동 업로드 Build Phase를 추가한다.

**작업 파일:**

- `android/build.gradle.kts` — Crashlytics Gradle plugin 추가
  ```kotlin
  id("com.google.firebase.crashlytics") version "3.x.x" apply false
  ```
- `android/app/build.gradle.kts` — plugin 적용 및 의존성 추가
  ```kotlin
  id("com.google.firebase.crashlytics")
  // dependencies 블록 (기존 Firebase BoM 활용)
  implementation("com.google.firebase:firebase-crashlytics")
  ```
- iOS Xcode (수동) — Build Phase 스크립트 추가
  ```
  Target: Runner → Build Phases → + → New Run Script Phase
  "${PODS_ROOT}/FirebaseCrashlytics/run"
  Input Files: ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}
  ```

**완료 조건:**

- [x] `flutter build apk --debug` 빌드 오류 없음
- [x] iOS Xcode Build Phase 스크립트 추가 완료
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `chore: Crashlytics 플랫폼 네이티브 설정 (#22)`

---

### Phase 3: 동작 확인

**목표:** 테스트 크래시를 강제 발생시켜 Firebase Console에서 수집되는지 확인한다.

**작업 파일:**

- 임시 테스트 코드 추가 후 확인 → 확인 완료 즉시 제거

**테스트 방법:**

```dart
// 확인용 임시 코드 — 확인 후 반드시 삭제
FirebaseCrashlytics.instance.crash();
```

**완료 조건:**

- [x] 테스트 크래시 발생 후 Firebase Console → Crashlytics에서 수집 확인 (이메일 알림으로 확인)
- [x] 테스트 코드 제거 완료
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Firebase Crashlytics 연동 완료 (#22)`

---

## 주의사항

- **`google-services.json` / `GoogleService-Info.plist` 재다운로드 불필요**: Firebase 프로젝트에서 Crashlytics를 활성화하면 기존 설정 파일에 자동 반영됨. 단, Firebase Console에서 Crashlytics 활성화 여부를 먼저 확인할 것
- **dSYM 스크립트**: 릴리즈 빌드에서 크래시 스택 트레이스가 심볼화되려면 반드시 필요. 개발 중에도 추가해두는 것이 권장됨
- **패키지 추가 전 반드시 사용자 승인**: `firebase_crashlytics` 승인 필요

## 작업 시작 전 체크리스트

- [x] docs/architecture/ 문서 숙지 완료
- [x] Firebase Console에서 Crashlytics 활성화 확인
- [x] `firebase_crashlytics` 패키지 추가 사용자 승인 완료
