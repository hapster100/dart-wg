import 'dart:async';
import 'dart:io' as io;

enum InputEventType {
  ARROW_UP,
  ARROW_DOWN,
  ARROW_LEFT,
  ARROW_RIGHT,
  ESC,
  KEY,
  DONE,
}

class InputEvent {
  final InputEventType type;
  final dynamic _data;
  InputEvent(this.type, [this._data = null]);
}

class InputKeyEvent extends InputEvent {
  InputKeyEvent(String key) : super(InputEventType.KEY, key);
  String get key {
    return _data as String;
  }
}

class InputStream {
  static final InputStream _input = InputStream._init();

  Map<int, void Function(InputEvent)> subs = Map();
  StreamSubscription<List<int>>? sub;

  InputStream._init() {
    start();
  }

  factory InputStream() {
    return _input;
  }

  void _notify(InputEvent event) {
    subs.values.forEach((fn) => fn(event));
  }

  void Function() subscride(fn) {
    subs[fn.hashCode] = fn;
    return () {
      subs.remove(fn.hashCode);
    };
  }

  _key(int v) => _notify(InputKeyEvent(String.fromCharCode(v)));
  _typed(InputEventType t) => _notify(InputEvent(t));

  _event1(List<int> data) {
    switch (data[0]) {
      case 27:
        return _typed(InputEventType.ESC);
      default:
        return _key(data[0]);
    }
  }

  _event3(List<int> data) {
    switch (data[0]) {
      case 27:
        switch (data[1]) {
          case 91:
            switch (data[2]) {
              case 65:
                return _typed(InputEventType.ARROW_UP);
              case 66:
                return _typed(InputEventType.ARROW_DOWN);
              case 67:
                return _typed(InputEventType.ARROW_RIGHT);
              case 68:
                return _typed(InputEventType.ARROW_LEFT);
            }
        }
    }
  }

  void start() {
    sub = io.stdin.listen((data) {
      switch (data.length) {
        case 1:
          _event1(data);
          break;
        case 3:
          _event3(data);
          break;
      }
    });
  }

  void end() {
    _typed(InputEventType.DONE);
    sub?.cancel();
    sub = null;
  }
}
