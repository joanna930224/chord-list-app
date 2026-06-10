# Issue #13 - 기타코드 검색페이지

## 이슈 요약

> 기타 코드 검색(둘러보기) 화면 및 코드 상세 페이지를 구현한다.

---

## 전체 플로우

```
Search 탭 진입
  ├─ 최근 검색한 코드가 있는 경우
  │    ├─ "최근 검색한 코드" 섹션 타이틀 표시
  │    └─ 최근 검색 코드 그룹 목록 (가로 스크롤 카드)
  └─ 최근 검색한 코드가 없는 경우
       └─ 섹션 제목 없이 전체 코드 목록 (C 코드부터 순서대로)

검색 input에 텍스트 입력
  └─ 유연한 검색 (대소문자·기호 무관, 한글 지원, 공백 무시, 정확도 정렬)
      ├─ 결과 있음 → 정확도 순 필터된 코드 그룹 목록 표시
      └─ 결과 없음 → 빈 상태 텍스트

코드명 행 탭 (예: "C major")
  └─ 코드 상세 페이지 이동
      └─ 진입 시 최근 검색한 코드로 기록
          └─ 운지법 카드 탭
              └─ 보관함 추가 바텀시트 (라이브러리 로직 동일)
                  ├─ "새 Box 생성" → NewBoxDialog
                  └─ "기존 Box에 추가" → SelectBoxBottomSheetWidget
```

---

## UI 상세 명세

### Search 화면

**헤더 (스크롤 시 고정)**

- 좌상단 대형 텍스트: `"Search"` (bold, 라이브러리 메뉴 헤더 스타일 참고)
- 헤더 바로 아래: 검색 TextField
  - placeholder: `"코드 검색"`
  - 좌측 돋보기 아이콘 (`Icons.search`)
  - 둥근 모서리 배경
- 구현 방식: `Column` + 고정 헤더 영역 + `Expanded(child: ListView)` (라이브러리 메뉴 패턴)

**코드 그룹 행 (`ChordGroupRowWidget`)**

- 상단: 코드명 텍스트 (예: `"C major"`) — 탭 시 상세 페이지로 이동
- 하단: 해당 코드 운지법 카드를 가로 스크롤 `ListView`
  - `ChordPositionCardWidget` 재사용
  - 오른쪽 끝: `">"` chevron 아이콘 (`Icons.chevron_right`)
- 각 그룹 사이에 구분선 (`Divider`)

**상태별 UI**

- 최근 검색한 코드 있음: `"최근 검색한 코드"` 섹션 타이틀 → recentChords 그룹만 표시 (전체 코드 목록 미표시)
- 최근 검색한 코드 없음: 섹션 타이틀 없이 전체 코드 그룹만
- 검색어 입력 중: 섹션 타이틀 없이 filteredChords 그룹만 (정확도 순)
- 검색 결과 없음: 중앙 텍스트 `"검색 결과가 없습니다."`

### 코드 상세 페이지 (`ChordDetailScreen`)

**앱바**

- 타이틀: 코드 fullName (예: `"C major"`)
- 뒤로가기 버튼 (기본 제공)
- `CScaffold` 사용

**운지법 그리드**

- `SliverGrid`: `crossAxisCount = isLandscape ? 4 : 2`
- `crossAxisSpacing` / `mainAxisSpacing`: 12 (Box 상세페이지 동일)
- `ChordPositionCardWidget` 재사용
- 카드 탭 → `showChordSaveBottomSheet()` (공통 함수, `lib/shared/utils/chord_save_actions.dart`)

---

## 관련 파일

**신규 생성**

- `lib/shared/data/db/tables/recently_searched_chords_table.dart`
- `lib/shared/data/db/dao/recently_searched_chord_dao.dart`
- `lib/features/search/domain/use_cases/get_recent_chords_use_case.dart`
- `lib/features/search/domain/use_cases/get_all_chords_with_positions_use_case.dart`
- `lib/features/search/domain/use_cases/get_searched_chords_use_case.dart`
- `lib/features/search/domain/use_cases/record_recently_searched_use_case.dart`
- `lib/features/search/application/search_state.dart`
- `lib/features/search/application/search_view_model_provider.dart`
- `lib/features/search/presentation/widgets/chord_group_row_widget.dart`
- `lib/features/search/presentation/screens/chord_detail_screen.dart`
- `lib/shared/utils/chord_save_actions.dart`

**기존 파일 수정**

- `lib/shared/data/db/app_database.dart` — 테이블·DAO 추가 등록
- `lib/features/search/presentation/search_screen.dart` — 전면 재구현
- `lib/features/library/presentation/screens/library_screen.dart` — chord_save_actions 공통 함수 적용
- `lib/core/routes.dart` — `/chord/:id` 라우트 추가

