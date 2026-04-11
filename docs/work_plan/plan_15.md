# Issue #15 - 코드 라이브러리 페이지의 코드 운지 리스트

## 이슈 요약

> 코드 라이브러리 페이지에서 루트음과 코드 타입을 선택해 DB 기반으로 해당 코드의 운지법 목록을 탐색하고, 운지 위젯 클릭 시 바텀시트를 트리거하는 화면을 구현한다.

## 관련 파일

**기존 수정 파일:**

- `lib/features/home/presentation/screens/home_screen.dart` — 바텀 네비게이션바에 Library 탭 추가
- `lib/core/routes.dart` — LibraryScreen 라우트 등록 불필요 (HomeScreen 내 IndexedStack 방식)
- `lib/shared/data/db/seed/chord_seed_data.dart` — ChordRoot / ChordType / ChordDifficulty enum 적용

**신규 생성 파일:**

- `lib/shared/models/chord_root.dart` — 루트음 enum (`dbKey`, `label`, `flatKey` extension)
- `lib/shared/models/chord_type.dart` — 코드 타입 enum (`dbKey`, `nameSuffix`, `fullName`, `symbolNotation`, `textNotation` extension, `ChordNotationStyle` enum 포함)
- `lib/shared/models/chord_difficulty.dart` — 난이도 enum (`dbKey` extension)
- `lib/shared/providers/notation_style_provider.dart` — 코드 표기 스타일 AsyncNotifier (SharedPreferences 영구 저장)
- `lib/features/library/domain/models/chord_with_positions_model.dart` — Chord + ChordPosition 조합 모델
- `lib/features/library/domain/use_cases/get_chord_types_use_case.dart` — DB에서 타입 목록 조회
- `lib/features/library/domain/use_cases/get_chord_positions_use_case.dart` — root+type 기반 운지법 조회
- `lib/features/library/application/library_state.dart` — 상태 정의
- `lib/features/library/application/library_view_model_provider.dart` — ViewModel
- `lib/features/library/presentation/screens/library_screen.dart` — 메인 화면 (LibraryScreen / \_LibraryBody / \_ChordPositionGrid 3단 분리)
- `lib/features/library/presentation/widgets/root_selector_widget.dart` — 루트 버튼 가로 스크롤
- `lib/features/library/presentation/widgets/type_selector_widget.dart` — 타입 세로 스크롤 (notation style 연동)
- `lib/features/library/presentation/widgets/chord_position_card_widget.dart` — 운지 다이어그램 카드
- `lib/features/library/presentation/widgets/chord_notation_toggle.dart` — ♩/Aa 슬라이딩 세그먼트 토글 위젯

**기존 수정 파일 추가:**

- `lib/shared/providers/preference_provider.dart` — `findNotationStyle` / `saveNotationStyle` 추가

**참조 파일:**

- `lib/shared/data/db/dao/chord_dao.dart` — `findByRoot()` 활용
- `lib/shared/data/db/dao/chord_position_dao.dart` — `findByChordId()` 활용
- `lib/shared/providers/database_provider.dart` — `appDatabaseProvider`
- `lib/core/theme.dart` — 라이트/다크 테마 적용
- `lib/shared/exports.dart` — 공통 import

---

## 패키지 현황

| 패키지                            | 역할                                  | 상태      |
| --------------------------------- | ------------------------------------- | --------- |
| `guitar_chord_library ^0.0.4`     | 코드 데이터 제공 (이미 seed에서 사용) | 기설치    |
| `flutter_guitar_chord ^0.0.3`     | CustomPainter 기반 운지 렌더링 위젯   | 설치 완료 |
| `copy_with_extension ^14.0.0`     | State 클래스 copyWith 코드 생성       | 설치 완료 |
| `copy_with_extension_gen ^14.0.0` | copy_with_extension 빌더 (dev)        | 설치 완료 |

**`FlutterGuitarChord` 위젯 주요 파라미터 (모두 DB의 `chord_positions` 컬럼과 매핑):**

```dart
FlutterGuitarChord(
  frets: position.frets,       // chord_positions.frets
  fingers: position.fingers,   // chord_positions.fingers
  baseFret: position.baseFret, // chord_positions.base_fret
  chordName: chord.name,       // chords.name
  // 색상은 테마에 맞게 커스텀 가능
)
```

## 이명동음 처리

