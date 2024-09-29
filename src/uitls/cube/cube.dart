import '../matrix.dart';
import 'position.dart';
import 'side.dart';

class Cube<T> {
  Matrix<T> _sideA;
  Matrix<T> _sideB;
  Matrix<T> _sideC;
  Matrix<T> _sideD;
  Matrix<T> _sideE;
  Matrix<T> _sideF;

  final int size;

  Cube(this.size, T def)
      : _sideA = Matrix.filled(size, size, def),
        _sideB = Matrix.filled(size, size, def),
        _sideC = Matrix.filled(size, size, def),
        _sideD = Matrix.filled(size, size, def),
        _sideE = Matrix.filled(size, size, def),
        _sideF = Matrix.filled(size, size, def);

  Matrix<T> getSide(CubeSide side) {
    return _getSide0(side.label).rotate90(side.r);
  }

  Matrix<T> _getSide0(CubeSideLabel label) {
    switch (label) {
      case CubeSideLabel.A:
        return _sideA;
      case CubeSideLabel.B:
        return _sideB;
      case CubeSideLabel.C:
        return _sideC;
      case CubeSideLabel.D:
        return _sideD;
      case CubeSideLabel.E:
        return _sideE;
      case CubeSideLabel.F:
        return _sideF;
    }
  }

  CubePosition getPosition(CubeSide side, int i, int j, [int iter = 0]) {
    if (i < 0) {
      return getPosition(CubeSide.getTopSide(side), i + size - 1, j);
    }
    if (i >= size) {
      return getPosition(CubeSide.getBottomSide(side), i - size + 1, j);
    }
    if (j < 0) {
      return getPosition(CubeSide.getLeftSide(side), i, j + size - 1);
    }
    if (j >= size) {
      return getPosition(CubeSide.getRightSide(side), i, j - size + 1);
    }

    return CubePosition(side, i, j, size);
  }

  T get(CubeSide side, int i, int j) {
    var pos = getPosition(side, i, j).rotate0();
    if (pos.side.r == 0) {
      return _getSide0(pos.side.label)[pos.i][pos.j];
    }
    return getSide(pos.side)[pos.i][pos.j];
  }

  void _set(CubePosition pos, T v) {
    pos = pos.rotate0();
    _getSide0(pos.side.label).set(pos.i, pos.j, v);
  }

  void set(CubeSide side, int i, int j, T v) {
    var pos = getPosition(side, i, j);

    _set(pos, v);

    if (i == 0) {
      var top = CubeSide.getTopSide(pos.side);
      var topPos = CubePosition(top, size - 1, j, size);
      _set(topPos, v);
    }

    if (j == 0) {
      var left = CubeSide.getLeftSide(pos.side);
      var leftPos = CubePosition(left, i, size - 1, size);
      _set(leftPos, v);
    }

    if (i == size - 1) {
      var bottom = CubeSide.getBottomSide(pos.side);
      var bottomPos = CubePosition(bottom, 0, j, size);
      _set(bottomPos, v);
    }

    if (j == size - 1) {
      var right = CubeSide.getRightSide(pos.side);
      var rightPos = CubePosition(right, i, 0, size);
      _set(rightPos, v);
    }
  }
}
