# Issue #29 - feat : 보관함 상세에서 커스텀 운지법 저장 기능

## 이슈 요약

> 보관함 상세 화면에서 사용자가 직접 운지법을 커스텀하여 저장할 수 있는 기능을 추가한다.

---

## 전체 플로우

```
BoxDetail 화면의 + 버튼 탭
  └─ CustomChordEditorScreen 푸시 (full-screen)
      ├─ 프렛보드에서 줄별 운지 설정
      │    ├─ 줄 탭 1회 → 오픈(0)
      │    ├─ 줄 탭 2~N회 → 해당 프렛 번호
      │    └─ 줄 탭 추가 → 뮤트(-1)로 순환
      ├─ baseFret 조정 (+ / - 버튼)
      ├─ 코드 이름 입력 (TextField)
      ├─ 실시간 FlutterGuitarChord 미리보기
      └─ 저장 버튼 탭
           ├─ 이름 미입력 → 저장 버튼 비활성화
           ├─ 성공 → Navigator.pop() → BoxDetail 목록 자동 갱신 (Stream)
           └─ 실패 → CToast 에러 표시
```

---

## UI 상세 명세

### CustomChordEditorScreen

- **AppBar**: 제목 "Custom", 우측 "저장" TextButton (이름 미입력 시 비활성화)
- **상단**: 코드 이름 입력 TextField
- **중앙**: 인터랙티브 프렛보드 위젯 (FretboardWidget)
  - 6줄 × 5프렛 격자 (baseFret 기준 상대적 표시)
  - 각 줄 상단에 뮤트(X) / 오픈(O) 토글 버튼
  - 격자 셀 탭 → 해당 줄의 운지 프렛 설정 (같은 셀 재탭 시 해제)
  - 좌측에 baseFret 숫자 표기 및 ▲▼ 조절 버튼
  - 줄별 손가락 번호 다이얼 (T / 1~4), 운지된 줄에서만 활성화
  - 운지 시 다음 손가락 번호 자동 배정 (`_nextFinger`)
- **우측(가로) / 하단(세로)**: FlutterGuitarChord 실시간 미리보기 영역
  - "미리보기" 레이블 항상 표시
  - 가로/세로 모드 모두 스크롤 없이 화면에 맞게 표시 (FittedBox scaleDown)

### FretboardWidget (재사용 위젯)

- 6줄 × 5프렛 인터랙티브 격자
- 줄별 뮤트/오픈 토글 버튼
- 셀 탭으로 운지 설정
- 손가락 번호 다이얼 (HookWidget, ListWheelScrollView)

---

## 관련 파일

**수정 대상**
- `lib/shared/data/db/tables/chords_table.dart` — `isCustom` 컬럼 추가
- `lib/shared/data/db/dao/chord_dao.dart` — 커스텀 코드 insert/delete 메서드, search 필터
- `lib/shared/data/db/dao/chord_position_dao.dart` — `deleteById` 메서드 추가
- `lib/shared/data/db/app_database.dart` — `schemaVersion` 유지 (재설치 방식)
- `lib/features/box/application/box_detail_view_model_provider.dart` — `saveCustomChord`, `deleteBox` 메서드 추가
- `lib/features/box/presentation/screens/box_detail_screen.dart` — + FAB 추가, deleteBox 뷰모델 연결
- `lib/core/routes.dart` — 커스텀 운지 편집 라우트 추가

**신규 생성**
- `lib/features/box/application/custom_chord_editor_state.dart`
- `lib/features/box/application/custom_chord_editor_state.g.dart` (build_runner 생성)
- `lib/features/box/application/custom_chord_editor_view_model_provider.dart`
- `lib/features/box/presentation/screens/custom_chord_editor_screen.dart`
- `lib/features/box/presentation/widgets/fretboard_widget.dart`

---

## Phase 구성 원칙

각 Phase는 독립적으로 커밋 가능한 상태여야 한다.
- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 클래스를 참조하는 코드는 해당 Phase에 포함 금지

---

## 작업 단계

### Phase 1: DB 스키마 변경

**목표:** `Chords` 테이블에 `isCustom` 컬럼을 추가하고, 커스텀 코드 관련 DAO 메서드를 정비한다.

**작업 파일:**

- `lib/shared/data/db/tables/chords_table.dart`
  - `isCustom` 컬럼 추가: `BoolColumn get isCustom => boolean().withDefault(const Constant(false))();`
- `lib/shared/data/db/dao/chord_dao.dart`
  - `search()` 메서드에 `isCustom = false` 조건 추가 (커스텀 코드가 검색에 노출되지 않도록)
  - `insertCustomChord(String name)` 메서드 추가 (isCustom=true, root/type/difficulty 기본값 처리)
  - `deleteById(int id)` 메서드 추가
- `lib/shared/data/db/dao/chord_position_dao.dart`
  - `deleteById(int positionId)` 메서드 추가
- build_runner 실행

**완료 조건:**

- [x] `Chords` 테이블에 `isCustom` 컬럼이 존재한다
- [x] `ChordDao.search()` 가 커스텀 코드를 반환하지 않는다
- [x] `flutter analyze` 오류 없음
- [x] build_runner 오류 없음

---

### Phase 2: 커스텀 코드 저장 로직

