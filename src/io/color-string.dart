import '../uitls/color.dart';
import 'ansii-codes.dart';

class _ColorStringSegment {
  final String str;
  final Color foreground;
  final Color background;
  final bool bold;

  _ColorStringSegment(this.str,
      {this.foreground = Color.white,
      this.background = Color.black,
      this.bold = false});

  int get length {
    return str.length;
  }

  @override
  String toString() {
    return ANSICodes.RGBB(background.r, background.g, background.b) +
        ANSICodes.RGBF(foreground.r, foreground.g, foreground.b) +
        (bold ? ANSICodes.BOLD : '') +
        str +
        (bold ? ANSICodes.BOLD_RESET : '');
  }

  ColorString get string {
    return ColorString().._addSegment(this);
  }
}

class ColorString {
  final List<_ColorStringSegment> segments;
  int length = 0;
  ColorString() : segments = [];

  add(
    String str, {
    Color foreground = Color.white,
    Color background = Color.black,
    bool bold = false,
  }) {
    _addSegment(_ColorStringSegment(
      str,
      foreground: foreground,
      background: background,
      bold: bold,
    ));
  }

  _addSegment(_ColorStringSegment seg) {
    segments.add(seg);
    length += seg.length;
  }

  ColorString operator <<(ColorString str) {
    for (var seg in str.segments) {
      _addSegment(seg);
    }
    return this;
  }

  ColorString shrink(int len) {
    var shrinked = ColorString();

    for (var seg in segments) {
      if (shrinked.length + seg.length < len) {
        shrinked.add(
          seg.str,
          foreground: seg.foreground,
          background: seg.background,
        );
      } else {
        shrinked.add(
          seg.str.substring(0, len - shrinked.length),
          foreground: seg.foreground,
          background: seg.background,
        );
      }
    }

    return shrinked;
  }

  @override
  String toString() {
    return segments.join('') + ANSICodes.RESETALL;
  }
}