---

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지
- 공통 컴포넌트는 해당 Phase에서 처음 실제로 사용되는 시점에 함께 구현

---

## 작업 단계

### Phase 1: DB 레이어 — 최근 검색한 코드 테이블 추가

**목표:** 사용자가 검색 후 탭한 코드를 기록하는 `RecentlySearchedChords` 테이블을 추가한다.

> DB 마이그레이션 없음. 개발 단계이므로 앱 삭제 후 재설치로 처리.

**작업 파일:**

- `lib/shared/data/db/tables/recently_searched_chords_table.dart` — 신규
  - `IntColumn get chordId` (references Chords)
  - `DateTimeColumn get searchedAt`
  - primaryKey: `{chordId}` (chord당 1행, upsert로 searchedAt 갱신)
- `lib/shared/data/db/dao/recently_searched_chord_dao.dart` — 신규
  - `upsert(int chordId)`: insert or update searchedAt (현재 시각)
  - `findRecent({int limit = 20})`: searchedAt 내림차순 조회
  - `deleteAll()`: 전체 삭제
- `lib/shared/data/db/app_database.dart` — 수정
  - `tables`, `daos`에 `RecentlySearchedChords`, `RecentlySearchedChordDao` 추가
- `build_runner` 재실행

**완료 조건:**

