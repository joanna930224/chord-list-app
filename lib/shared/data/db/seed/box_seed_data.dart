import 'package:chord_list_app/shared/data/db/app_database.dart';
import 'package:chord_list_app/shared/data/db/dao/box_dao.dart';
import 'package:chord_list_app/shared/utils/logger.dart';
import 'package:drift/drift.dart';

/// 개발자 전용 샘플 Box 데이터 삽입
///
/// 실행 방법:
///   flutter run --dart-define=SEED_BOXES=true
///
/// - kDebugMode가 아닌 경우 절대 실행되지 않음
/// - 이미 데이터가 있으면 중복 삽입하지 않음
Future<void> insertBoxSeedData(AppDatabase db) async {
  final existing = await db.boxDao.watchAll(BoxSortType.createdAtDesc).first;
  if (existing.isNotEmpty) {
    logger.d('⏭️ [BoxSeed] 이미 Box 데이터가 존재하여 건너뜀 (${existing.length}개)');
    return;
  }

  logger.d('🗂️ [BoxSeed] 샘플 Box 데이터 삽입 시작');

  final boxes = [
    ChordBoxesCompanion.insert(
      title: '핑거스타일 연습곡',
      description: const Value('핑거스타일로 연주하는 곡들 모음'),
      createdAt: DateTime(2026, 1, 10),
    ),
    ChordBoxesCompanion.insert(
      title: '초보자 코드 모음',
      description: const Value('처음 배울 때 익혀야 할 기본 코드'),
      createdAt: DateTime(2026, 2, 5),
    ),
    ChordBoxesCompanion.insert(
      title: '즐겨찾는 코드',
      description: const Value(null),
      createdAt: DateTime(2026, 3, 20),
    ),
    ChordBoxesCompanion.insert(
      title: '팝 발라드 모음',
      description: const Value('감성적인 팝 발라드 곡 코드'),
      createdAt: DateTime(2026, 3, 25),
    ),
    ChordBoxesCompanion.insert(
      title: '재즈 코드 연습',
      description: const Value('재즈 특유의 텐션 코드 모음'),
      createdAt: DateTime(2026, 4, 1),
    ),
    ChordBoxesCompanion.insert(
      title: '카포 1번 곡들',
      description: const Value('카포 1번 사용하는 곡 모음'),
      createdAt: DateTime(2026, 4, 3),
    ),
    ChordBoxesCompanion.insert(
      title: '스트로크 패턴 연습',
      description: const Value(null),
      createdAt: DateTime(2026, 4, 5),
    ),
    ChordBoxesCompanion.insert(
      title: '버스킹 셋리스트',
      description: const Value('야외 버스킹용 곡 모음'),
      createdAt: DateTime(2026, 4, 6),
    ),
    ChordBoxesCompanion.insert(
      title: '친구 추천 곡',
      description: const Value('친구들이 배워보라고 추천한 곡들'),
      createdAt: DateTime(2026, 4, 7),
    ),
    ChordBoxesCompanion.insert(
      title: '블루스 코드',
      description: const Value('12마디 블루스 진행 연습'),
      createdAt: DateTime(2026, 4, 8),
    ),
    ChordBoxesCompanion.insert(
      title: '카포 2번 곡들',
      description: const Value('카포 2번 사용하는 곡 모음'),
      createdAt: DateTime(2026, 4, 9),
    ),
    ChordBoxesCompanion.insert(
      title: '클래식 기타 소품',
      description: const Value(null),
      createdAt: DateTime(2026, 4, 10),
    ),
    ChordBoxesCompanion.insert(
      title: '록 리프 모음',
      description: const Value('기억해두고 싶은 록 리프들'),
      createdAt: DateTime(2026, 4, 11),
    ),
    ChordBoxesCompanion.insert(
      title: 'OST 모음',
      description: const Value('드라마·영화 OST 기타 편곡'),
      createdAt: DateTime(2026, 4, 12),
    ),
    ChordBoxesCompanion.insert(
      title: '연습 중인 곡',
      description: const Value('현재 연습 중인 곡들'),
      createdAt: DateTime(2026, 4, 13),
    ),
  ];

  for (final companion in boxes) {
    await db.boxDao.insertBox(companion);
  }

  logger.d('✅ [BoxSeed] 샘플 Box ${boxes.length}개 삽입 완료 (15개)');
}
