import 'cube/side.dart';
import 'vector.dart';

intersect(Vector p0, Vector pu, Vector pv, Vector x0, Vector x1) {
  var p0x0 = x0 - p0;
  var d = (x0 - x1).dot(pu.cross(pv));
  var t = pu.cross(pv).dot(p0x0) / d;
  var u = pv.cross(x0 - x1).dot(p0x0) / d;
  var v = (x0 - x1).cross(pu).dot(p0x0) / d;

  return (t, u > -1 && v > -1 && u < 1 && v < 1, u / 2 + 1 / 2, v / 2 + 1 / 2);
}

intersectCube(int size, Vector a0, Vector b0, Vector c0, Vector d0, Vector e0,
    Vector f0, Vector v0, Vector vd) {
  var intrs = [
    (CubeSide.A0, intersect(a0, f0, b0, v0, v0 + vd)),
    (CubeSide.B0, intersect(b0, f0, c0, v0, v0 + vd)),
    (CubeSide.C0, intersect(c0, f0, d0, v0, v0 + vd)),
    (CubeSide.D0, intersect(d0, f0, a0, v0, v0 + vd)),
    (CubeSide.E0, intersect(e0, a0, b0, v0, v0 + vd)),
    (CubeSide.F0, intersect(f0, c0, b0, v0, v0 + vd)),
  ].where((el) => el.$2.$2 && el.$2.$1 > 0).toList()
    ..sort((a, b) => a.$2.$1.compareTo(b.$2.$1));

  if (intrs.length > 0) {
    var (side, inter) = intrs[0];
    return (side, (inter.$3 * size).floor(), (inter.$4 * size).floor());
  }

  return null;
}