- 루트음은 `ChordRoot` enum으로 관리. `ChordRoot.values`로 12개 순회
- UI 라벨: `root.label` — 이명동음은 자동으로 이중 표기 (예: `C#•D♭`)
- DB 조회 키: `root.dbKey` — 항상 `#` 표기 (예: `C#`, `D#`)
- 플랫 표기: `root.flatKey` — 해당 없는 루트는 `null` (예: `ChordRoot.c.flatKey == null`)

---

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 의존성이 생기는 경우, 참조 대상과 참조 코드를 같은 Phase로 묶는다

---

## 작업 단계

### Phase 1: Library 화면 기본 뼈대 + 네비게이션 연결 ✅

**목표:** LibraryScreen 빈 화면 생성 및 홈 바텀 네비게이션바에 Library 탭 추가

**작업 파일:**

- `lib/features/library/presentation/screens/library_screen.dart` — 빈 Scaffold 화면 생성
- `lib/features/home/presentation/screens/home_screen.dart` — Library 탭 추가 (IndexedStack, BottomNavigationBarItem)

**완료 조건:**

- [x] 홈 바텀 네비게이션바에 Library 탭이 보인다
- [x] Library 탭 클릭 시 빈 LibraryScreen으로 전환된다
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 라이브러리 탭 네비게이션 추가 (#15)`

---

### Phase 2: Domain — UseCase 및 모델 구현 ✅

**목표:** DB에서 코드 타입 목록 및 root+type 기반 운지법 조회 로직 구현

**작업 파일:**

- `lib/features/library/domain/models/chord_with_positions_model.dart`
  - `Chord` + `List<ChordPosition>` 를 묶는 불변 모델
- `lib/features/library/domain/use_cases/get_chord_types_use_case.dart`
  - `ChordDao.findByRoot(root.dbKey)`로 조회 후 `ChordType.fromDbKey()`로 변환, 중복 제거하여 `List<ChordType>` 반환
- `lib/features/library/domain/use_cases/get_chord_positions_use_case.dart`
  - `ChordRoot` + `ChordType`으로 `Chord` 조회 후 각 `Chord`의 `ChordPosition` 목록 조회하여 `List<ChordWithPositions>` 반환

**완료 조건:**

- [x] 모델 및 UseCase 클래스가 컴파일 오류 없이 작성됨
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 라이브러리 도메인 모델 및 UseCase 구현 (#15)`

---

### Phase 3: Application — State 및 ViewModel 구현 ✅

**목표:** 루트/타입 선택 상태 및 DB 조회 결과를 관리하는 ViewModel 구현

**작업 파일:**

- `lib/features/library/application/library_state.dart`
  ```
  - selectedRoot: ChordRoot  (초기값: ChordRoot.c)
  - selectedType: ChordType  (초기값: ChordType.major)
  - types: List<ChordType>   (선택된 루트에 해당하는 타입 목록)
  - chordPositions: List<ChordWithPositions>
  ```

  - `@CopyWith()` 어노테이션 사용 (copy_with_extension)
- `lib/features/library/application/library_view_model_provider.dart`
  - Riverpod 3.x: `AsyncNotifierProvider.autoDispose` + `AsyncNotifier` 방식
  - 초기 빌드 시 `ChordRoot.c`, `ChordType.major`로 데이터 로드
  - `selectRoot(ChordRoot root)`: 루트 변경 → 타입 목록 갱신 → 첫 번째 타입으로 운지 목록 갱신
  - `selectType(ChordType type)`: 타입 변경 → 운지 목록 갱신

**완료 조건:**

- [x] ViewModel이 컴파일 오류 없이 작성됨
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 라이브러리 상태관리 ViewModel 구현 (#15)`

---

### Phase 4: Presentation — 고정 헤더 위젯 구현 (루트 셀렉터 + 타입 셀렉터)

**목표:** 루트 버튼 가로 스크롤 위젯 및 타입 세로 스크롤 위젯 구현

**작업 파일:**

- `lib/features/library/presentation/widgets/root_selector_widget.dart`
  - `ChordRoot.values`를 순회하여 버튼 렌더링
  - 버튼 라벨: `root.label` — 이명동음 자동 이중 표기 (예: `C#•D♭`)
  - 선택된 루트는 강조 스타일 적용 (테마 색상 활용)
  - 가로 스크롤 (`SingleChildScrollView` + `Row`)
- `lib/features/library/presentation/widgets/type_selector_widget.dart`
  - ViewModel의 `types: List<ChordType>` 기반 세로 스크롤 목록
  - 버튼 라벨: `type.dbKey` (예: `major`, `m7`)
  - 선택된 타입 강조 스타일
  - 고정 영역 (`ListView` 또는 `SingleChildScrollView` + `Column`)

**완료 조건:**

- [x] 루트 버튼이 가로로 나열되고 이명동음이 하나의 버튼으로 표기된다
- [x] 타입 목록이 세로로 스크롤된다
- [x] 선택 상태가 ViewModel과 연동된다
- [x] 라이트/다크 테마가 정상 적용된다
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 라이브러리 루트/타입 셀렉터 위젯 구현 (#15)`

---

### Phase 5: Presentation — 운지 카드 위젯 + 그리드 영역 구현 ✅

**목표:** 운지 다이어그램 카드 위젯 및 2열 그리드 레이아웃 구현, 코드 표기 스타일 토글 추가

**작업 파일:**

- `lib/features/library/presentation/widgets/chord_position_card_widget.dart`
  - `flutter_guitar_chord` 패키지의 CustomPainter 기반 운지 다이어그램 렌더링
  - 테마 적용 카드 스타일
  - `GestureDetector`로 탭 이벤트 수신 → 바텀시트 트리거
- `lib/features/library/presentation/widgets/chord_notation_toggle.dart`
  - ♩(symbol) / Aa(text) 슬라이딩 세그먼트 토글 위젯
  - `AnimatedPositioned` 기반 선택 인디케이터 좌우 슬라이드
- `lib/shared/models/chord_type.dart`
  - `ChordNotationStyle` enum 추가 (symbol / text)
  - `symbolNotation` extension getter 추가 (°, +, ♭, ♯, ø, M 등 악보 기호)
  - `textNotation` extension getter 추가 (dim, aug, b, # 등 텍스트)
- `lib/shared/providers/notation_style_provider.dart`
  - `ChordNotationStyle` AsyncNotifier — `toggle()` 메서드, SharedPreferences 영구 저장
- `lib/shared/providers/preference_provider.dart`
  - `findNotationStyle` / `saveNotationStyle` 추가
- `lib/features/library/presentation/screens/library_screen.dart`
  - 전체 레이아웃 구성 및 위젯 분리 리팩토링:
    - `LibraryScreen`: state.when 분기만 담당
    - `_LibraryBody`: 타이틀 + 토글 + 루트셀렉터 + 타입/그리드 영역
    - `_ChordPositionGrid`: 빈 상태 / 2열 그리드 / 바텀시트 트리거
  - 코드명 타이틀: `fullName` 고정 표기 (예: "C dominant 7th")
  - 타이틀 우측 ChordNotationToggle 배치

**완료 조건:**

- [x] 코드명 타이틀이 선택에 따라 업데이트된다 (예: "C major")
- [x] 운지 카드가 2열 그리드로 표시된다
- [x] 운지 카드 클릭 시 바텀시트가 열린다 (내용은 빈 바텀시트)
- [x] 라이트/다크 테마가 정상 적용된다
- [x] 코드 표기 스타일 토글(♩/Aa)이 타입 셀렉터 표기를 전환한다
- [x] 표기 스타일 설정이 앱 재시작 후에도 유지된다
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 라이브러리 운지 그리드 및 화면 완성 (#15)`

---

## 주의사항

- **패키지**: `flutter_guitar_chord: ^0.0.3`, `copy_with_extension: ^14.0.0` 설치 완료
- **이명동음 처리**: `ChordRoot` enum의 `label` / `dbKey` / `flatKey` extension으로 일원화. 수동 맵 불필요
- **타입 목록**: `List<ChordType>` 반환. 루트 변경 시 DB에서 실제 존재하는 타입만 조회하여 `ChordType.fromDbKey()`로 변환
- **바텀시트**: 클릭 트리거만 구현. 내부 UI/기능은 별도 이슈에서 구현
- **`FlutterGuitarChord` 색상**: 기본값이 모두 black(`0xff000000`)이므로 다크 테마에서는 색상 파라미터 명시적으로 변경 필요
- **Riverpod 3.x**: `AutoDisposeAsyncNotifier` 삭제됨. `AsyncNotifier` + `AsyncNotifierProvider.autoDispose` 조합 사용

## 작업 시작 전 체크리스트

- [x] docs/architecture/ 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료 (home_screen, chord_dao, chord_position_dao, theme)
- [x] 사전 확인 사항 2가지 사용자 승인 완료
