# Issue #19 - Box 상세페이지 UI 및 Box 수정/삭제 기능

## 이슈 요약

> Box 상세페이지에서 저장된 코드 운지법 목록을 확인하고, Box 정보를 수정하거나 Box를 삭제할 수 있다.

---

## 전체 플로우

### 진입점

- Box 리스트 페이지 → Box 타일 탭 → **Box 상세페이지** 이동 (라우팅 이미 연결됨)

### Flow A: Box 수정

```
앱바 더보기 아이콘 탭
  └─ 드롭다운 메뉴 표시 (수정 / 삭제)
      └─ "수정" 탭
          └─ BoxEditDialog 오픈 (기존 제목·설명 초기값으로)
              ├─ 취소 탭 → 다이얼로그 닫힘
              └─ 저장 탭 (제목 입력 시만 활성)
                  ├─ 성공 → 다이얼로그 닫힘 + 상세페이지 정보 즉시 반영
                  └─ 실패 → CToast "오류가 발생하였습니다."
```

### Flow B: Box 삭제

```
앱바 더보기 아이콘 탭
  └─ 드롭다운 메뉴 표시 (수정 / 삭제)
      └─ "삭제" 탭
          └─ CDialog "해당 Box를 삭제하시겠습니까?" 오픈
              ├─ 아니오 탭 → 다이얼로그 닫힘
              └─ 예 탭
                  ├─ 성공 → 다이얼로그 닫힘 + Box 리스트 페이지로 이동
                  └─ 실패 → CToast "오류가 발생하였습니다."
```

---

## UI 상세 명세

### Box 상세페이지 (`BoxDetailScreen`)

**앱바**
- 좌측: 뒤로가기 버튼
- 제목: Box 제목 (title)
- 우측: 더보기 아이콘 (`Icons.more_vert`) → 드롭다운 (수정 / 삭제)

**상단 Box 정보 영역**
- 제목 (semiBold, 상단)
- 설명 (설명이 있을 경우에만 표시, regular, secondary 색상)
- 생성일 (예: "2025. 4. 15", regular12, outline 색상)
- 하단 Divider

**코드 운지법 카드 그리드**
- `ChordPositionCardWidget` 재사용 (`chord`, `position` 전달)
- 2열 그리드 (`SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)`)
- 빈 상태: 안내 텍스트 표시 ("저장된 코드가 없습니다.")
- 카드 탭 시 동작 없음 (이 이슈에서는 미구현, 빈 onTap)

### BoxEditDialog

- `AlertDialog` 기반 (`NewBoxDialog`와 동일한 레이아웃)
- 제목: "Box 수정"
- 초기값: 현재 Box의 제목·설명으로 채워짐
- 입력 필드 1: "제목" (필수, 최대 50자)
- 입력 필드 2: "설명" (선택, 최대 100자)
- 버튼: "취소" (좌) / "저장" (우, 제목 비어있으면 비활성)
- 너비 고정: `SizedBox(width: double.maxFinite)`

---

## 관련 파일

**기존 파일 (수정)**

- `lib/shared/data/db/dao/box_dao.dart` — `updateBox` 메서드 추가
- `lib/shared/data/db/dao/box_chord_dao.dart` — 코드 상세 join 쿼리 추가
- `lib/features/box/presentation/screens/box_detail_screen.dart` — 실제 UI 구현

**신규 파일**

- `lib/features/box/domain/models/box_chord_detail_model.dart` — BoxChord + ChordPosition + Chord 통합 모델
- `lib/features/box/application/box_detail_state.dart` — 상세페이지 상태
- `lib/features/box/application/box_detail_view_model_provider.dart` — 상세페이지 ViewModel
- `lib/features/box/presentation/widgets/box_edit_dialog.dart` — Box 수정 다이얼로그

---

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 의존성이 생기는 경우, 참조 대상(stub 포함)과 참조 코드를 같은 Phase로 묶는다

---

## 작업 단계

---

### Phase 1: 데이터 레이어 + Box 상세페이지 기본 UI

**목표:** Box 상세페이지에 저장된 코드 운지법 카드 목록과 Box 정보를 표시한다.

**설계 메모:**

`BoxChordDao.watchByBoxId`는 `chordPositionId`만 반환하므로, `ChordPosition` + `Chord`를 함께 조회하는 join 쿼리가 필요하다.
Drift custom query 또는 `BoxChords` ⋈ `ChordPositions` ⋈ `Chords` 3-way join으로 구현한다.

> **⚠️ Drift `@DriftAccessor` tables 갱신 필수**
> 현재 `BoxChordDao`는 `@DriftAccessor(tables: [BoxChords])`만 선언되어 있다.
> join 쿼리에서 `ChordPositions`, `Chords` 테이블을 참조하려면 아래와 같이 변경해야 한다:
> ```dart
> @DriftAccessor(tables: [BoxChords, ChordPositions, Chords])
> ```
> 변경 후 `build_runner`를 재실행해야 `box_chord_dao.g.dart`가 재생성된다.

**작업 파일:**

- `lib/shared/data/db/dao/box_chord_dao.dart` — 수정
  - `@DriftAccessor(tables: [BoxChords, ChordPositions, Chords])` 로 변경
  - `watchByBoxIdWithDetails(int boxId)` 추가
  - `BoxChords JOIN ChordPositions JOIN Chords` 3-way join Stream 반환
  - 반환 타입: Drift 자동 생성 typedResult 또는 커스텀 타입
