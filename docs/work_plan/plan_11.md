# Issue #11 - 기타 코드 DB 설계 및 구축

## 이슈 요약

> 기타 코드 운지법 학습 앱(ChordBox)에 필요한 로컬 DB를 구축한다.
> `guitar_chord_library` 패키지 데이터를 기반으로 코드명·운지법·루트·타입·난이도·베이스음·별칭 등을 Drift(SQLite ORM)로 관리하며,
> 기존 SharedPreferences(테마/햅틱 전용)와 완전 분리하여 구성한다.
> 운지법 UI는 추후 `flutter_guitar_chord` 패키지를 활용할 예정.

## 관련 파일

- `lib/shared/data/db/app_database.dart` — DB 진입점
- `lib/shared/data/db/tables/chords_table.dart` — Chords 테이블
- `lib/shared/data/db/tables/chord_positions_table.dart` — ChordPositions 테이블
- `lib/shared/data/db/dao/chord_dao.dart` — Chords DAO
- `lib/shared/data/db/dao/chord_position_dao.dart` — ChordPositions DAO
- `lib/shared/data/db/seed/chord_seed_data.dart` — 초기 데이터 삽입 함수
- `lib/shared/providers/database_provider.dart` — AppDatabase Provider
- `lib/shared/utils/logger.dart` — 앱 공통 Logger 인스턴스
- `test/shared/data/db/seed_data_test.dart` — Seed 데이터 검증 테스트
- `test/shared/data/db/chord_dao_test.dart` — ChordDao 단위 테스트
- `test/shared/data/db/chord_position_dao_test.dart` — ChordPositionDao 단위 테스트

## 최종 디렉토리 구조

```
lib/shared/
├── data/
│   └── db/
│       ├── app_database.dart
│       ├── app_database.g.dart            # build_runner 자동 생성 (.gitignore)
│       ├── tables/
│       │   ├── chords_table.dart
│       │   └── chord_positions_table.dart
│       ├── dao/
│       │   ├── chord_dao.dart
│       │   ├── chord_dao.g.dart           # build_runner 자동 생성 (.gitignore)
│       │   ├── chord_position_dao.dart
│       │   └── chord_position_dao.g.dart  # build_runner 자동 생성 (.gitignore)
│       └── seed/
│           └── chord_seed_data.dart
├── providers/
│   ├── database_provider.dart
│   └── preference_provider.dart          # 기존 유지 (테마/햅틱 전용)
└── utils/
    └── logger.dart
test/shared/data/db/
├── seed_data_test.dart
├── chord_dao_test.dart
└── chord_position_dao_test.dart
```

## DB 스키마

