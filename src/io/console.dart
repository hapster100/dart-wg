import 'dart:io' as io;

import '../uitls/color.dart';
import '../uitls/matrix.dart';
import 'ansii-codes.dart';
import 'color-string.dart';
import 'input.dart';

class _RenderChar {
  final Color fgColor;
  final Color bgColor;
  final String char;
  _RenderChar(this.char, this.bgColor, this.fgColor);
  bool operator ==(Object other) {
    if (other is _RenderChar) {
      return other.char == char &&
          other.bgColor == bgColor &&
          other.fgColor == fgColor;
    }
    return false;
  }
}

class RenderBuffer {
  Matrix<_RenderChar> _current;
  StringBuffer buff = StringBuffer('');
  int step = 0;
  RenderBuffer(int height, int width)
      : _current = Matrix.filled(
            height, width, _RenderChar(' ', Color.black, Color.white));

  put(i, j, char, {Color fg = Color.white, Color bg = Color.black}) {
    var ch = _RenderChar(char, bg, fg);
    if (ch != _current.saveGet(i, j)) {
      _current[i][j] = ch;
      buff.write(
        ANSICodes.CURMOVE(i, j) +
            ANSICodes.RGBB(bg.r, bg.g, bg.b) +
            ANSICodes.RGBF(fg.r, fg.g, fg.b) +
            char,
      );
    }
  }

  render() {
    io.stdout.write(buff.toString());
    buff = StringBuffer();
    step++;
  }
}

class Console {
  static final _console = Console._init();
  Console._init();
  factory Console() {
    return _console;
  }

  InputStream input = InputStream();

  int get height {
    return io.stdout.terminalLines;
  }

  int get width {
    return io.stdout.terminalColumns;
  }

  void write(int i, int j, ColorString str) {
    if (i >= height || i < 0) return;
    var pos = ANSICodes.CURMOVE(i, j);
    if (j + str.length >= width) {
      str = str.shrink(width - j);
    }
    io.stdout.write('$pos$str');
  }

  void start() {
    io.stdout.writeAll([
      ANSICodes.HOME,
      ANSICodes.CURHIDE,
    ]);
    io.stdin.lineMode = false;
    io.stdin.echoMode = false;
  }

  void end() {
    io.stdout.writeAll([
      ANSICodes.RESETALL,
      ANSICodes.CURSHOW,
    ]);
    try {
      io.stdin.echoMode = true;
      io.stdin.lineMode = true;
    } catch (err) {
      print(err);
    }
    input.end();
  }

  void clear() =>
      io.stdout.write(ANSICodes.RESETALL + ANSICodes.CLEAR + ANSICodes.HOME);
}
