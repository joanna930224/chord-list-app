# Issue #20 - Box 상세페이지 편집 모드 (코드 카드 순서 변경·삭제)

## 이슈 요약

> Box 상세페이지에서 저장된 코드 운지법 카드의 순서를 변경하고 삭제할 수 있는 편집 모드를 제공한다.

---

## 전체 플로우

```
Box 상세페이지 — 카드 롱프레스
  └─ 편집 모드 전환
      ├─ 카드 흔들림 애니메이션 시작
      ├─ 앱바: 좌측 "취소" / 우측 "저장" 버튼으로 전환
      ├─ 각 카드 좌상단에 "−" 버튼 표시
      ├─ "−" 탭 → 해당 카드 목록에서 제거 (로컬 상태만 변경)
      ├─ 카드 드래그 → 순서 변경 (로컬 상태만 변경)
      ├─ 취소 탭 → 변경사항 없이 일반 모드 복귀
      └─ 저장 탭
          ├─ 성공 → 삭제·순서 변경 DB 반영 + 일반 모드 복귀
          └─ 실패 → CToast "오류가 발생하였습니다."
```

---

## UI 상세 명세

### Box 상세페이지 — 편집 모드

**앱바**

- 좌측: "취소" TextButton (더보기 아이콘 숨김)
- 제목: "편집" 고정 텍스트
- 우측: "저장" TextButton (저장 중 비활성)

**코드 카드 그리드 (편집 모드)**

- `ReorderableWrap(maxMainAxisCount: 2)` — `reorderables` 패키지
  - landscape: `maxMainAxisCount: 4`
  - `spacing` / `runSpacing`: 12
  - `onReorder`: 로컬 리스트에서 `removeAt` + `insert` (레퍼런스 패턴 동일)
- 각 카드: `_ShakeWidget` 으로 래핑 (`ChordPositionCardWidget` 위에 오버레이)
  - 흔들림: `useAnimationController` + `AnimatedBuilder` + `Transform.rotate`
    - 각도: `(controller.value - 0.5) * pi / 90` (레퍼런스와 동일)
    - `controller.repeat(reverse: true)` / 종료 시 `stop` + `reset`
  - 좌상단 "−" 버튼: `CupertinoIcons.minus_circle_fill`, `Positioned(top: -18, left: -18)` (레퍼런스 패턴)
  - 탭 무시: `onTap: () {}`
- 롱프레스로 드래그 시작 (`ReorderableWrap` 기본 동작)

**상태 관리**

- 편집 상태는 `box_detail_screen.dart` 내 **로컬 `useState`** 로 관리
  - `isEditing = useState(false)`
  - `editingDetails = useState<List<BoxChordDetailModel>>([])`
- 편집 진입: `chordDetails`를 복사해 `editingDetails`에 할당 → `isEditing = true`
- 취소: `isEditing = false` (editingDetails 버림)
- 저장: `boxChordDao.saveEditChanges(...)` → 성공 시 `isEditing = false`
  (Stream이 자동으로 `chordDetails` 갱신)
- ViewModel (`boxDetailViewModelProvider`) 변경 없음

---

## sortOrder 컬럼 방식 검토

순서를 영속화하는 방법 비교:

| 방식                            | 설명                          | 단점                   |
| ------------------------------- | ----------------------------- | ---------------------- |
| **`sortOrder` integer 컬럼** ✅ | 전용 정수 컬럼으로 순서 저장  | 없음 (표준적)          |
| `savedAt` 조작                  | 순서 변경 시 savedAt을 덮어씀 | 실제 저장 시각 훼손    |
| Box 레코드에 JSON 저장          | Box 테이블에 순서 배열 저장   | 쿼리 복잡, 정규화 위반 |
| 별도 order 테이블               | 전용 테이블 분리              | 과도한 설계            |

→ **`sortOrder` integer 컬럼이 가장 적합.** clean하고 쿼리가 단순하며 표준적인 패턴.

---

## 관련 파일

**기존 파일 (수정)**

