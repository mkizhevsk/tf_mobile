import 'dart:async';

class StreamManager {
  static final StreamManager _instance = StreamManager._internal();
  factory StreamManager() => _instance;
  StreamManager._internal();

  // cardId
  final StreamController<int> _cardIdController =
      StreamController<int>.broadcast();

  Stream<int> get cardIdStream => _cardIdController.stream;
  Sink<int> get cardIdSink => _cardIdController.sink;
}
