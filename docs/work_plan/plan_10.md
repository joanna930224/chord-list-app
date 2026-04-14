# Issue #10 - Box DB 설계 및 Box 페이지 UI 구현

## 이슈 요약

> Box DB를 설계하고, 저장된 코드 컬렉션 리스트를 탐색·정렬할 수 있는 Box 페이지 UI를 구현한다.

## 관련 파일

**기존 파일 (수정)**

- `lib/shared/data/db/app_database.dart` — 신규 테이블·DAO 등록
- `lib/features/box/presentation/screens/box_screen.dart` — Placeholder 제거 후 실제 UI 연결, 정렬 버튼 제거(AppBar로 이동)
- `lib/features/box/presentation/widgets/app_bar.dart` — 정렬 버튼 actions로 이동
- `lib/core/routes.dart` — `/box/:id` 라우트 추가, `pushNamed` 적용
- `lib/core/initialization.dart` — 개발용 seed 데이터 트리거 추가
- `pubspec.yaml` — `intl: ^0.20.2` 추가

**신규 파일**

- `lib/shared/data/db/tables/boxes_table.dart`
- `lib/shared/data/db/tables/box_chords_table.dart`
- `lib/shared/data/db/dao/box_dao.dart` + `box_dao.g.dart`
- `lib/shared/data/db/dao/box_chord_dao.dart` + `box_chord_dao.g.dart`
- `lib/shared/data/db/seed/box_seed_data.dart`
- `test/shared/data/db/box_dao_test.dart`
- `test/shared/data/db/box_chord_dao_test.dart`
- `lib/features/box/domain/models/chord_box_model.dart`
- `lib/features/box/application/box_state.dart` + `box_state.g.dart`
- `lib/features/box/application/box_view_model_provider.dart`
- `lib/features/box/presentation/widgets/box_list_tile_widget.dart`
- `lib/features/box/presentation/widgets/box_sort_button_widget.dart`
- `lib/features/box/presentation/widgets/box_empty_widget.dart`
- `lib/features/box/presentation/screens/box_detail_screen.dart` (임시)

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 의존성이 생기는 경우, 참조 대상(stub 포함)과 참조 코드를 같은 Phase로 묶는다
- Phase 간 순서는 "컴파일 가능 상태 유지"를 최우선으로 설계한다

## 작업 단계

### Phase 1: Box DB 설계 및 구축

**목표:** `ChordBoxes`, `BoxChords` 스키마 정의 + DAO 구현 + AppDatabase 등록 + 코드 생성

**작업 파일:**

- `lib/shared/data/db/tables/boxes_table.dart` — 신규
  - `@DataClassName('ChordBox')` + `class ChordBoxes extends Table`
  - (`Boxes`로 생성 시 Drift가 `ChordBoxe`로 singularize하는 문제로 `ChordBoxes`로 명명)
  - 컬럼: `id`, `title`(text), `description`(text, nullable), `createdAt`(dateTime)
- `lib/shared/data/db/tables/box_chords_table.dart` — 신규
  - 컬럼: `id`, `boxId`(→ ChordBoxes), `chordPositionId`(→ ChordPositions), `savedAt`(dateTime)
- `lib/shared/data/db/dao/box_dao.dart` — 신규
  - `BoxSortType` enum 정의 (createdAtDesc, createdAtAsc, titleAsc, titleDesc)
  - `watchAll(BoxSortType)` — 정렬 조건 포함 전체 조회 (Stream)
  - `findById(int)` — 단일 조회
  - `insertBox(ChordBoxesCompanion)` — Box 생성
  - `deleteById(int)` — Box 삭제
  - 반환 타입: `ChordBox`
- `lib/shared/data/db/dao/box_chord_dao.dart` — 신규
  - `watchByBoxId(int)` — 특정 Box의 코드 목록 조회 (Stream)
  - `insertBoxChord(BoxChordsCompanion)` — 코드 저장
  - `existsInBox(int boxId, int chordPositionId)` — 중복 확인
  - `deleteBoxChord(int boxId, int chordPositionId)` — 코드 삭제
- `lib/shared/data/db/app_database.dart` — 수정
  - `tables`에 `ChordBoxes`, `BoxChords` 추가
  - `daos`에 `BoxDao`, `BoxChordDao` 추가
- `lib/shared/data/db/seed/box_seed_data.dart` — 신규
  - 개발자 전용 샘플 Box 15개 삽입 (`--dart-define=SEED_BOXES=true` 시 실행)
  - `kDebugMode` guard + 기존 데이터 존재 시 skip
- `lib/core/initialization.dart` — 수정
  - `_seedBoxes = bool.fromEnvironment('SEED_BOXES')` + seed 트리거 추가
- `test/shared/data/db/box_dao_test.dart` — 신규 (9개 테스트)
  - `insert`: 삽입 후 조회 검증
  - `watchAll`: 정렬 타입별 순서 검증
  - `deleteById`: 삭제 후 null 반환 검증
- `test/shared/data/db/box_chord_dao_test.dart` — 신규 (4개 테스트)
  - `insertBoxChord`: 삽입 후 `watchByBoxId`로 조회 검증
  - `existsInBox`: 존재하는 항목 true / 없는 항목 false 검증
  - `watchByBoxId`: 다른 boxId 데이터와 격리 검증

