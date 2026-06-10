# Issue #18 - 코드 저장 바텀시트 및 공통 컴포넌트 구현

## 이슈 요약

> 라이브러리 화면에서 코드 카드 클릭 시 나타나는 바텀시트를 구현하고, 새 Box 생성·기존 Box 추가 기능과 공통 바텀시트·다이얼로그·토스트 컴포넌트를 각 사용 시점에 함께 구현한다.

## 전체 플로우

### 진입점

- 라이브러리 화면 코드 카드 탭 → **코드 저장 선택 바텀시트** 오픈

### Flow A: 새로운 Box 생성

```
코드 저장 바텀시트
  └─ "새로운 Box 생성" 탭
      └─ 바텀시트 닫힘
          └─ CDialog(새 Box 생성 폼) 오픈
              ├─ 취소 탭 → 다이얼로그 닫힘
              └─ 만들기 탭 (제목 입력 시만 활성)
                  ├─ 성공 → 다이얼로그 닫힘 + CToast "{Box 제목}에 저장되었습니다."
                  └─ 실패 → CToast "오류가 발생하였습니다."
```

### Flow B: 기존 Box에 추가

```
코드 저장 바텀시트
  └─ "기존 Box에 추가" 탭
      └─ 바텀시트 닫힘
          └─ Box 선택 바텀시트 오픈 (BoxListTileWidget 재사용)
              └─ Box 탭
                  ├─ 중복 없음 → 바텀시트 닫힘 + CToast "{Box 제목}에 저장되었습니다."
                  ├─ 중복 있음 → CDialog "이미 저장된 코드입니다. 중복 추가 하시겠습니까?"
                  │    ├─ 아니오 → 다이얼로그 닫힘 (바텀시트 유지)
                  │    └─ 예 → 저장 + 바텀시트 닫힘 + CToast "{Box 제목}에 저장되었습니다."
                  └─ 실패 → CToast "오류가 발생하였습니다."
```

## UI 상세 명세

### 코드 저장 선택 바텀시트

- 상단 드래그 핸들
- 코드 full name (예: "G Major", bold, 상단 좌측)
- 2개의 액션 버튼 (세로 또는 가로 배치, 아이콘 포함):
  - `Icons.add_box_outlined` + "새로운 Box 생성"
  - `Icons.inventory_2_outlined` + "기존 Box에 추가"

### 새 Box 생성 다이얼로그 (CDialog 활용)

- 제목: "새로운 Box"
- 입력 필드 1: "제목" (필수, 한 줄, 최대 50자)
- 입력 필드 2: "설명" (선택, 짧은 설명, 최대 100자)
- 버튼: "취소" (좌) / "만들기" (우, 제목 비어있으면 비활성)

### Box 선택 바텀시트

- 상단 드래그 핸들 + "기존 Box에 추가" 헤더
- 스크롤 가능한 Box 리스트 (`BoxListTileWidget` 재사용, `chordNames: []`)
- Box 없을 때: `BoxEmptyWidget` 표시

### 중복 저장 확인 다이얼로그 (CDialog 활용)

- 제목: "중복 저장"
- 내용: "이미 저장된 코드입니다.\n중복 추가 하시겠습니까?"
- 버튼: "아니오" (좌) / "예" (우)

### CToast

- 화면 하단 중앙 or Snackbar 스타일
- 자동 사라짐 (약 2초)
- 성공 메시지 / 오류 메시지 모두 동일 컴포넌트 사용

## 관련 파일

**기존 파일 (수정)**

- `lib/features/library/presentation/screens/library_screen.dart` — `_showBottomSheet` 실제 구현 연결
- `lib/features/library/presentation/widgets/chord_position_card_widget.dart` — `onTap` 파라미터 개선 (chord/position 전달)

**신규 파일**

- `lib/shared/template/c_bottom_sheet.dart`
- `lib/shared/template/c_dialog.dart`
- `lib/shared/template/c_toast.dart`
- `lib/features/library/domain/models/save_chord_action_type.dart`
- `lib/features/library/presentation/widgets/chord_bottom_sheet_widget.dart`
- `lib/features/library/presentation/widgets/new_box_dialog.dart`
- `lib/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart`

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 의존성이 생기는 경우, 참조 대상(stub 포함)과 참조 코드를 같은 Phase로 묶는다
- **공통 컴포넌트는 해당 Phase에서 처음 사용되는 시점에 함께 구현한다** (미리 커밋 금지)

