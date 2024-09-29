import 'dart:math';

import '../other/cells.dart';
import 'io/ansii-codes.dart';
import 'io/color-string.dart';
import 'io/console.dart';
import 'io/input.dart';
import 'uitls/color.dart';
import 'uitls/cube/cube.dart';
import 'uitls/cube/side.dart';
import 'generators/cube-diamond-square/cube-ds.dart';
import 'uitls/intersect.dart';
import 'uitls/lerp.dart';
import 'uitls/vector.dart';

renderCube(
  String Function(CubeSide, int, int) getString,
  int size, {
  int x = 0,
  int y = 0,
  int h = 40,
  int w = 40,
  num dist = 7,
  num r = 1,
  num xAng = 0,
  num yAng = 0,
  num zAng = 0,
  num tet = pi / 8,
}) {
  var a0 = Vector(r, 0, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var b0 = Vector(0, -r, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var c0 = Vector(-r, 0, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var d0 = Vector(0, r, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var e0 = Vector(0, 0, r).rotX(xAng).rotY(yAng).rotZ(zAng);
  var f0 = Vector(0, 0, -r).rotX(xAng).rotY(yAng).rotZ(zAng);
  var str = StringBuffer();

  var tetV = tet * h / w;

  for (int i = y; i < h + y; i++) {
    str.write(ANSICodes.CURMOVE(i, x));
    for (int j = x; j < w + x; j++) {
      var angj = lerp(j, x, w + x, tet, -tet);
      var angi = lerp(i, y, h + y, tetV, -tetV);
      var v0 = Vector(dist, 0, 0);
      var vd = Vector(-1, tan(angj), tan(angi)).norm;

      var cstr = ANSICodes.RGBB(0, 0, 0) + '  ';
      var res = intersectCube(size, a0, b0, c0, d0, e0, f0, v0, vd);
      if (res != null) {
        var (side, i, j) = res;
        cstr = getString(side, i, j);
      }
      str.write(cstr);
    }
  }
  return str.toString() + ANSICodes.RESETALL;
}

renderSphere(
  String Function(CubeSide, int, int) getString,
  int size, {
  int x = 0,
  int y = 0,
  int h = 40,
  int w = 40,
  num dist = 7,
  num r = 1,
  num xAng = 0,
  num yAng = 0,
  num zAng = 0,
  num tet = pi / 8,
}) {
  var a0 = Vector(r, 0, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var b0 = Vector(0, -r, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var c0 = Vector(-r, 0, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var d0 = Vector(0, r, 0).rotX(xAng).rotY(yAng).rotZ(zAng);
  var e0 = Vector(0, 0, r).rotX(xAng).rotY(yAng).rotZ(zAng);
  var f0 = Vector(0, 0, -r).rotX(xAng).rotY(yAng).rotZ(zAng);
  var str = StringBuffer();
  var tetV = tet * h / w;

  for (int i = y; i < h + y; i++) {
    str.write(ANSICodes.CURMOVE(i, x));
    for (int j = x; j < w + x; j++) {
      var angj = lerp(j, x, w + x, tet, -tet);
      var angi = lerp(i, y, h + y, tetV, -tetV);
      var v0 = Vector(dist, 0, 0);
      var vd = Vector(-1, tan(angj), tan(angi)).norm;
      var cstr = ANSICodes.RGBB(0, 0, 0) + '  ';

      var det = r * r + pow(v0.dot(vd), 2) - pow(v0.magn, 2);

      if (det >= 0) {
        var d = -v0.dot(vd) - sqrt(det);
        var n = (v0 + vd * d).norm;
        var r = 200;
        var g = 200;
        var b = 200;
        var res =
            intersectCube(size, a0, b0, c0, d0, e0, f0, Vector(0, 0, 0), n);

        if (res != null) {
          var (side, i, j) = res;
          cstr = getString(side, i, j);
        } else {
          cstr = ANSICodes.RGBB(r, g, b) + '  ';
        }
      }

      str.write(cstr + ANSICodes.RESETALL);
    }
  }
  return str.toString() + ANSICodes.RESETALL;
}

class RenderConfig {
  num angFov = pi / 8;
  Vector cameraPosition;
  Vector angles;
  String Function(CubeSide, int, int)? getPositionString;

  RenderConfig()
      : cameraPosition = Vector(7, 0, 0),
        angles = Vector(0, 0, 0);
}

(Cube<num>, Cube<num>) getMaps(int steps) {
  var cube = diamondSquareCube(
    centers: {CubeSideLabel.E: -1, CubeSideLabel.F: -1},
    steps,
    R: 0.75,
  );

  var tempCube = diamondSquareCube(
    steps,
    R: 0.4,
    centers: {
      CubeSideLabel.A: 0.9,
      CubeSideLabel.B: 0.75,
      CubeSideLabel.D: 0.9,
      CubeSideLabel.C: 0.75,
      CubeSideLabel.E: -1,
      CubeSideLabel.F: -1,
    },
    corners: List.filled(8, -0.75),
  );

  for (var side in CubeSide.zeroSides) {
    for (int i = 0; i < tempCube.size; i++) {
      for (int j = 0; j < tempCube.size; j++) {
        var h = cube.get(side, i, j);
        num v = tempCube.get(side, i, j);
        switch (heightType(((h + 1) * 8).toInt())) {
          case HeightType.DEEP_SEA:
            v += -0.1;
            break;
          case HeightType.SEA:
            break;
          case HeightType.LAND:
            v += 0.2;
            break;
          case HeightType.HIGH_LAND:
            v += 0.1;
            break;
          case HeightType.MOUNTAIN:
            v += -0.1;
            break;
          case HeightType.HIGH_MOUNTAIN:
            v -= -0.2;
            break;
        }
        v = min(1, max(-1, v));
        tempCube.set(side, i, j, v);
      }
    }
  }
  return (cube, tempCube);
}

cube3D() async {
  var steps = 8;
  var (hm, tm) = getMaps(steps);
  var config = RenderConfig();

  heightString(CubeSide side, int i, int j) {
    var v = hm.get(side, i, j);
    var c = heighColor(((v + 1) * 8).toInt());
    return ANSICodes.RGBB(c.r, c.g, c.b) + '  ';
  }

  tempString(CubeSide side, int i, int j) {
    var isSea = hm.get(side, i, j) + 1 < 6 / 8;
    var v = tm.get(side, i, j);
    var m = isSea ? 0.7 : 1;
    var c = tempColor(((v + 1) * 8).toInt());
    return ANSICodes.RGBB(
            (c.r * m).toInt(), (c.g * m).toInt(), (c.b * m).toInt()) +
        '  ';
  }

  String cubeRender(RenderConfig conf) {
    return renderCube(
      conf.getPositionString ?? heightString,
      hm.size,
      dist: conf.cameraPosition.x,
      h: Console().height - 2,
      w: Console().width ~/ 2 - 2,
      x: 1,
      y: 1,
      xAng: conf.angles.x,
      yAng: conf.angles.y,
      zAng: conf.angles.z,
    );
  }

  String sphereRender(RenderConfig conf) {
    return renderSphere(
      conf.getPositionString ?? heightString,
      tm.size,
      dist: conf.cameraPosition.x,
      h: Console().height - 2,
      w: Console().width ~/ 2 - 2,
      x: 1,
      y: 1,
      xAng: conf.angles.x,
      yAng: conf.angles.y,
      zAng: conf.angles.z,
    );
  }

  bool loop = true;

  Console().start();
  Console().clear();

  String Function(RenderConfig) render = cubeRender;

  var colorMode = 'height';
  var shapeMode = 'cube';

  renderUI() {
    var str = StringBuffer();
    for (int i = 0; i < 27; i++) {
      for (int j = 0; j < 91; j++) {
        str.write(ANSICodes.CURMOVE(i, j) + ANSICodes.RGBB(0, 0, 0) + ' ');
      }
    }
    print(str.toString());
    printStr(
        1, 2, 'temp (t)', colorMode == 'temp' ? Color.yellow : Color.white);
    printStr(
        7, 2, 'height (h)', colorMode == 'height' ? Color.yellow : Color.white);

    printStr(1, 47, 'cube (c)', shapeMode == 'cube' ? Color.red : Color.white);
    printStr(
        7, 47, 'sphere (s)', shapeMode == 'sphere' ? Color.red : Color.white);
    printStr(13, 2, 'zoom (+/-)', Color.white);
    printStr(20, 2, 'rotate (←→↑↓)', Color.white);
  }

  InputStream().subscride((InputEvent ie) {
    if (ie is InputKeyEvent) {
      if (ie.key == '+') {
        config.cameraPosition.x /= 1.2;
      }
      if (ie.key == '-') {
        config.cameraPosition.x *= 1.2;
      }
      if (ie.key == 's') {
        shapeMode = 'sphere';
        render = sphereRender;
      }
      if (ie.key == 'c') {
        shapeMode = 'cube';
        render = cubeRender;
      }
      if (ie.key == 'h') {
        colorMode = 'height';
        config.getPositionString = heightString;
      }
      if (ie.key == 't') {
        colorMode = 'temp';
        config.getPositionString = tempString;
      }
    }
    if (ie.type == InputEventType.ARROW_UP) {
      config.angles.y += pi / 32;
    }
    if (ie.type == InputEventType.ARROW_LEFT) {
      config.angles.z += pi / 32;
    }
    if (ie.type == InputEventType.ARROW_RIGHT) {
      config.angles.z -= pi / 32;
    }
    if (ie.type == InputEventType.ARROW_DOWN) {
      config.angles.y -= pi / 32;
    }
    if (ie.type == InputEventType.ESC) {
      loop = false;
    }
    if (loop) {
      print(render(config));
      renderUI();
    }
  });
  print(render(config));
  renderUI();

  while (loop) {
    await Future(() => {});
  }
  Console().clear();
  Console().end();
}

printBits(int i, int j, List<List<int>> bits, [Color c = Color.white]) {
  for (int bi = 0; bi < bits.length; bi++) {
    for (int bj = 0; bj < bits[bi].length; bj++) {
      if (bits[bi][bj] == 1) {
        Console().write(
          i + bi,
          j + bj,
          ColorString()..add(' ', background: c),
        );
      } else {
        Console().write(
          i + bi,
          j + bj,
          ColorString()..add('  '),
        );
      }
    }
  }
}

const Map<String, List<List<int>>> charBits = {
  ' ': [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ],
  'f': [
    [1, 1, 1, 1],
    [1, 0, 0, 0],
    [1, 1, 1, 1],
    [1, 0, 0, 0],
    [1, 0, 0, 0],
  ],
  'n': [
    [1, 0, 0, 0, 1],
    [1, 1, 0, 0, 1],
    [1, 0, 1, 0, 1],
    [1, 0, 0, 1, 1],
    [1, 0, 0, 0, 1],
  ],
  'o': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
  ],
  'l': [
    [1, 0, 0],
    [1, 0, 0],
    [1, 0, 0],
    [1, 0, 0],
    [1, 1, 1],
  ],
  'd': [
    [1, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 1, 1, 0],
  ],
  'a': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 1, 1, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1]
  ],
  't': [
    [1, 1, 1],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
  ],
  'e': [
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
  ],
  'm': [
    [1, 0, 0, 0, 1],
    [1, 1, 0, 1, 1],
    [1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
  ],
  'k': [
    [1, 0, 0, 1],
    [1, 0, 1, 0],
    [1, 1, 0, 0],
    [1, 0, 1, 0],
    [1, 0, 0, 1],
  ],
  'p': [
    [1, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 1, 1, 0],
    [1, 0, 0, 0],
    [1, 0, 0, 0]
  ],
  'h': [
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 1, 1, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
  ],
  'q': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
    [0, 0, 0, 1],
  ],
  'i': [
    [1, 1, 1],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [1, 1, 1],
  ],
  'g': [
    [0, 1, 1, 1],
    [1, 0, 0, 0],
    [1, 0, 1, 1],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
  ],
  'c': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 0, 0, 0],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
  ],
  'u': [
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
  ],
  'b': [
    [1, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 1, 1, 1],
    [1, 0, 0, 1],
    [1, 1, 1, 0],
  ],
  's': [
    [0, 1, 1, 1],
    [1, 0, 0, 0],
    [0, 1, 1, 0],
    [0, 0, 0, 1],
    [1, 1, 1, 0],
  ],
  'r': [
    [1, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 1, 1, 0],
    [1, 0, 1, 0],
    [1, 0, 0, 1],
  ],
  'w': [
    [1, 0, 0, 0, 1],
    [1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1],
    [0, 1, 0, 1, 0],
  ],
  'v': [
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [0, 1, 0, 1, 0],
    [0, 1, 0, 1, 0],
    [0, 0, 1, 0, 0],
  ],
  'x': [
    [1, 0, 0, 0, 1],
    [0, 1, 0, 1, 0],
    [0, 0, 1, 0, 0],
    [0, 1, 0, 1, 0],
    [1, 0, 0, 0, 1],
  ],
  'y': [
    [1, 0, 0, 0, 1],
    [0, 1, 0, 1, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0],
  ],
  'z': [
    [1, 1, 1, 1],
    [0, 0, 0, 1],
    [0, 1, 1, 0],
    [1, 0, 0, 0],
    [1, 1, 1, 1],
  ],
  '0': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [1, 0, 1, 1],
    [1, 1, 0, 1],
    [0, 1, 1, 0],
  ],
  '1': [
    [1, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [1, 1, 1],
  ],
  '2': [
    [1, 1, 1, 0],
    [0, 0, 0, 1],
    [0, 1, 1, 0],
    [1, 0, 0, 0],
    [1, 1, 1, 1],
  ],
  '3': [
    [1, 1, 1, 0],
    [0, 0, 0, 1],
    [0, 1, 1, 0],
    [0, 0, 0, 1],
    [1, 1, 1, 0],
  ],
  '4': [
    [1, 0, 1],
    [1, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
  '5': [
    [1, 1, 1, 1],
    [1, 0, 0, 0],
    [1, 1, 1, 0],
    [0, 0, 0, 1],
    [1, 1, 1, 0],
  ],
  '6': [
    [0, 1, 1, 0],
    [1, 0, 0, 0],
    [1, 1, 1, 0],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
  ],
  '7': [
    [1, 1, 1, 1],
    [0, 0, 0, 1],
    [0, 0, 1, 0],
    [0, 1, 0, 0],
    [0, 1, 0, 0],
  ],
  '8': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [0, 1, 1, 0],
  ],
  '9': [
    [0, 1, 1, 0],
    [1, 0, 0, 1],
    [0, 1, 1, 1],
    [0, 0, 0, 1],
    [0, 1, 1, 0]
  ],
  '←': [
    [0, 0, 1, 0, 0],
    [0, 1, 0, 0, 0],
    [1, 1, 1, 1, 1],
    [0, 1, 0, 0, 0],
    [0, 0, 1, 0, 0]
  ],
  '→': [
    [0, 0, 1, 0, 0],
    [0, 0, 0, 1, 0],
    [1, 1, 1, 1, 1],
    [0, 0, 0, 1, 0],
    [0, 0, 1, 0, 0]
  ],
  '↑': [
    [0, 0, 1, 0, 0],
    [0, 1, 1, 1, 0],
    [1, 0, 1, 0, 1],
    [0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0],
  ],
  '↓': [
    [0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0],
    [1, 0, 1, 0, 1],
    [0, 1, 1, 1, 0],
    [0, 0, 1, 0, 0],
  ],
  '(': [
    [0, 1],
    [1, 0],
    [1, 0],
    [1, 0],
    [0, 1]
  ],
  ')': [
    [1, 0],
    [0, 1],
    [0, 1],
    [0, 1],
    [1, 0]
  ],
  '/': [
    [0, 0, 1],
    [0, 0, 1],
    [0, 1, 0],
    [1, 0, 0],
    [1, 0, 0],
  ],
  '+': [
    [0, 0, 0],
    [0, 1, 0],
    [1, 1, 1],
    [0, 1, 0],
    [0, 0, 0],
  ],
  '-': [
    [0, 0, 0],
    [0, 0, 0],
    [1, 1, 1],
    [0, 0, 0],
    [0, 0, 0]
  ]
};

printStr(int i, int j, String str, [Color c = Color.white]) {
  const fillBlock = [
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1]
  ];
  for (int si = 0; si < str.length; si++) {
    var bits = charBits[str[si]];
    if (bits != null) {
      printBits(i, j, bits, c);
      j += bits[0].length + 1;
    } else {
      printBits(i, j, fillBlock, Color.red);
      j += fillBlock[0].length + 1;
    }
  }
}

main() async {
  cube3D();
}