**완료 조건:**

- [x] `flutter pub run build_runner build --delete-conflicting-outputs` 오류 없음
- [x] `flutter test test/shared/data/db/box_dao_test.dart` 전체 통과 (9개)
- [x] `flutter test test/shared/data/db/box_chord_dao_test.dart` 전체 통과 (4개)
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Box DB 테이블 및 DAO 구현 (#10)`

---

### Phase 2: Box ViewModel 및 상태 관리 구현

**목표:** 정렬 상태를 포함한 Box 리스트 상태관리 구현

**작업 파일:**

- `lib/features/box/domain/models/chord_box_model.dart` — 신규
  - Drift 생성 타입(`ChordBox`)과 분리된 도메인 모델
  - `ChordBoxModel.fromData(ChordBox data)` factory 제공
- `lib/features/box/application/box_state.dart` — 신규
  - 필드: `List<ChordBoxModel> boxes`, `BoxSortType sortType`
  - `@CopyWith()` 적용 (`ChordBox` Drift 타입 직접 사용 시 `InvalidType` 생성 문제로 도메인 모델 사용)
- `lib/features/box/application/box_view_model_provider.dart` — 신규
  - `AsyncNotifierProvider.autoDispose<BoxViewModelNotifier, BoxState>`
  - `build()`: `BoxDao.watchAll` 구독, Stream 실시간 반영
  - `changeSortType(BoxSortType)` 메서드
- `pubspec.yaml` — 수정: `intl: ^0.20.2` 추가 (날짜 포맷용)

**완료 조건:**

- [x] `flutter pub run build_runner build --delete-conflicting-outputs` 오류 없음
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Box 상태관리 ViewModel 구현 (#10)`

---

### Phase 3: Box 페이지 UI 구현

**목표:** 리스트 타일·정렬·빈 상태 UI 구현 + 상세 페이지 라우트 연결

**작업 파일:**

- `lib/features/box/presentation/widgets/box_list_tile_widget.dart` — 신규
  - 썸네일(박스 아이콘), 제목, 설명(없으면 미표기), 생성일, 저장 코드 내역(말줄임)
  - `CScaleButton` 래핑으로 스케일 애니메이션 + 햅틱 처리
  - 파라미터: `box`, `chordNames`, `onTap`
- `lib/features/box/presentation/widgets/box_sort_button_widget.dart` — 신규
  - 현재 정렬 기준 표시 + 탭 시 BottomSheet로 정렬 옵션 선택
  - **AppBar actions에 배치** (초기 리스트 상단에서 위치 변경)
- `lib/features/box/presentation/widgets/box_empty_widget.dart` — 신규
  - `Icons.inventory_2_outlined` + "Box가 비어있어요.\nBox에 기타 코드들을 담아보세요." 문구
- `lib/features/box/presentation/screens/box_detail_screen.dart` — 신규 (임시)
  - `CScaffold` + 빈 body
- `lib/features/box/presentation/widgets/app_bar.dart` — 수정
  - `actions`에 `BoxSortButtonWidget` 추가
- `lib/core/routes.dart` — 수정
  - `/box/:id` 단일 라우트 → `BoxDetailScreen`
- `lib/features/box/presentation/screens/box_screen.dart` — 수정
  - `Placeholder` 제거, `boxViewModelProvider` 연결
  - 데이터 있을 때: `SliverList` with `BoxListTileWidget`
  - 데이터 없을 때: `BoxEmptyWidget`
  - 리스트 탭: `context.pushNamed()` 사용 (탭 내부→상세 라우트 뒤로가기 정상 동작)

**완료 조건:**

- [x] Box 리스트 정상 렌더링 확인 (seed 데이터 15개)
- [x] 정렬 버튼 탭 시 정렬 순서 변경 확인
- [x] 빈 상태 UI 표시 확인
- [x] 리스트 탭 시 상세 페이지로 라우트 이동 확인
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Box 페이지 UI 구현 (#10)`

---

## 주의사항

- DB 변경 후 반드시 `build_runner` 재실행 필요 (`.g.dart` 파일 재생성)
- 배포 전 개발 단계이므로 `schemaVersion` 변경 및 마이그레이션 불필요 — 앱 삭제 후 재빌드로 대응
- `ChordBoxes` 테이블 클래스명: Drift의 singularize 규칙으로 `Boxes` → `Box`(Flutter 충돌), `ChordBoxes` → `ChordBoxe`(이상) 문제로 `@DataClassName('ChordBox')` 병행 사용
- `@CopyWith()`와 Drift 생성 타입 혼용 시 `InvalidType` 에러 — 도메인 모델(`ChordBoxModel`)로 분리해서 해결
- `BoxListTileWidget`은 이후 이슈 #18 (코드 저장 바텀시트)에서 재사용 예정
- 라이브러리/검색 페이지와의 연동은 별도 이슈에서 처리
- 개발용 seed 실행: `flutter run --dart-define=SEED_BOXES=true` (기존 데이터 있으면 skip)

## 작업 시작 전 체크리스트

- [x] `docs/architecture/` 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료 (기존 `ChordDao`, `ChordPositionDao` 패턴 참고)
- [x] 기존 `ChordDao`, `ChordPositionDao` DAO 패턴 숙지
