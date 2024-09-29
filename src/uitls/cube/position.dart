import 'side.dart';

class CubePosition {
  final CubeSide side;
  final int i;
  final int j;
  final int _size;
  CubePosition(this.side, this.i, this.j, this._size);

  bool operator ==(Object other) {
    if (other is CubePosition) {
      var na = norm();
      var nb = other.norm();
      return na.side.label == nb.side.label && na.i == nb.i && na.j == nb.j;
    }
    return false;
  }

  CubePosition rotate0() {
    if (side.r != 0) {
      return rotate(1).rotate0();
    }
    return this;
  }

  CubePosition norm() {
    if (side.r != 0) {
      return rotate0().norm();
    }

    if (i == 0) {
      if (j == 0) {
        switch (side.label) {
          case CubeSideLabel.B:
            return CubePosition(CubeSide.A0, 0, _size - 1, _size);
          case CubeSideLabel.D:
            return CubePosition(CubeSide.C0, 0, _size - 1, _size);
          case CubeSideLabel.E:
            return CubePosition(CubeSide.C0, 0, _size - 1, _size);
          case CubeSideLabel.F:
            return CubePosition(CubeSide.A0, _size - 1, 0, _size);
          default:
            return this;
        }
      }
      if (j == _size - 1) {
        switch (side.label) {
          case CubeSideLabel.B:
            return CubePosition(CubeSide.C0, 0, 0, _size);
          case CubeSideLabel.D:
            return CubePosition(CubeSide.A0, 0, 0, _size);
          case CubeSideLabel.E:
            return CubePosition(CubeSide.C0, 0, 0, _size);
          case CubeSideLabel.F:
            return CubePosition(CubeSide.A0, _size - 1, _size - 1, _size);
          default:
            return this;
        }
      }
      switch (side.label) {
        case CubeSideLabel.E:
          return CubePosition(CubeSide.C2, _size - 1, j, _size).rotate0();
        case CubeSideLabel.F:
          return CubePosition(CubeSide.A0, _size - 1, j, _size);
        default:
          return this;
      }
    }

    if (i == _size - 1) {
      if (j == 0) {
        switch (side.label) {
          case CubeSideLabel.B:
            return CubePosition(CubeSide.A0, _size - 1, _size - 1, _size);
          case CubeSideLabel.D:
            return CubePosition(CubeSide.C0, _size - 1, _size - 1, _size);
          case CubeSideLabel.E:
            return CubePosition(CubeSide.A0, 0, 0, _size);
          case CubeSideLabel.F:
            return CubePosition(CubeSide.C0, _size - 1, _size - 1, _size);
          default:
            return this;
        }
      }
      if (j == _size - 1) {
        switch (side.label) {
          case CubeSideLabel.B:
            return CubePosition(CubeSide.C0, _size - 1, 0, _size);
          case CubeSideLabel.D:
            return CubePosition(CubeSide.A0, _size - 1, 0, _size);
          case CubeSideLabel.E:
            return CubePosition(CubeSide.A0, 0, _size - 1, _size);
          case CubeSideLabel.F:
            return CubePosition(CubeSide.C0, _size - 1, 0, _size);
          default:
            return this;
        }
      }
      switch (side.label) {
        case CubeSideLabel.E:
          return CubePosition(CubeSide.A0, 0, j, _size);
        case CubeSideLabel.F:
          return CubePosition(CubeSide.C2, 0, j, _size).rotate0();
        default:
          return this;
      }
    }

    if (j == 0) {
      switch (side.label) {
        case CubeSideLabel.D:
          return CubePosition(CubeSide.C0, i, _size - 1, _size);
        case CubeSideLabel.B:
          return CubePosition(CubeSide.A0, i, _size - 1, _size);
        case CubeSideLabel.E:
          return CubePosition(CubeSide.D1, i, _size - 1, _size).rotate0();
        case CubeSideLabel.F:
          return CubePosition(CubeSide.D3, i, _size - 1, _size).rotate0();
        default:
          return this;
      }
    }

    if (j == _size - 1) {
      switch (side.label) {
        case CubeSideLabel.D:
          return CubePosition(CubeSide.A0, i, 0, _size);
        case CubeSideLabel.B:
          return CubePosition(CubeSide.C0, i, 0, _size);
        case CubeSideLabel.E:
          return CubePosition(CubeSide.B3, i, 0, _size).rotate0();
        case CubeSideLabel.F:
          return CubePosition(CubeSide.B1, i, 0, _size).rotate0();
        default:
          return this;
      }
    }

    return this;
  }

  CubePosition rotate(int r) {
    r = (1024 * 1024 + r) % 4;
    if (r == 0) {
      return this;
    }
    if (r == 1) {
      var nextSide = CubeSide(side.label, side.r + 1);
      return CubePosition(nextSide, j, _size - 1 - i, _size);
    }

    return rotate(1).rotate(r - 1);
  }

  @override
  String toString() {
    return '<${side},${i},${j}>';
  }
}