**목표:** BoxDetailViewModel에 커스텀 코드 생성·저장 트랜잭션 메서드를 추가한다.

**작업 파일:**

- `lib/features/box/application/box_detail_view_model_provider.dart`
  - `saveCustomChord({required String name, required String frets, required String fingers, required int baseFret})` 메서드 추가
    - 트랜잭션: `Chord(isCustom=true)` insert → `ChordPosition` insert → `BoxChord` insert
  - `deleteBox()` 메서드 추가 (Box 삭제를 뷰모델에서 처리)

> **참고:** 커스텀 코드 orphan 정리는 기존 `saveEditing` 메서드에서 처리한다.
> (`isCustom=true`인 제거 항목에 대해 ChordPosition, Chord 순으로 삭제)

**완료 조건:**

- [x] `saveCustomChord` 호출 시 DB에 Chord, ChordPosition, BoxChord가 생성된다
- [x] `flutter analyze` 오류 없음

---

### Phase 3: 커스텀 운지 편집 화면

**목표:** 인터랙티브 프렛보드 UI와 커스텀 운지 편집 화면을 구현한다.

**작업 파일:**

- `lib/features/box/application/custom_chord_editor_state.dart`
  - `@CopyWith()` 적용
  - 필드: `List<int> frets`, `int baseFret`, `String chordName`, `List<String> fingers`
  - getter: `fretsString` (`frets.join(' ')`), `fingersString` (`fingers.join(' ')`), `isValid`
- `lib/features/box/application/custom_chord_editor_view_model_provider.dart`
  - `NotifierProvider.autoDispose` 사용 (`Notifier<CustomChordEditorState>` 상속)
  - 메서드: `selectFret`, `updateBaseFret`, `updateChordName`, `toggleMute`, `updateFinger`
  - private: `_nextFinger` (운지 시 다음 손가락 번호 자동 배정)
- `lib/features/box/presentation/widgets/fretboard_widget.dart`
  - `FretboardWidget` — `StatelessWidget`, 6줄 × 5프렛 인터랙티브 격자
  - `_BaseFretControl` — `StatelessWidget`
  - `_FingerWheelColumn` — `HookWidget` (ListWheelScrollView 기반 손가락 번호 다이얼)
- `lib/features/box/presentation/screens/custom_chord_editor_screen.dart`
  - `CustomChordEditorScreen` — `HookConsumerWidget`
  - `_FretboardControls` — `ConsumerWidget` (LayoutBuilder + FittedBox.scaleDown 적용)
  - `_ChordPreview` — `ConsumerWidget` (ColoredBox + Center, 세로 중앙 정렬)
  - 가로/세로 모드 모두 스크롤 없이 화면에 맞게 표시

**완료 조건:**

- [x] 프렛보드에서 운지를 설정하면 실시간으로 다이어그램이 갱신된다
- [x] 저장 버튼 탭 시 `BoxDetailViewModel.saveCustomChord`가 호출된다
- [x] 저장 성공 후 화면이 닫히고 BoxDetail 목록에 추가된 운지가 표시된다
- [x] `flutter analyze` 오류 없음

---

### Phase 4: BoxDetail 진입점 및 라우팅 연결

**목표:** BoxDetail 화면에 + FAB를 추가하고 라우팅을 연결한다.

**작업 파일:**

- `lib/core/routes.dart`
  - `/box/:id/custom-chord` 라우트 추가, `routeName`은 UUID 사용
- `lib/features/box/presentation/screens/box_detail_screen.dart`
  - 편집 모드가 아닐 때 FAB에 + 버튼 추가
  - 탭 시 `context.pushNamed(CustomChordEditorScreen.routeName, pathParameters: {'id': ...})`

**완료 조건:**

- [x] BoxDetail 화면에서 + FAB가 표시된다
- [x] + FAB 탭 시 커스텀 운지 편집 화면으로 이동한다
- [x] 편집 모드(`isEditing=true`)일 때는 + FAB가 숨겨진다
- [x] `flutter analyze` 오류 없음

---

## 주의사항

- **재설치 방식 적용:** 스키마 변경이므로 기존 앱 삭제 후 재설치 필요. `schemaVersion`은 올리되 `onUpgrade` 마이그레이션은 작성하지 않는다. (정식 출시 전 비공개 테스트 단계)
- **frets/fingers 포맷:** `join(' ')` 공백 구분 문자열. `FlutterGuitarChord` 및 기존 seed data와 동일 포맷. Preview와 저장 데이터 완전 일치.
- **Chord 필수 필드 기본값:** `root`, `type`, `difficulty` 컬럼은 `'custom'`으로 삽입.
- **orphan 방지:** `isCustom=true` 코드는 `saveEditing` 내 트랜잭션에서 ChordPosition, Chord 순으로 삭제.
- **search 필터:** `ChordDao.search()`에 `isCustom = false` 필터 적용 완료.
- **손가락 번호 미지정('0'):** 현재 버전에서는 운지된 줄에 항상 손가락 번호가 표시된다. '없음' 옵션은 v1 범위 외로 결정.

---

## 작업 시작 전 체크리스트

- [x] `docs/architecture/` 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료 (box_detail_screen, chord_dao, chord_position_dao, box_chord_dao)
- [x] `FlutterGuitarChord` frets/fingers 포맷 확인 완료
