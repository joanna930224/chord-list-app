import 'package:chord_list_app/shared/data/db/seed/box_seed_data.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:chord_list_app/shared/providers/database_provider.dart';
import 'package:chord_list_app/shared/utils/logger.dart';
import 'package:flutter/foundation.dart';

const _seedBoxes = bool.fromEnvironment('SEED_BOXES');

Future<ProviderContainer> initialization() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  logger.d('🎸 ChordBox initialized');

  // DB 연결 및 최초 실행 시 seed 데이터 삽입
  // - AppDatabase.onCreate는 DB 파일이 없을 때만 실행 (앱 최초 설치 시 1회)
  // - 이후 실행에서는 DB 파일이 존재하므로 onCreate 미실행, seed 중복 없음
  final db = container.read(appDatabaseProvider);
  await db.chordDao.findAll();

  // 개발자 전용 샘플 Box 삽입
  // 실행: flutter run --dart-define=SEED_BOXES=true
  if (kDebugMode && _seedBoxes) {
    await insertBoxSeedData(db);
  }

  return container;
}
