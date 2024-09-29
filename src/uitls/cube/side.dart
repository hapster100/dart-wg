enum CubeSideLabel { A, B, C, D, E, F }

Map<CubeSideLabel, List<(CubeSideLabel, int)>> _side = {
  CubeSideLabel.A: [
    (CubeSideLabel.E, 0),
    (CubeSideLabel.B, 0),
    (CubeSideLabel.F, 0),
    (CubeSideLabel.D, 0)
  ],
  CubeSideLabel.B: [
    (CubeSideLabel.E, 1),
    (CubeSideLabel.C, 0),
    (CubeSideLabel.F, 3),
    (CubeSideLabel.A, 0)
  ],
  CubeSideLabel.C: [
    (CubeSideLabel.E, 2),
    (CubeSideLabel.D, 0),
    (CubeSideLabel.F, 2),
    (CubeSideLabel.B, 0)
  ],
  CubeSideLabel.D: [
    (CubeSideLabel.E, 3),
    (CubeSideLabel.A, 0),
    (CubeSideLabel.F, 1),
    (CubeSideLabel.C, 0)
  ],
  CubeSideLabel.E: [
    (CubeSideLabel.C, 2),
    (CubeSideLabel.B, 3),
    (CubeSideLabel.A, 0),
    (CubeSideLabel.D, 1)
  ],
  CubeSideLabel.F: [
    (CubeSideLabel.A, 0),
    (CubeSideLabel.B, 1),
    (CubeSideLabel.C, 2),
    (CubeSideLabel.D, 3)
  ],
};

class CubeSide {
  final CubeSideLabel label;
  final int r;
  CubeSide(this.label, int r) : r = r % 4;

  static final A0 = CubeSide(CubeSideLabel.A, 0);
  static final B0 = CubeSide(CubeSideLabel.B, 0);
  static final C0 = CubeSide(CubeSideLabel.C, 0);
  static final D0 = CubeSide(CubeSideLabel.D, 0);
  static final E0 = CubeSide(CubeSideLabel.E, 0);
  static final F0 = CubeSide(CubeSideLabel.F, 0);

  static final List<CubeSide> zeroSides = [
    CubeSide.A0,
    CubeSide.B0,
    CubeSide.C0,
    CubeSide.D0,
    CubeSide.E0,
    CubeSide.F0,
  ];

  static final A1 = CubeSide(CubeSideLabel.A, 1);
  static final B1 = CubeSide(CubeSideLabel.B, 1);
  static final C1 = CubeSide(CubeSideLabel.C, 1);
  static final D1 = CubeSide(CubeSideLabel.D, 1);
  static final E1 = CubeSide(CubeSideLabel.E, 1);
  static final F1 = CubeSide(CubeSideLabel.F, 1);

  static final A2 = CubeSide(CubeSideLabel.A, 2);
  static final B2 = CubeSide(CubeSideLabel.B, 2);
  static final C2 = CubeSide(CubeSideLabel.C, 2);
  static final D2 = CubeSide(CubeSideLabel.D, 2);
  static final E2 = CubeSide(CubeSideLabel.E, 2);
  static final F2 = CubeSide(CubeSideLabel.F, 2);

  static final A3 = CubeSide(CubeSideLabel.A, 3);
  static final B3 = CubeSide(CubeSideLabel.B, 3);
  static final C3 = CubeSide(CubeSideLabel.C, 3);
  static final D3 = CubeSide(CubeSideLabel.D, 3);
  static final E3 = CubeSide(CubeSideLabel.E, 3);
  static final F3 = CubeSide(CubeSideLabel.F, 3);

  static CubeSide getRightSide(CubeSide side) {
    var p = _side[side.label]![(5 - side.r) % 4];
    return CubeSide(p.$1, side.r + p.$2);
  }

  static CubeSide getLeftSide(CubeSide side) {
    var p = _side[side.label]![(7 - side.r) % 4];
    return CubeSide(p.$1, side.r + p.$2);
  }

  static CubeSide getTopSide(CubeSide side) {
    var p = _side[side.label]![(4 - side.r) % 4];
    return CubeSide(p.$1, side.r + p.$2);
  }

  static CubeSide getBottomSide(CubeSide side) {
    var p = _side[side.label]![(6 - side.r) % 4];
    return CubeSide(p.$1, side.r + p.$2);
  }

  operator ==(Object other) {
    if (other is CubeSide) {
      return other.label == label && other.r == r;
    }
    return false;
  }

  @override
  String toString() {
    return '${label.name}${r}';
  }
}
