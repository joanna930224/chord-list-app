# Issue #16 - 햅틱 피드백 적용 및 공통 버튼 컴포넌트 구현

## 이슈 요약

> 기존 HapticService를 바텀 네비게이션 및 라이브러리 화면 인터랙션 요소에 적용하고,
> 라이브러리에서 사용 중인 선택형 버튼을 햅틱 내장 공통 컴포넌트(`COutlineToggleButton`, `CFlatToggleButton`)로 분리한다.

## 관련 파일

- `lib/features/home/presentation/screens/home_screen.dart` — 바텀네비 `onTap` 햅틱 추가
- `lib/shared/template/c_outline_toggle_button.dart` — 신규 생성
- `lib/shared/template/c_flat_toggle_button.dart` — 신규 생성
- `lib/features/library/presentation/widgets/root_selector_widget.dart` — `_RootButton` → `COutlineToggleButton` 교체
- `lib/features/library/presentation/widgets/type_selector_widget.dart` — `_TypeButton` → `CFlatToggleButton` 교체
- `lib/features/library/presentation/widgets/chord_position_card_widget.dart` — `onTap` 햅틱 추가
- `lib/shared/providers/haptic_provider.dart` — 참조 (기존)

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 클래스를 참조하는 코드는 해당 Phase에 포함 금지
- Phase 간 순서는 "컴파일 가능 상태 유지"를 최우선으로 설계한다

## 작업 단계

### Phase 1: 바텀 네비게이션 햅틱 적용

**목표:** `HomeScreen` 바텀 네비게이션 탭 전환 시 햅틱 피드백 적용

**작업 파일:**

- `lib/features/home/presentation/screens/home_screen.dart`
  - `_HomeView`를 `HookConsumerWidget`으로 변경
  - `BottomNavigationBar.onTap`에서 `hapticProvider`의 `light()` 호출 후 `currentIndex.value` 변경

**완료 조건:**

- [ ] 탭 전환 시 햅틱 동작 확인
- [ ] 설정에서 햅틱 OFF 시 미동작 확인
- [ ] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `chore: 바텀 네비게이션 탭 햅틱 피드백 적용 (#16)`

---

### Phase 2: 공통 토글 버튼 컴포넌트 구현

**목표:** `COutlineToggleButton`, `CFlatToggleButton` 신규 생성 (햅틱 내장)

**작업 파일:**

- `lib/shared/template/c_outline_toggle_button.dart` — 신규 생성
  - 기존 `_RootButton` 로직 기반
  - 파라미터: `label`, `isSelected`, `onTap`, `hapticType`(기본 `HapticType.selection`)
  - `ConsumerWidget` 사용, `hapticProvider`로 햅틱 호출
  - 아웃라인 보더, 선택 시 primary 배경, `AnimatedContainer`

- `lib/shared/template/c_flat_toggle_button.dart` — 신규 생성
  - 기존 `_TypeButton` 로직 기반
  - 파라미터: `label`, `isSelected`, `onTap`, `hapticType`(기본 `HapticType.selection`)
  - `ConsumerWidget` 사용, `hapticProvider`로 햅틱 호출
  - 보더 없음, 선택 시 primary 배경, 풀너비, `AnimatedContainer`

**완료 조건:**

- [x] 두 컴포넌트 독립 실행 가능한 상태로 생성 완료
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `chore: COutlineToggleButton, CFlatToggleButton 공통 컴포넌트 구현 (#16)`

---

### Phase 3: 라이브러리 위젯 교체 및 ChordPositionCard 햅틱 적용

**목표:** Phase 2에서 만든 공통 컴포넌트로 라이브러리 위젯 교체 + 운지 카드 햅틱 추가

**작업 파일:**

- `lib/features/library/presentation/widgets/root_selector_widget.dart`
  - `_RootButton` 클래스 제거
  - `COutlineToggleButton` import 후 교체 적용

- `lib/features/library/presentation/widgets/type_selector_widget.dart`
  - `_TypeButton` 클래스 제거
  - `CFlatToggleButton` import 후 교체 적용

- `lib/features/library/presentation/widgets/chord_position_card_widget.dart`
  - `StatelessWidget` → `ConsumerWidget` 변경
  - `GestureDetector.onTap`에서 `hapticProvider`의 `light()` 호출 후 기존 `onTap` 실행

**완료 조건:**

- [x] 루트 버튼 선택 시 햅틱 동작 확인
- [x] 타입 버튼 선택 시 햅틱 동작 확인
- [x] 운지 카드 탭 시 햅틱 동작 확인
- [x] 기존 UI 레이아웃 변화 없음
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `chore: 라이브러리 위젯 공통 컴포넌트 교체 및 운지 카드 햅틱 적용 (#16)`

---

## 주의사항

- `COutlineToggleButton`, `CFlatToggleButton`은 `ConsumerWidget` 사용 (hapticProvider 접근 필요)
- 햅틱 타입은 루트/타입 선택처럼 "선택" 성격의 인터랙션이므로 `HapticType.selection` 권장
- `ChordPositionCardWidget`은 공통화하지 않고 현재 위치 유지 (추후 `shared`로 이동 예정)
- `exports.dart`에 신규 컴포넌트 추가 여부 확인 후 필요 시 반영

## 작업 시작 전 체크리스트

- [x] `docs/architecture/` 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료 (`haptic_provider.dart`, `c_scale_button.dart` 패턴 참고)