## 작업 단계

---

### Phase 1: CBottomSheet + 코드 저장 선택 바텀시트

**목표:** `CBottomSheet` 공통 컴포넌트를 구현하고, 라이브러리 코드 카드 탭 시 저장 옵션을 보여주는 바텀시트를 연결한다.

**작업 파일:**

- `lib/shared/template/c_bottom_sheet.dart` — 신규
  - `showCBottomSheet<T>(context, builder)` 함수 또는 static method 형태
  - 드래그 핸들, `isScrollControlled: true`, `shape` (상단 둥근 border) 기본 스타일 적용
  - `builder`로 내부 콘텐츠를 주입받는 범용 구조
- `lib/features/library/domain/models/save_chord_action_type.dart` — 신규
  - `SaveChordActionType` enum (`createNew`, `addToExisting`)
- `lib/features/library/presentation/widgets/chord_bottom_sheet_widget.dart` — 신규
  - `ChordBottomSheetWidget(chord, position)` — `ConsumerWidget`
  - 상단: 코드 full name 표시 (예: "G Major")
  - 2개 액션 버튼 (아이콘 + 텍스트):
    - "새로운 Box 생성" → Phase 2에서 연결 (이 Phase에서는 `Navigator.pop` 후 아직 미구현 처리)
    - "기존 Box에 추가" → Phase 3에서 연결 (동일)
  - **CScaleButton 래핑**으로 각 버튼 햅틱 포함
- `lib/features/library/presentation/screens/library_screen.dart` — 수정
  - `_showBottomSheet`를 `showCBottomSheet` + `ChordBottomSheetWidget`으로 교체
  - `chord`, `position` 데이터를 바텀시트로 전달

**완료 조건:**

