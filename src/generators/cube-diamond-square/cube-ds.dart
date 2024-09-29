import 'dart:math';
import '../../uitls/cube/cube.dart';
import '../../uitls/cube/side.dart';

Cube<num> diamondSquareCube(
  int steps, {
  Function(num)? progress,
  Random? rand,
  List<num>? corners,
  Map<CubeSideLabel, num>? centers,
  num R = 0.5,
}) {
  rand ??= Random();
  corners ??= List.generate(8, (i) => rand!.nextDouble() * 2 - 1);

  int size = (1 << steps) + 1;
  Cube<num> ss = Cube(size, 0);
  num I = 0;

  int done = 0;
  int total = 6 * size - 12 * size + 8;

  setVal(CubeSide side, int i, int j, num val) {
    val += (rand!.nextDouble() - 0.5) * pow(R, I);
    val = max(-1, min(1, val));
    ss.set(side, i, j, val);
    progress?.call(++done / total);
  }

  setVal(CubeSide.A0, 0, 0, corners[0]);
  setVal(CubeSide.A0, 0, size - 1, corners[1]);
  setVal(CubeSide.A0, size - 1, 0, corners[2]);
  setVal(CubeSide.A0, size - 1, size - 1, corners[3]);
  setVal(CubeSide.C0, 0, 0, corners[4]);
  setVal(CubeSide.C0, 0, size - 1, corners[5]);
  setVal(CubeSide.C0, size - 1, 0, corners[6]);
  setVal(CubeSide.C0, size - 1, size - 1, corners[7]);

  diamondPosition(int i, int j, int d) {
    for (var label in CubeSideLabel.values) {
      if (d == ss.size ~/ 2 && centers != null && centers.containsKey(label)) {
        setVal(CubeSide(label, 0), i, j, centers[label] ?? 0);
      } else {
        var side = CubeSide(label, 0);
        num sum = 0;
        sum += ss.get(side, i - d, j - d);
        sum += ss.get(side, i - d, j + d);
        sum += ss.get(side, i + d, j - d);
        sum += ss.get(side, i + d, j + d);
        setVal(side, i, j, sum / 4);
      }
    }
  }

  squarePositionEdge(int i, int j, int d) {
    for (var label in [
      CubeSideLabel.A,
      CubeSideLabel.B,
      CubeSideLabel.C,
      CubeSideLabel.D
    ]) {
      var side = CubeSide(label, 0);
      num sum = 0;
      sum += ss.get(side, i + d, j);
      sum += ss.get(side, i - d, j);
      sum += ss.get(side, i, j - d);
      sum += ss.get(side, i, j + d);
      setVal(side, i, j, sum / 4);
    }
  }

  squarePosition(i, j, d) {
    if (i == 0 || j == 0 || i == size - 1 || j == size - 1) {
      squarePositionEdge(i, j, d);
    } else {
      for (var label in CubeSideLabel.values) {
        var side = CubeSide(label, 0);
        num sum = 0;
        sum += ss.get(side, i - d, j);
        sum += ss.get(side, i + d, j);
        sum += ss.get(side, i, j - d);
        sum += ss.get(side, i, j + d);
        setVal(side, i, j, sum / 4);
      }
    }
  }

  diamondStep(int d) {
    for (int di = d; di < size; di += d * 2) {
      for (int dj = d; dj < size; dj += d * 2) {
        diamondPosition(di, dj, d);
      }
    }
  }

  squareStep(int d) {
    for (int di = d; di < size; di += d * 2) {
      for (int dj = 0; dj < size; dj += d * 2) {
        squarePosition(di, dj, d);
        squarePosition(dj, di, d);
      }
    }
  }

  for (int d = ss.size ~/ 2; d > 0; d ~/= 2) {
    diamondStep(d);
    squareStep(d);
    I++;
  }

  return ss;
}
