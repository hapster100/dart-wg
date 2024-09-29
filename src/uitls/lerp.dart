import 'color.dart';

num lerp(num val, num sMin, num sMax, [num tMin = 0, num tMax = 1]) {
  num td = tMax - tMin;
  num sd = sMax - sMin;
  return td * (val - sMin) / sd + tMin;
}

Color lerpColor(num val, num sMin, num sMax, Color minCol, Color maxCol) {
  return Color(
    lerp(val, sMin, sMax, minCol.r, maxCol.r).toInt(),
    lerp(val, sMin, sMax, minCol.g, maxCol.g).toInt(),
    lerp(val, sMin, sMax, minCol.b, maxCol.b).toInt(),
  );
}