- [x] 라이브러리 코드 카드 탭 시 저장 선택 바텀시트가 표시됨
- [x] 코드 full name이 바텀시트 상단에 올바르게 표시됨
- [x] 2개 버튼 UI가 렌더링됨 (동작은 다음 Phase)
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: CBottomSheet 및 코드 저장 선택 바텀시트 구현 (#18)`

---

### Phase 2: CDialog + CToast + 새 Box 생성 플로우

**목표:** `CDialog`, `CToast` 공통 컴포넌트를 구현하고, "새로운 Box 생성" 버튼 탭 시 폼 다이얼로그와 저장 로직을 완성한다.

**작업 파일:**

- `lib/shared/template/c_dialog.dart` — 신규
  - `showCDialog(context, { title, content, actions })` 함수 형태
  - 제목(bold), 내용, 하단 버튼 목록 파라미터
  - 버튼: `CDialogAction(text, onPressed, isDestructive)`
  - Material `AlertDialog` 기반, 앱 테마 적용
- `lib/shared/template/c_toast.dart` — 신규
  - `CToast.show(context, message)` static 메서드
  - 화면 하단 `SnackBar` 래핑, 자동 2초 후 사라짐
  - 앱 테마 색상 적용
- `lib/features/library/presentation/widgets/new_box_dialog.dart` — 신규
  - `NewBoxDialog(chordPositionId, onSuccess, onError)` — `HookConsumerWidget`
  - `TextEditingController` for 제목 (필수), 설명 (선택)
  - 제목 비어있으면 "만들기" 버튼 비활성
  - 만들기 탭 시:
    1. `db.boxDao.insertBox(ChordBoxesCompanion.insert(title, description, createdAt))` → boxId 획득
    2. `db.boxChordDao.insertBoxChord(BoxChordsCompanion.insert(boxId, chordPositionId, savedAt))` → 저장
    3. 성공: `onSuccess(title)` → CToast
    4. 실패: `onError()` → CToast
  - 다이얼로그 너비 고정 (`SizedBox(width: double.maxFinite)`)
- `lib/features/library/presentation/screens/library_screen.dart` — 수정
  - "새로운 Box 생성" 탭 시: `_showNewBoxDialog(context, chord, position)` 연결

**완료 조건:**

- [x] "새로운 Box 생성" 탭 시 바텀시트 닫히고 다이얼로그 오픈됨
- [x] 제목 입력 전 "만들기" 버튼 비활성 확인
- [x] 새 Box 생성 후 `BoxDao.watchAll`로 목록에 즉시 반영됨
- [x] 성공 / 실패 시 CToast 표시 확인
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: CDialog·CToast 및 새 Box 생성 플로우 구현 (#18)`

---

### Phase 3: 기존 Box 선택 바텀시트 + 중복 처리 플로우

**목표:** "기존 Box에 추가" 탭 시 Box 목록 바텀시트를 구현하고, 중복 감지·확인 다이얼로그·저장 플로우를 완성한다.

**작업 파일:**

- `lib/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart` — 신규
  - `SelectBoxBottomSheetWidget(chordPositionId, onSuccess, onError, onCreateNew?)` — `HookConsumerWidget`
  - 상단 드래그 핸들 + "기존 Box에 추가" 헤더
  - `boxViewModelProvider` 구독 → `BoxListTileWidget` 재사용 (`chordNames: []`)
  - Box 없을 때: `BoxEmptyWidget` + 우측 하단 "＋ Box 생성하기" 버튼 표시 → `onCreateNew` 콜백 호출
  - Box 탭 시:
    1. `db.boxChordDao.existsInBox(boxId, chordPositionId)` 중복 확인
    2. 중복 없음: 바로 저장 → 바텀시트 닫힘 + CToast
    3. 중복 있음: `showCDialog` 로 중복 확인 다이얼로그 표시
       - "아니오": 다이얼로그만 닫힘 (바텀시트 유지)
       - "예": 저장 → 바텀시트 닫힘 + CToast
    4. 실패: CToast "오류가 발생하였습니다."
- `lib/features/library/presentation/screens/library_screen.dart` — 수정
  - "기존 Box에 추가" 탭 시: `_showSelectBoxSheet(context, chord, position)` 연결
  - `onCreateNew`로 `_showNewBoxDialog` 플로우 재사용

**완료 조건:**

- [x] "기존 Box에 추가" 탭 시 Box 목록 바텀시트 표시됨
- [x] Box 목록이 `BoxListTileWidget`으로 올바르게 렌더링됨
- [x] Box 없을 때 `BoxEmptyWidget` + "＋ Box 생성하기" 버튼 표시 확인
- [x] 중복 없는 항목 저장 시 토스트 확인
- [x] 중복 항목 탭 시 확인 다이얼로그 표시, 각 응답 처리 확인
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: 기존 Box 선택 및 중복 저장 처리 구현 (#18)`

---

## 주의사항

- **공통 컴포넌트 구현 시점**: `CBottomSheet`는 Phase 1, `CDialog`·`CToast`는 Phase 2에서 처음 사용되는 시점에 같이 구현 (사전 커밋 금지)
- **바텀시트 닫기 후 다이얼로그/바텀시트 열기**: `context.mounted` 체크 필수 (`Navigator.pop` 이후 비동기 컨텍스트 사용 시)
- **DB 직접 접근**: 이 이슈의 저장 로직은 복잡한 상태관리가 불필요하므로 `appDatabaseProvider`를 통해 DAO 직접 호출로 구현 (별도 ViewModel 불필요)
- **BoxListTileWidget 재사용**: `chordNames`는 `const []`로 전달 (코드 내역 연동은 별도 이슈)
- **선행 조건**: 이슈 #10 (Box DB 및 리스트 타일) 완료 필수

## 작업 시작 전 체크리스트

- [x] `docs/architecture/` 문서 숙지 완료
- [x] `lib/features/library/presentation/screens/library_screen.dart` 기존 `_showBottomSheet` 파악 완료
- [x] `lib/shared/data/db/dao/box_dao.dart`, `box_chord_dao.dart` DAO 메서드 파악 완료
- [x] `lib/features/box/presentation/widgets/box_list_tile_widget.dart` 파라미터 파악 완료
