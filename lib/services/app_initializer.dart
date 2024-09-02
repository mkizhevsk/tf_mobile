import 'package:tf_mobile/services/card_sync_service.dart';
import 'dart:async';
import 'package:logging/logging.dart';

class AppInitializer {
  static final Logger _logger = Logger('AppInitializer');
  static final Completer<void> _initializerCompleter = Completer<void>();
  static final CardSyncService _cardSyncService = CardSyncService();

  static Future<void> runAfterStart() async {
    if (!_initializerCompleter.isCompleted) {
      _logger.info('This runs after the app has started.');
      await _cardSyncService.fetchAndSyncCards();
      _initializerCompleter.complete();
    }
    await _initializerCompleter.future;
  }
}