- `lib/shared/data/db/tables/box_chords_table.dart` — `sortOrder` 컬럼 추가
- `lib/shared/data/db/app_database.dart` — `schemaVersion` → `2` (마이그레이션 없음, 앱 재설치로 처리)
- `lib/shared/data/db/dao/box_chord_dao.dart` — `insertBoxChord` 시그니처 변경, `watchByBoxIdWithDetails` 정렬 변경, `saveEditChanges` 추가
- `lib/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart` — `insertBoxChord` 호출부 수정
- `lib/features/library/presentation/widgets/new_box_dialog.dart` — `insertBoxChord` 호출부 수정
- `lib/features/box/presentation/screens/box_detail_screen.dart` — 편집 모드 UI 전체 구현

**패키지 추가 (사전 승인 필요)**

- `reorderables` — `ReorderableWrap` (그리드 드래그 정렬, Meerkat 프로젝트 동일 패키지)

---

## Phase 구성 원칙

**각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.**

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지

---

## 작업 단계

---

### Phase 1: DB 레이어 — `sortOrder` 컬럼 추가

**목표:** `BoxChords` 테이블에 `sortOrder` 컬럼을 추가하고, 코드 저장 시 자동으로 순서를 배정한다.

> DB 마이그레이션 없음. 출시 전이므로 앱 삭제 후 재설치로 처리.

**작업 파일:**

- `lib/shared/data/db/tables/box_chords_table.dart` — 수정
  - `IntColumn get sortOrder => integer()();` 추가

- `lib/shared/data/db/app_database.dart` — 수정 없음
  - `schemaVersion` 변경 불필요 (개발 단계, 앱 삭제 후 재빌드로 대응)
  - `MigrationStrategy` 변경 불필요

- `lib/shared/data/db/dao/box_chord_dao.dart` — 수정
  - `insertBoxChord(BoxChordsCompanion)` → `insertBoxChord(int boxId, int chordPositionId)` 시그니처 변경
    - 내부: 트랜잭션 — 현재 boxId의 max `sortOrder` 조회 후 `max + 1` 로 insert
  - `watchByBoxIdWithDetails` orderBy: `boxChords.savedAt` → `boxChords.sortOrder` 오름차순
  - `saveEditChanges(int boxId, List<int> remainingChordPositionIds)` 추가
    - 트랜잭션:
      1. 제거된 BoxChord 삭제 (`chordPositionId NOT IN remainingChordPositionIds`)
      2. 남은 항목 `sortOrder` 일괄 업데이트 (0-based index 순서로)

- `lib/features/library/presentation/widgets/select_box_bottom_sheet_widget.dart` — 수정
  - `insertBoxChord(BoxChordsCompanion.insert(...))` → `insertBoxChord(box.id, chordPositionId)` 로 수정

- `lib/features/library/presentation/widgets/new_box_dialog.dart` — 수정
  - 동일하게 호출부 수정

- `build_runner` 재실행

**완료 조건:**

