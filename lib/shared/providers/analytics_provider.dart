import 'package:chord_list_app/shared/exports.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final analyticsProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(FirebaseAnalytics.instance);
});

class AnalyticsService {
  const AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
