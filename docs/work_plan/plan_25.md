# Issue #25 - feat: Box Detail 화면 코치마크 가이드 추가

## 이슈 요약

> Box Detail 화면 최초 진입 시 코드 길게 누르기 기능을 안내하는 코치마크 오버레이를 표시하고, "다시 보지 않기" 선택 시 SharedPreferences로 노출 여부를 관리한다.

## 전체 플로우

```
BoxDetailScreen 진입
  └─ findBoxDetailGuideDone() 조회
      ├─ false → 코치마크 오버레이 표시
      │    ├─ "닫기" 탭 → 오버레이 닫기 (다음 진입 시 재노출)
      │    └─ "☑️ 다시 보지 않기" 탭
      │         └─ saveBoxDetailGuideDone() → 오버레이 닫기 (재노출 없음)
      └─ true → 코치마크 미표시, 정상 화면
```

## UI 상세 명세

### 코치마크 오버레이

- **배경**: `Material(color: Colors.black.withValues(alpha: 0.8))` — 뒤 화면이 비쳐 보임, 터치 차단
- **가이드 이미지**: 화면 상단 중앙 배치 (`assets/images/coach_marks.webp`, 너비 80%)
- **Tip 문구**: `"💡 Tip : 코드를 꾹 누르면 편집 모드에서\n순서를 변경하거나 제거할 수 있어요!"`
- **버튼 영역** (하단 Row):
  - `"☑️ 다시 보지 않기"` 버튼 (좌) — `saveBoxDetailGuideDone()` 저장 후 닫음
  - `"닫기"` 버튼 (우) — 오버레이만 닫음 (SharedPreferences 저장 안 함)

### BoxDetailScreen 구조 변경

```
Stack
├─ FutureValueWidget → CScaffold (기존 화면)
└─ if (isGuideVisible) BoxDetailCoachMarkWidget (오버레이)
```

## 관련 파일

| 파일 | 작업 유형 |
|------|---------|
| `lib/shared/providers/preference_provider.dart` | 수정 |
| `lib/features/box/presentation/screens/box_detail_screen.dart` | 수정 |
| `lib/features/box/presentation/widgets/box_detail_coach_mark_widget.dart` | 신규 생성 |

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 의존성이 생기는 경우, 참조 대상(stub 포함)과 참조 코드를 같은 Phase로 묶는다

## 작업 단계

### Phase 1: PreferenceRepository 코치마크 메서드 추가

**목표:** Box Detail 코치마크 노출 완료 여부를 SharedPreferences에 저장/조회하는 메서드를 추가한다.

**작업 파일:**

- `lib/shared/providers/preference_provider.dart` — `findBoxDetailGuideDone()` / `saveBoxDetailGuideDone()` 추가, `_BOX_DETAIL_GUIDE_DONE` 키 상수 정의

**완료 조건:**

- [x] `findBoxDetailGuideDone()` / `saveBoxDetailGuideDone()` 구현 완료
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: Box Detail 코치마크 노출 여부 SharedPreferences 저장/조회 추가 (#25)`

---

### Phase 2: 코치마크 위젯 구현 및 BoxDetailScreen 연결

**목표:** 코치마크 오버레이 위젯을 구현하고 BoxDetailScreen 진입 시 노출 여부에 따라 표시한다.

**작업 파일:**

- `lib/features/box/presentation/widgets/box_detail_coach_mark_widget.dart` — Material 반투명 마스크 + 이미지 + Tip 문구 + 닫기/다시보지않기 버튼
- `lib/features/box/presentation/screens/box_detail_screen.dart` — `isGuideVisible` 상태 추가, 별도 `useEffect`에서 가이드 노출 여부 조회, `Stack`으로 래핑

**완료 조건:**

- [x] `BoxDetailCoachMarkWidget` 구현 완료 (마스크, 이미지, 문구, 버튼 2개)
- [x] "닫기" 버튼 → 오버레이 닫힘, 재진입 시 재노출 확인
- [x] "다시 보지 않기" 버튼 → `saveBoxDetailGuideDone()` 저장 후 재진입 시 미노출 확인
- [x] 마스크 터치 시 뒤 화면 인터랙션 차단 확인
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: Box Detail 코치마크 오버레이 구현 (#25)`

---

## 주의사항

- `isGuideVisible` 초기값은 `false`, `useEffect`에서 비동기 조회 후 설정 — 화면이 먼저 렌더된 뒤 오버레이가 올라오는 자연스러운 UX
- `preferenceRepositoryProvider`는 `autoDispose`이므로 `ref.read` 사용
- `BoxDetailScreen`의 analytics `useEffect`와 가이드 조회 `useEffect`는 **별도 분리**
- 배경 터치 차단은 `Material` 위젯의 기본 동작으로 처리 (`AbsorbPointer` 불필요)
- 코치마크 이미지 경로: `assets/images/coach_marks.webp`

## 작업 시작 전 체크리스트

- [x] docs/architecture/ 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료 (box_detail_screen, preference_provider)