- [x] `BoxChords` 테이블에 `sortOrder` 컬럼 추가됨
- [x] `app_database.dart` 변경 없음 (`schemaVersion` 그대로 1 유지)
- [x] 코드 저장 시 `sortOrder` 자동 배정 (max+1)
- [x] `watchByBoxIdWithDetails` 정렬 기준이 `sortOrder` 오름차순으로 변경됨
- [x] `saveEditChanges` 메서드 추가됨
- [x] `insertBoxChord` 호출부 2곳 수정됨
- [x] `build_runner` 재실행 완료
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: BoxChords sortOrder 컬럼 추가 (#20)`

---

### Phase 2: 편집 모드 UI

> **시작 전:** `reorderables` 패키지 추가 사용자 승인 후 진행 → `pubspec.yaml`에 추가

**목표:** 롱프레스로 편집 모드에 진입하고, 드래그로 순서 변경·"−" 버튼으로 삭제·저장/취소 플로우를 완성한다.

**구현 방식:** Meerkat 프로젝트 `service_widgets.dart`의 `ReorderableWrap` + `_ShakeWidget` 패턴을 그대로 적용.

**작업 파일:**

- `lib/features/box/presentation/screens/box_detail_screen.dart` — 수정
  - 로컬 상태 추가
    ```dart
    final isEditing = useState(false);
    final editingDetails = useState<List<BoxChordDetailModel>>([]);
    final isSaving = useState(false);
    ```
  - 롱프레스 핸들러: `editingDetails.value = List.from(chordDetails)` → `isEditing.value = true`
  - **일반 모드** 앱바: 기존 더보기 메뉴
  - **편집 모드** 앱바
    - title: "편집"
    - leading: "취소" TextButton → `isEditing.value = false`
    - actions: "저장" TextButton → `saveEditChanges` 호출 → 성공 시 `isEditing.value = false`, 실패 시 CToast
  - **일반 모드** 그리드: 기존 `SliverGrid` + `ChordPositionCardWidget` (롱프레스 감지 추가)
  - **편집 모드** 그리드: `ReorderableWrap` + `_ShakeWidget` 으로 교체
    ```dart
    ReorderableWrap(
      spacing: 12,
      runSpacing: 12,
      maxMainAxisCount: isLandscape ? 4 : 2,
      onReorder: (oldIndex, newIndex) {
        final list = List<BoxChordDetailModel>.from(editingDetails.value);
        final item = list.removeAt(oldIndex);
        list.insert(newIndex, item);
        editingDetails.value = list;
      },
      children: editingDetails.value.map((detail) =>
        _ShakeWidget(
          key: ValueKey(detail.position.id),
          isShaking: isEditing.value,
          onDelete: () {
            editingDetails.value = editingDetails.value
                .where((d) => d.position.id != detail.position.id)
                .toList();
          },
          child: ChordPositionCardWidget(
            chord: detail.chord,
            position: detail.position,
            onTap: () {},
          ),
        ),
      ).toList(),
    )
    ```
  - `_ShakeWidget` private 클래스 (파일 하단)
    - `useAnimationController(duration: 400ms)` + `AnimatedBuilder` + `Transform.rotate`
    - 각도: `(controller.value - 0.5) * pi / 90`
    - `isShaking` 변경 시 `useEffect` → `repeat(reverse: true)` / `stop` + `reset`
    - 좌상단 `CupertinoIcons.minus_circle_fill` 버튼 (`Positioned(top: -18, left: -18)`)

**완료 조건:**

- [x] 카드 롱프레스 시 편집 모드 전환됨
- [x] 앱바가 "편집" / 취소 / 저장 버튼으로 전환됨
- [x] 카드 흔들림 애니메이션 적용됨
- [x] "−" 버튼 탭 시 해당 카드가 목록에서 제거됨 (로컬 반영)
- [x] 카드 드래그로 순서 변경 가능
- [x] "저장" 탭 시 변경사항이 DB에 반영되고 일반 모드로 복귀됨
- [x] "취소" 탭 시 변경사항 없이 일반 모드로 복귀됨
- [x] `flutter analyze` 오류 없음

**커밋 메시지 제안:** `feat: Box 상세페이지 편집 모드 UI 구현 (#20)`

---

## 주의사항

- **앱 재설치 필수**: `sortOrder` 컬럼이 추가되므로 테스트 전 앱 삭제 후 재빌드
- **`reorderables` 패키지**: Phase 2 시작 전 사용자 승인 후 `pubspec.yaml`에 추가
- **저장 전 원본 불변**: `editingDetails`는 항상 `chordDetails`의 복사본(`List.from`). 저장 전까지 ViewModel·Stream 데이터에 영향 없음
- **편집 모드 중 Stream 갱신**: `isEditing = true` 동안 Stream이 갱신되어 `chordDetails`가 바뀌어도 `editingDetails`는 영향 받지 않음 (로컬 상태이므로)
- **`saveEditChanges` remainingIds 순서**: `editingDetails.value`의 현재 순서대로 `position.id` 리스트를 전달 → DAO 내부에서 0-based index로 sortOrder 재배정
- **`insertBoxChord` 호출부**: `select_box_bottom_sheet_widget.dart`, `new_box_dialog.dart` 두 곳 모두 Phase 1에서 수정 필수

---

## 작업 시작 전 체크리스트

- [x] `docs/architecture/` 문서 숙지 완료
- [x] `BoxChords` 테이블 및 현재 `insertBoxChord` 호출부 2곳 파악 완료
- [x] Meerkat `service_widgets.dart`의 `_ShakeWidget` 구현 숙지 완료
- [x] `reorderables` 패키지 추가 사용자 승인 완료