- `lib/features/box/domain/models/box_chord_detail_model.dart` — 신규
  - `BoxChordDetailModel({ chord, position, savedAt })` — 불변 클래스
  - `fromData(...)` factory 생성자
- `lib/features/box/application/box_detail_state.dart` — 신규
  - `BoxDetailState({ box, chordDetails })` — `@CopyWith()` 적용
  - `box`: `ChordBoxModel`, `chordDetails`: `List<BoxChordDetailModel>`
- `lib/features/box/application/box_detail_view_model_provider.dart` — 신규
  - `boxDetailViewModelProvider(int boxId)` — `family` 사용
  - `boxViewModelProvider`의 패턴 동일하게 적용 (Stream 구독)
  - `BoxDao.findById(boxId)` + `BoxChordDao.watchByBoxIdWithDetails(boxId)` 조합
- `lib/features/box/presentation/screens/box_detail_screen.dart` — 수정
  - `HookConsumerWidget`으로 변경
  - `boxDetailViewModelProvider(boxId)` 구독
  - 상단 Box 정보 영역 (제목, 설명, 생성일)
  - 코드 운지법 2열 그리드 (`ChordPositionCardWidget` 재사용)
  - 빈 상태 UI
  - 더보기 아이콘 자리만 AppBar에 배치 (동작은 Phase 2)

**완료 조건:**

- [ ] Box 상세페이지에서 Box 제목·설명·생성일이 올바르게 표시됨
- [ ] 저장된 코드 운지법 카드가 2열 그리드로 렌더링됨
- [ ] 빈 상태에서 안내 텍스트 표시됨
- [ ] `build_runner` 재실행 완료 (`box_chord_dao.g.dart`, `box_detail_state.g.dart` 재생성)
- [ ] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Box 상세페이지 기본 UI 구현 (#19)`

---

### Phase 2: 앱바 더보기 메뉴 + Box 수정/삭제 플로우

**목표:** 앱바 더보기 메뉴로 Box를 수정하거나 삭제하는 플로우를 완성한다.

**작업 파일:**

- `lib/shared/data/db/dao/box_dao.dart` — 수정
  - `updateBox(int id, ChordBoxesCompanion companion)` 추가
- `lib/features/box/presentation/widgets/box_edit_dialog.dart` — 신규
  - `BoxEditDialog({ box, onSuccess, onError })` — `HookConsumerWidget`
  - 기존 `box.title`, `box.description` 초기값으로 Controller 초기화
  - `db.boxDao.updateBox(...)` 호출
  - `NewBoxDialog`와 동일한 레이아웃 구조 적용 (버튼명: "저장")
  - 너비 고정 (`SizedBox(width: double.maxFinite)`)
- `lib/features/box/presentation/screens/box_detail_screen.dart` — 수정
  - 앱바 `Icons.more_vert` 탭 시 `PopupMenuButton` 드롭다운 표시
  - 수정 선택 → `BoxEditDialog` 표시
  - 삭제 선택 → `CDialog` "해당 Box를 삭제하시겠습니까?" 표시
    - 예 탭 → `BoxDao.deleteById(boxId)` → `context.pop()` (Box 리스트로 이동)
    - 아니오 탭 → 다이얼로그 닫힘

**완료 조건:**

- [ ] 더보기 아이콘 탭 시 드롭다운 메뉴 (수정/삭제) 표시됨
- [ ] 수정 탭 시 `BoxEditDialog` 오픈, 기존 제목·설명 초기값 확인
- [ ] 수정 저장 후 상세페이지 정보 즉시 반영됨
- [ ] 삭제 탭 시 확인 다이얼로그 표시, 취소/확인 동작 확인
- [ ] 삭제 완료 후 Box 리스트 페이지로 이동, 삭제된 Box가 목록에서 제거됨
- [ ] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Box 수정/삭제 플로우 구현 (#19)`

---

## 주의사항

- **`ChordPositionCardWidget` 재사용**: `chord`(`Chord` 타입), `position`(`ChordPosition` 타입)이 필요하므로 join 쿼리에서 두 테이블 데이터를 모두 가져와야 한다
- **`boxDetailViewModelProvider` family 사용**: `boxId`를 파라미터로 받아야 하므로 `.family`로 선언한다
- **삭제 후 이동**: `BoxDao.deleteById` 호출 시 `boxViewModelProvider`가 Stream으로 구독 중이므로 Box 리스트는 자동 반영된다. `context.pop()`으로 상세페이지 이탈만 처리하면 된다
- **`BoxEditDialog` 분리**: `NewBoxDialog`는 Box 생성 + BoxChord 저장을 함께 처리하므로 수정 용도로 재사용하기 어렵다. `BoxEditDialog`를 별도 파일로 신규 생성한다
- **`updateBox` 미구현**: 현재 `BoxDao`에 수정 메서드가 없으므로 Phase 2에서 추가해야 한다

---

## 작업 시작 전 체크리스트

- [ ] `docs/architecture/` 문서 숙지 완료
- [ ] `lib/features/box/` 기존 파일 구조 파악 완료 (`BoxState`, `BoxViewModelProvider`, `BoxDetailScreen`)
- [ ] `lib/shared/data/db/dao/` DAO 메서드 파악 완료 (`BoxDao`, `BoxChordDao`, `ChordPositionDao`)
- [ ] `lib/features/library/presentation/widgets/chord_position_card_widget.dart` 파라미터 파악 완료