### chords 테이블

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | INTEGER PK | 자동 증가 |
| name | TEXT | 코드 표기명 (C, Am, C/E, Cm/G) |
| full_name | TEXT | 전체명 (C major, C minor over E bass) |
| root | TEXT | 루트 음 (C, C#, D ... B) |
| type | TEXT | 코드 타입 (major, minor, 7, maj7 등) |
| bass | TEXT? | 슬래시 코드 베이스음 nullable (C/E → E) |
| difficulty | TEXT | 난이도 (beginner/intermediate/advanced) |
| is_barre_chord | BOOLEAN | 바레 코드 여부 (default false) |
| aliases | TEXT? | 이명동음 별칭 nullable (C# → Db, C#/E → Db/E) |

> **슬래시 코드 설계 원칙:** `type`과 `bass`를 분리하여 저장.
> `C/E`는 `root=C, type=major, bass=E`로 표현. type에 `/`를 포함하지 않음.

### chord_positions 테이블

| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | INTEGER PK | 자동 증가 |
| chord_id | INTEGER FK | chords.id 참조 |
| base_fret | INTEGER | 시작 프렛 번호 |
| frets | TEXT | 줄별 프렛 (예: "-1 3 2 0 1 0") |
| fingers | TEXT | 손가락 번호 (예: "0 3 2 0 1 0") |
| position_index | INTEGER | 운지법 순서 (0부터, 오름차순 정렬) |

---

## Phase 구성 원칙

각 Phase 완료 시점에 `flutter analyze` 오류 0개 + 컴파일 가능 상태 유지.
미래 Phase에 의존하는 코드는 해당 Phase에 포함 금지.

---

## 작업 단계

### Phase 1: 테이블 정의

**목표:** Drift 테이블 클래스 정의 (build_runner 불필요)

**작업 파일:**
- `lib/shared/data/db/tables/chords_table.dart` — Chords 테이블 (bass 컬럼 포함)
- `lib/shared/data/db/tables/chord_positions_table.dart` — ChordPositions 테이블

**완료 조건:**
- [x] 테이블 2개 정의 완료
- [x] flutter analyze 오류 없음

**커밋 메시지:** `feat : drift 테이블 정의 - chords, chord_positions (#11)`

---

### Phase 2: AppDatabase + Provider

**목표:** AppDatabase 정의 + build_runner 실행 + Riverpod Provider 등록

**작업 파일:**
- `lib/shared/data/db/app_database.dart` — @DriftDatabase, schemaVersion=1, 테스트용 `.memory()` 생성자 포함
- `lib/shared/providers/database_provider.dart` — `Provider<AppDatabase>`, onDispose 포함

**핵심 패턴:**
```dart
@DriftDatabase(tables: [Chords, ChordPositions], daos: [ChordDao, ChordPositionDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'chord_box.db'));

  @visibleForTesting
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await insertSeedData(this);
    },
  );
}
```

**완료 조건:**
- [x] app_database.g.dart 생성 완료
- [x] Provider 등록 완료
- [x] flutter analyze 오류 없음

**커밋 메시지:** `feat : AppDatabase 진입점 및 Provider 구성 (#11)`

---

### Phase 3: DAO 구현

**목표:** 쿼리 로직 캡슐화, app_database.dart에 DAO 연결

**작업 파일:**
- `lib/shared/data/db/dao/chord_dao.dart` — 전체조회, root/type 필터, name·fullName 검색, 단건조회, CRUD
- `lib/shared/data/db/dao/chord_position_dao.dart` — chordId로 positionIndex 오름차순 조회, 삽입, 삭제

**완료 조건:**
- [x] .g.dart 파일 3개 생성 완료 (app_database, chord_dao, chord_position_dao)
- [x] flutter analyze 오류 없음

**커밋 메시지:** `feat : ChordDao, ChordPositionDao 구현 (#11)`

---

### Phase 4: Seed Data + DB onCreate 연결

**목표:** `guitar_chord_library` 패키지 데이터를 앱 최초 실행 시 Drift DB에 삽입.
슬래시 코드는 `type`과 `bass`를 분리하여 정규화된 구조로 저장한다.

**의존 패키지 (pubspec.yaml):**
```yaml
guitar_chord_library: ^0.0.4
logger: ^2.7.0
```

**데이터 흐름:**
```
guitar_chord_library
  └─ instrument.getChordPositions(root, suffix)
        └─ ChordPosition { baseFret: int, frets: String, fingers: String }
              └─ db.transaction() 내에서 Drift DB 삽입
                    ├─ chords 테이블 (root, type, bass, name, fullName, difficulty, isBarreChord, aliases)
                    └─ chord_positions 테이블 (chordId, baseFret, frets, fingers, positionIndex)
```

**seed 구조:**
- 루트: 12음 (C ~ B, 샵 표기)
- 일반 타입: 43종 (major, minor, 7, maj7, dim, aug, sus 계열, 확장 코드 등)
- 슬래시 코드: 23종 (major/bass 12개, minor/bass 10개, 7/G 1개)
- b(플랫) 이명동음은 `aliases`에 저장 (C# → Db, C#/E → Db/E)
- 전체 삽입은 `db.transaction()`으로 원자성 보장

**완료 조건:**
- [x] `guitar_chord_library`, `logger` pubspec.yaml 추가 완료
- [x] 앱 최초 실행 시 seed 데이터 삽입 (logger로 확인)
- [x] 앱 재실행 시 중복 삽입 없음 (MigrationStrategy.onCreate는 1회만 실행)
- [x] main.dart 수정 없음
- [x] flutter analyze 오류 없음

**커밋 메시지:** `feat : guitar_chord_library 기반 시드 데이터 삽입 (#11)`

---

### Phase 5: 단위 테스트

**목표:** Drift 인메모리 DB로 seed·DAO 동작 검증

**작업 파일:**
- `test/shared/data/db/seed_data_test.dart` — seed 삽입, 루트, 타입, 운지법, aliases, 슬래시 코드 bass 컬럼 검증
- `test/shared/data/db/chord_dao_test.dart` — findAll, findByRoot, findByType, search, findById, insert/update/delete
- `test/shared/data/db/chord_position_dao_test.dart` — findByChordId, 정렬, 삽입, 삭제

**완료 조건:**
- [x] 전체 테스트 통과 (25개)
- [x] flutter analyze 오류 없음

**커밋 메시지:** `test : DB seed 및 DAO 단위 테스트 추가 (#11)`

---

## 주의사항

- **schemaVersion = 1** 고정. 향후 컬럼 추가 시 올리고 `onUpgrade`에 `m.addColumn` 추가
- **autoDispose 금지**: `appDatabaseProvider`는 앱 전역 자원
- **FK cascade 없음**: chord 삭제 시 `chordPositionDao.deleteByChordId(id)` 수동 호출 필요
- **.g.dart는 .gitignore 처리**: 클론 후 `flutter pub run build_runner build --delete-conflicting-outputs` 실행 필요
- **seed 버전 관리**: seed 데이터 변경 시 `schemaVersion`을 올리고 `onUpgrade`에서 재삽입 처리
- **ChordPosition 명칭 충돌**: `chord_seed_data.dart`에서 Drift 생성 `ChordPosition`과 `guitar_chord_library`의 `ChordPosition`이 충돌 → `app_database.dart` import에 `hide ChordPosition` 적용

## 작업 시작 전 체크리스트

- [x] docs/architecture/ 문서 숙지 완료
- [x] 관련 기존 코드 파악 완료
