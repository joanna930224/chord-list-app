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
           ├─ 이름 미입력 → 입력 유도 (버튼 비활성화 또는 에러 표시)
           ├─ 성공 → Navigator.pop() → BoxDetail 목록 자동 갱신 (Stream)
           └─ 실패 → CToast 에러 표시
```

---

## UI 상세 명세

### CustomChordEditorScreen

- **AppBar**: 제목 "커스텀 운지법 추가", 우측 "저장" TextButton (이름 미입력 시 비활성화)
- **상단**: 코드 이름 입력 TextField
- **중앙**: 인터랙티브 프렛보드 위젯 (FretboardWidget)
  - 6줄 × 5프렛 격자 (baseFret 기준 상대적 표시)
  - 각 줄 상단에 뮤트(X) / 오픈(O) 토글 버튼
  - 격자 셀 탭 → 해당 줄의 운지 프렛 설정 (같은 셀 재탭 시 해제)
  - 좌측에 baseFret 숫자 표기
- **하단**: baseFret 조절 Row (− 버튼 / 현재 프렛 숫자 / + 버튼)
- **우측 상단 or 중앙 상단**: FlutterGuitarChord 실시간 미리보기 카드

### FretboardWidget (재사용 위젯)

- 6줄 × 5프렛 격자
- 각 셀: 운지 여부에 따라 색상 표시 (filled/empty)
- 뮤트 줄: 해당 줄 전체 비활성화 표시

---

## 관련 파일

**수정 대상**
- `lib/shared/data/db/tables/chords_table.dart` — `isCustom` 컬럼 추가
- `lib/shared/data/db/dao/chord_dao.dart` — 커스텀 코드 insert/delete 메서드, search 필터
- `lib/shared/data/db/dao/chord_position_dao.dart` — `deleteById` 메서드 추가
- `lib/shared/data/db/app_database.dart` — `schemaVersion` 유지 (재설치 방식)
- `lib/features/box/application/box_detail_view_model_provider.dart` — `saveCustomChord` 메서드 추가
- `lib/features/box/presentation/screens/box_detail_screen.dart` — + 버튼 추가
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
  - `deleteCustomChordById(int id)` 메서드 추가
- `lib/shared/data/db/dao/chord_position_dao.dart`
  - `deleteById(int positionId)` 메서드 추가
- build_runner 실행

**완료 조건:**

- [ ] `Chords` 테이블에 `isCustom` 컬럼이 존재한다
- [ ] `ChordDao.search()` 가 커스텀 코드를 반환하지 않는다
- [ ] `flutter analyze` 오류 없음
- [ ] build_runner 오류 없음

**커밋 메시지 제안:** `chore: Chords 테이블에 isCustom 컬럼 추가 및 DAO 정비 (#29)`

---

### Phase 2: 커스텀 코드 저장/삭제 로직

**목표:** BoxDetailViewModel에 커스텀 코드 생성·저장·삭제 트랜잭션 메서드를 추가한다.

**작업 파일:**

- `lib/features/box/application/box_detail_view_model_provider.dart`
  - `saveCustomChord({required String name, required String frets, required String fingers, required int baseFret})` 메서드 추가
    - 트랜잭션: `Chord(isCustom=true)` insert → `ChordPosition` insert → `BoxChord` insert
  - `deleteCustomChord(BoxChordDetailModel detail)` 메서드 추가
    - BoxChord 삭제 → 해당 ChordPosition 삭제 → Chord 삭제 (isCustom=true인 경우에만)

> **참고:** 기존 `saveEditChanges`는 isCustom 여부 무관하게 BoxChord만 삭제한다.
> 커스텀 코드 삭제 시 Chord/ChordPosition orphan 방지를 위해 별도 메서드로 처리한다.

**완료 조건:**

- [ ] `saveCustomChord` 호출 시 DB에 Chord, ChordPosition, BoxChord가 생성된다
- [ ] `deleteCustomChord` 호출 시 관련 레코드가 모두 삭제된다
- [ ] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: BoxDetailViewModel에 커스텀 코드 저장/삭제 로직 추가 (#29)`

---

### Phase 3: 커스텀 운지 편집 화면

**목표:** 인터랙티브 프렛보드 UI와 커스텀 운지 편집 화면을 구현한다.

**작업 파일:**

- `lib/features/box/application/custom_chord_editor_state.dart`
  - `@CopyWith()` 적용
  - 필드: `List<int> frets` (6개, -1=뮤트/0=오픈/1+=프렛번호), `int baseFret`, `String chordName`
- `lib/features/box/application/custom_chord_editor_view_model_provider.dart`
  - `AutoDisposeNotifierProvider` 사용
  - 메서드: `setFret(int stringIndex, int fret)`, `setBaseFret(int baseFret)`, `setChordName(String name)`, `toggleMute(int stringIndex)`
  - `fretsString` / `fingersString` getter (저장 시 DB 포맷 변환)
- `lib/features/box/presentation/widgets/fretboard_widget.dart`
  - 6줄 × 5프렛 인터랙티브 격자
  - 줄별 뮤트/오픈 토글 버튼
  - 셀 탭으로 운지 설정
- `lib/features/box/presentation/screens/custom_chord_editor_screen.dart`
  - `HookConsumerWidget`
  - AppBar: 제목 "커스텀 운지법 추가", 저장 버튼 (chordName 비어있으면 비활성화)
  - FretboardWidget + baseFret 조절 + 코드 이름 입력 + 미리보기

> **frets 포맷 확인:** `guitar_chord_library`의 `ChordPosition.frets` 문자열 포맷과 동일하게 맞춰야 `FlutterGuitarChord` 렌더링이 정상 작동한다. 작업 전 기존 seed data DB 값을 확인하여 포맷 검증 필요.

**완료 조건:**

- [ ] 프렛보드에서 운지를 설정하면 실시간으로 다이어그램이 갱신된다
- [ ] 저장 버튼 탭 시 BoxDetailViewModel.saveCustomChord가 호출된다
- [ ] 저장 성공 후 화면이 닫히고 BoxDetail 목록에 추가된 운지가 표시된다
- [ ] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: 커스텀 운지 편집 화면 구현 (#29)`

---

### Phase 4: BoxDetail 진입점 및 라우팅 연결

**목표:** BoxDetail 화면에 + 버튼을 추가하고 라우팅을 연결한다.

**작업 파일:**

- `lib/core/routes.dart`
  - `/box/:id/custom-chord` 라우트 추가 (`CustomChordEditorScreen(boxId: ...)`)
- `lib/features/box/presentation/screens/box_detail_screen.dart`
  - 편집 모드가 아닐 때 AppBar actions 또는 FAB에 + 버튼 추가
  - 탭 시 `/box/:id/custom-chord`로 push

**완료 조건:**

- [ ] BoxDetail 화면에서 + 버튼이 표시된다
- [ ] + 버튼 탭 시 커스텀 운지 편집 화면으로 이동한다
- [ ] 편집 모드(isEditing=true)일 때는 + 버튼이 숨겨진다
- [ ] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: BoxDetail에 커스텀 운지 추가 진입점 연결 (#29)`

---

## 주의사항

- **재설치 방식 적용:** 스키마 변경이므로 기존 앱 삭제 후 재설치 필요. `schemaVersion`은 올리되 `onUpgrade` 마이그레이션은 작성하지 않는다. (정식 출시 전 비공개 테스트 단계)
- **frets 포맷:** `FlutterGuitarChord`와 `guitar_chord_library`가 사용하는 문자열 포맷을 Phase 3 작업 전에 반드시 확인한다.
- **Chord 필수 필드 기본값:** `root`, `type`, `difficulty`, `fullName` 컬럼은 NOT NULL이므로 커스텀 코드 삽입 시 기본값 처리 필요 (예: root="custom", type="custom", difficulty="beginner")
- **orphan 방지:** 커스텀 코드(isCustom=true)는 BoxChord 삭제 시 연결된 Chord/ChordPosition도 함께 삭제해야 한다.
- **search 필터:** `ChordDao.search()`에 `isCustom = false` 필터를 추가하여 커스텀 코드가 검색 화면에 노출되지 않도록 한다.

---

## 작업 시작 전 체크리스트

- [ ] `docs/architecture/` 문서 숙지 완료
- [ ] 관련 기존 코드 파악 완료 (box_detail_screen, chord_dao, chord_position_dao, box_chord_dao)
- [ ] `FlutterGuitarChord` frets/fingers 포맷 확인 완료
