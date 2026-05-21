# Issue #24 - feat: 온보딩 화면 추가

## 이슈 요약

> 앱 최초 실행 시 한 번만 노출되는 온보딩 화면을 추가하고, 시작하기 버튼 클릭 후 재노출되지 않도록 SharedPreferences로 상태를 관리한다.

## 전체 플로우

```
앱 실행 → SplashScreen (2500ms)
  └─ 온보딩 완료 여부 확인 (PreferenceRepository.findOnboardingDone())
      ├─ false (최초 실행) → OnboardingScreen
      │    └─ 3페이지 PageView 슬라이드
      │        ├─ 1~2페이지: "다음" 버튼으로 이동
      │        └─ 3페이지: "시작하기" 버튼 탭
      │              └─ saveOnboardingDone() → HomeScreen 이동
      └─ true (재실행) → HomeScreen
```

## UI 상세 명세

> **온보딩 화면 디자인은 사용자가 직접 작업합니다.**
> 아래는 구조적 요구사항만 명시합니다.

- 3페이지 `PageView` 슬라이드 구성 (스와이프 및 버튼 이동)
- 각 페이지: 이미지 (`MediaQuery` 세로 기준 50%) + 제목 + 설명 + 페이지 인디케이터
- 1~2페이지 하단: "다음" 버튼 / 3페이지 하단: "시작하기" 버튼
- 버튼 탭 시 → `saveOnboardingDone()` 호출 후 HomeScreen으로 이동
- 뒤로가기 비활성화 (`PopScope(canPop: false)`)
- 그라데이션 배경 (`brandPurple → black12`, topLeft → bottomRight)
- 세로 모드 고정 (진입 시 설정, 이탈 시 복원)

## 관련 파일

| 파일 | 작업 유형 |
|------|---------|
| `lib/shared/providers/preference_provider.dart` | 수정 |
| `lib/core/routes.dart` | 수정 |
| `lib/features/splash/presentation/splash_screen.dart` | 수정 |
| `lib/features/onboarding/presentation/screens/onboarding_screen.dart` | 신규 생성 |
| `lib/features/onboarding/presentation/widgets/onboarding_page.dart` | 신규 생성 |
| `lib/features/onboarding/presentation/widgets/page_indicator.dart` | 신규 생성 |

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

**완료 조건:**

- [x] `findOnboardingDone()` / `saveOnboardingDone()` 구현 완료
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 온보딩 완료 여부 SharedPreferences 저장/조회 추가 (#24)`

---

### Phase 2: 온보딩 화면 구현 및 라우팅 등록

**목표:** 온보딩 화면을 생성하고 라우팅에 등록한다. (화면 UI 디자인은 사용자 담당)

**작업 파일:**

- `lib/features/onboarding/presentation/screens/onboarding_screen.dart` — 3페이지 PageView, 그라데이션 배경, 세로 모드 고정, 다음/시작하기 버튼 로직
- `lib/features/onboarding/presentation/widgets/onboarding_page.dart` — 이미지, 제목, 설명, 페이지 인디케이터를 포함한 개별 페이지 위젯
- `lib/features/onboarding/presentation/widgets/page_indicator.dart` — 애니메이션 페이지 인디케이터 위젯
- `lib/core/routes.dart` — `/onboarding` 라우트 추가

**완료 조건:**

- [x] `OnboardingScreen` 클래스 생성 완료 (`routeName` 포함)
- [x] 시작하기 버튼 → `saveOnboardingDone()` 호출 → `HomeScreen` 이동 동작 확인
- [x] `PopScope(canPop: false)` 적용 완료
- [x] `routes.dart`에 `/onboarding` 라우트 등록 완료
- [x] flutter analyze 오류 없음

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
  final isDone = await ref.read(preferenceRepositoryProvider).findOnboardingDone();
  if (!context.mounted) return;
  context.goNamed(isDone ? HomeScreen.routeName : OnboardingScreen.routeName);
});
```

**완료 조건:**

- [x] 최초 실행 시 OnboardingScreen으로 이동 확인
- [x] 재실행 시 HomeScreen으로 이동 확인
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 스플래시 화면 온보딩 진입 분기 처리 (#24)`

---

## 주의사항

- `preferenceRepositoryProvider`는 `autoDispose`이므로 `SplashScreen`에서 `ref.read`로 사용
- 온보딩 화면 UI 디자인(콘텐츠 구성, 이미지, 텍스트)은 **사용자가 직접 작업**
- 세로 모드 고정은 온보딩 화면 한정 — 이탈 시 `SystemChrome.setPreferredOrientations([])`로 복원

## 작업 시작 전 체크리스트

- [x] docs/architecture/ 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료 (preference_provider, splash_screen, routes)