- [x] `RecentlySearchedChords` 테이블 및 DAO 생성됨
- [x] AppDatabase에 등록됨
- [x] build_runner 오류 없음
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 최근 검색한 코드 테이블 추가 (#13)`

---

### Phase 2: Search 도메인 & 상태 레이어

**목표:** 검색 화면에 필요한 Use Case, State, ViewModel을 구성한다.

**작업 파일:**

- `lib/features/search/domain/use_cases/get_recent_chords_use_case.dart` — 신규
  - `RecentlySearchedChordDao.findRecent()` 결과를 각 chordId로
    `ChordDao.findById()` + `ChordPositionDao.findByChordId()` 조합하여
    `List<ChordWithPositionsModel>` 반환
- `lib/features/search/domain/use_cases/get_all_chords_with_positions_use_case.dart` — 신규
  - `ChordDao.findAll()` + `ChordPositionDao.findByChordId()` 조합으로
    `List<ChordWithPositionsModel>` 반환
- `lib/features/search/domain/use_cases/record_recently_searched_use_case.dart` — 신규
  - `RecentlySearchedChordDao.upsert(chordId)` 호출
- `lib/features/search/domain/use_cases/get_searched_chords_use_case.dart` — 신규
  - `call(allChords, query)`: in-memory 필터링 + 정확도 정렬 반환
  - `_translateKorean()`: 한글 → 영어 치환 (메이저→major, 마이너→minor 등)
  - `_matchesQuery()`: 공백 무시 매칭 (emajor ↔ e major), name/fullName/aliases 검색
  - `_score()`: exact(100) > startsWith(80) > contains(60) 정확도 점수, aliases 포함
- `lib/features/search/application/search_state.dart` — 신규
  ```dart
  @CopyWith()
  class SearchState {
    final String query;
    final List<ChordWithPositionsModel> recentChords;
    final List<ChordWithPositionsModel> allChords;
    final List<ChordWithPositionsModel> filteredChords; // ViewModel이 계산해서 저장
  }
  ```
- `lib/features/search/application/search_view_model_provider.dart` — 신규
  - `build()`: recentChords + allChords 초기 로딩, filteredChords = allChords로 초기화
  - `search(String query)`: `GetSearchedChordsUseCase`로 필터링 후 state 갱신
  - `refreshRecent()`: DB에서 recentChords 재조회 후 state 갱신
  - build_runner 재실행 (search_state.g.dart)

**검색 예시 동작:**

| 검색어 | 매칭 코드 |
|--------|-----------|
| `Emajor` | E major (공백 무시) |
| `E메이저` | E major (한글 지원) |
| `Db` | C#/Db 코드 최상위 노출 (aliases score) |
| `diminished` | G# diminished, C diminished ... |
| `#` | G#, C# 등 # 포함 코드 전체 |

**완료 조건:**

- [x] Use Case 4개 구현됨 (get_recent, get_all, record, get_searched)
- [x] SearchState 및 .g.dart 생성됨
- [x] SearchViewModelProvider build() 정상 동작
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: Search 도메인 및 상태 레이어 구현 (#13)`

---

### Phase 3: Search Screen UI

**목표:** sticky 헤더 + 검색 input + 코드 그룹 목록을 구현한다.

**작업 파일:**

- `lib/features/search/presentation/widgets/chord_group_row_widget.dart` — 신규
  - 코드명 텍스트 행 (탭 가능) + 가로 스크롤 운지법 ListView + `>` 아이콘
  - `ChordPositionCardWidget` 재사용
- `lib/features/search/presentation/search_screen.dart` — 전면 재구현
  - `HookConsumerWidget` 사용
  - 레이아웃: `SafeArea` + `Column`
    - 고정 상단: `"Search"` 대형 헤더 + 검색 TextField (`useTextEditingController`)
    - 스크롤 영역: `Expanded(child: ListView)`
      - recentChords.isNotEmpty & query.isEmpty → `"최근 검색한 코드"` 타이틀 + recentChords 그룹만 표시
      - 그 외 → filteredChords 코드 그룹 목록 (`ChordGroupRowWidget`)
      - 빈 상태 처리
  - 코드명 행 탭 → `context.pushNamed(ChordDetailScreen.routeName, pathParameters: {'id': ...})`
  - 상세 페이지 복귀 후 `refreshRecent()` 호출

**완료 조건:**

- [x] 헤더 + 검색 input이 스크롤 시 고정됨
- [x] 최근 검색한 코드 섹션 조건부 표시 (최근 검색 있으면 전체 목록 미표시)
- [x] 전체 코드 목록 표시 (C 코드부터)
- [x] 검색어 입력 시 실시간 필터링 + 정확도 정렬 동작
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: Search 화면 UI 구현 (#13)`

---

### Phase 4: 코드 상세 페이지 + 라우트 연결

**목표:** 특정 코드의 운지법을 2열(landscape: 4열) 그리드로 보여주는 상세 페이지를 구현하고 라우팅을 연결한다.

**작업 파일:**

- `lib/features/search/presentation/screens/chord_detail_screen.dart` — 신규
  - `HookConsumerWidget`, `chordId` 파라미터
  - `useEffect(const [])`: 진입 시 `RecordRecentlySearchedUseCase(chordId)` 호출
  - 코드 + 운지법 로딩: `useMemoized` + `FutureValueWidget`
  - `CScaffold(title: Text(chord.fullName))`
  - `SliverGrid`: `crossAxisCount = isLandscape ? 4 : 2`, spacing: 12
  - 카드 탭 → `showChordSaveBottomSheet(context, chord, position)` (공통 함수 호출)
- `lib/shared/utils/chord_save_actions.dart` — 신규
  - `showChordSaveBottomSheet()`: ChordBottomSheetWidget → NewBoxDialog / SelectBoxBottomSheetWidget
  - LibraryScreen, ChordDetailScreen 공통 사용
- `lib/features/library/presentation/screens/library_screen.dart` — 수정
  - 기존 `_handleCardTap`, `_showNewBoxDialog`, `_showSelectBoxSheet` 제거
  - `showChordSaveBottomSheet()` 호출로 교체
- `lib/core/routes.dart` — 수정
  - `/chord/:id` 라우트 추가 → `ChordDetailScreen(chordId: int.parse(...))`

**완료 조건:**

- [x] 코드 상세 페이지 진입 시 운지법 그리드 표시됨
- [x] 세로 2열 / 가로 4열 전환 정상 동작
- [x] 운지법 카드 탭 시 보관함 추가 바텀시트 표시
- [x] 상세 페이지 진입 시 해당 코드가 최근 검색한 코드로 기록됨
- [x] Search 화면에서 코드명 탭 시 라우팅 정상 동작
- [x] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 코드 상세 페이지 구현 (#13)`

---

## 주의사항

- **앱 재설치 필수**: Phase 1 완료 후 테스트 시 앱 삭제 후 재빌드 필요 (`RecentlySearchedChords` 테이블 추가)
- **보관함 저장 공통 함수**: `showChordSaveBottomSheet()` (`lib/shared/utils/chord_save_actions.dart`) — LibraryScreen, ChordDetailScreen 공통 사용. 별도 복사 금지
- **filteredChords 계산 위치**: `GetSearchedChordsUseCase`에서 처리. ViewModel은 UseCase 호출 후 결과를 state에 저장. DB 재조회 없음
- **검색 기록 시점**: 코드명 행을 탭하여 상세 페이지에 진입하는 시점에 기록. 검색어 입력만으로는 기록하지 않음
- **검색 지원 범위**: 대소문자 무관, 공백 무시(emajor↔e major), 한글 지원(메이저→major), aliases 포함, 정확도 기반 정렬
- **`ChordWithPositionsModel`**: `lib/shared/models/`로 이동 완료. `lib/features/library/domain/models/`는 re-export로 유지

---

## 작업 시작 전 체크리스트

- [x] `docs/architecture/` 문서 숙지 완료
- [x] `LibraryScreen`, `BoxDetailScreen` 구현 파악 완료
- [x] `ChordDao`, `ChordPositionDao` 메서드 확인 완료
- [x] `ChordBottomSheetWidget` 바텀시트 흐름 파악 완료
