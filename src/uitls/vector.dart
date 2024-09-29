import 'dart:math';

class Vector {
  num x;
  num y;
  num z;
  Vector(this.x, this.y, [this.z = 0]);

  Vector operator +(Vector other) {
    return Vector(x + other.x, y + other.y, z + other.z);
  }

  Vector operator -(Vector other) {
    return Vector(x - other.x, y - other.y, z - other.z);
  }

  Vector operator *(num k) {
    return Vector(x * k, y * k, z * k);
  }

  Vector operator -() {
    return Vector(-x, -y, -z);
  }

  num get magn {
    return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }

  Vector get norm {
    if (magn == 0) {
      return Vector(0, 0, 0);
    }
    return Vector(x / magn, y / magn, z / magn);
  }

  num dot(Vector other) {
    return x * other.x + y * other.y + z * other.z;
  }

  Vector cross(Vector other) {
    return Vector(
      this.y * other.z - this.z * other.y,
      this.z * other.x - this.x * other.z,
      this.x * other.y - this.y * other.x,
    );
  }

  Vector rotX(num a) {
    return Vector(x, y * cos(a) + z * sin(a), -y * sin(a) + z * cos(a));
  }

  Vector rotY(num a) {
    return Vector(x * cos(a) - z * sin(a), y, x * sin(a) + z * cos(a));
  }

  Vector rotZ(num a) {
    return Vector(x * cos(a) - y * sin(a), x * sin(a) + y * cos(a), z);
  }

  @override
  String toString() {
    return 'Vec <$x $y $z>';
  }
}
