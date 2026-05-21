# Issue #24 - feat: 온보딩 화면 추가

## 이슈 요약

> 앱 최초 실행 시 한 번만 노출되는 온보딩 화면을 추가하고, 시작하기 버튼 클릭 후 재노출되지 않도록 SharedPreferences로 상태를 관리한다.

## 전체 플로우

```
앱 실행 → SplashScreen (2500ms)
  └─ 온보딩 완료 여부 확인 (PreferenceRepository.findOnboardingDone())
      ├─ false (최초 실행) → OnboardingScreen
      │    └─ "시작하기" 버튼 탭
      │        └─ saveOnboardingDone(true) → HomeScreen 이동
      └─ true (재실행) → HomeScreen
```

## UI 상세 명세

> **온보딩 화면 디자인은 사용자가 직접 작업합니다.**
> 아래는 구조적 요구사항만 명시합니다.

- `OnboardingScreen` 하단에 "시작하기" 버튼 배치
- 버튼 탭 시 → `saveOnboardingDone()` 호출 후 HomeScreen으로 이동
- 뒤로가기 비활성화 (`PopScope(canPop: false)`)

## 관련 파일

| 파일 | 작업 유형 |
|------|---------|
| `lib/shared/providers/preference_provider.dart` | 수정 |
| `lib/core/routes.dart` | 수정 |
| `lib/features/splash/presentation/splash_screen.dart` | 수정 |
| `lib/features/onboarding/presentation/onboarding_screen.dart` | 신규 생성 |

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 의존성이 생기는 경우, 참조 대상(stub 포함)과 참조 코드를 같은 Phase로 묶는다

## 작업 단계

### Phase 1: PreferenceRepository 온보딩 메서드 추가

**목표:** 온보딩 완료 여부를 SharedPreferences에 저장/조회하는 메서드를 추가한다.

**작업 파일:**

- `lib/shared/providers/preference_provider.dart` — `findOnboardingDone()` / `saveOnboardingDone()` 추가, `_ONBOARDING_DONE` 키 상수 정의

**구현 내용:**
```dart
final _ONBOARDING_DONE = 'ONBOARDING_DONE';

Future<bool> findOnboardingDone() async {
  final prefs = await _instance;
  return prefs.getBool(_ONBOARDING_DONE) ?? false;
}

Future<void> saveOnboardingDone() async {
  final prefs = await _instance;
  await prefs.setBool(_ONBOARDING_DONE, true);
}
```

**완료 조건:**

- [ ] `findOnboardingDone()` / `saveOnboardingDone()` 구현 완료
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 온보딩 완료 여부 SharedPreferences 저장/조회 추가 (#24)`

---

### Phase 2: 온보딩 화면 구현 및 라우팅 등록

**목표:** 온보딩 화면을 생성하고 라우팅에 등록한다. (화면 UI 디자인은 사용자 담당)

**작업 파일:**

- `lib/features/onboarding/presentation/onboarding_screen.dart` — 화면 생성 (UI 디자인 제외, 뼈대 및 시작하기 버튼 로직만)
- `lib/core/routes.dart` — `/onboarding` 라우트 추가

**완료 조건:**

- [ ] `OnboardingScreen` 클래스 생성 완료 (`routeName` 포함)
- [ ] 시작하기 버튼 → `saveOnboardingDone()` 호출 → `HomeScreen` 이동 동작 확인
- [ ] `PopScope(canPop: false)` 적용 완료
- [ ] `routes.dart`에 `/onboarding` 라우트 등록 완료
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 온보딩 화면 구현 및 라우팅 등록 (#24)`

---

### Phase 3: SplashScreen 진입 분기 처리

**목표:** SplashScreen에서 온보딩 완료 여부를 확인하여 OnboardingScreen 또는 HomeScreen으로 분기한다.

**작업 파일:**

- `lib/features/splash/presentation/splash_screen.dart` — 타이머 완료 시 `findOnboardingDone()` 조회 후 라우팅 분기 처리

**구현 내용:**
```dart
final timer = Timer(const Duration(milliseconds: 2500), () async {
  if (!context.mounted) return;
  final prefs = ref.read(preferenceRepositoryProvider);
  final isDone = await prefs.findOnboardingDone();
  if (!context.mounted) return;
  if (isDone) {
    context.goNamed(HomeScreen.routeName);
  } else {
    context.goNamed(OnboardingScreen.routeName);
  }
});
```

**완료 조건:**

- [ ] 최초 실행 시 OnboardingScreen으로 이동 확인
- [ ] 재실행 시 HomeScreen으로 이동 확인
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 스플래시 화면 온보딩 진입 분기 처리 (#24)`

---

## 주의사항

- `preferenceRepositoryProvider`는 `autoDispose`이므로 `SplashScreen`에서 `ref.read`로 사용
- 온보딩 화면 UI 디자인(콘텐츠 구성, 이미지, 텍스트)은 **사용자가 직접 작업**
- Phase 2에서 UI 뼈대만 먼저 구성하고, 사용자가 디자인 작업 후 Phase 3 진행 권장

## 작업 시작 전 체크리스트

- [ ] docs/architecture/ 문서 숙지 완료
- [ ] 관련 기존 코드 파악 완료 (preference_provider, splash_screen, routes)
