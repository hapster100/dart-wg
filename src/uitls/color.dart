class Color {
  final int r;
  final int g;
  final int b;
  Color(this.r, this.g, this.b);
  Color.grayN(int x) : this(x, x, x);
  Color.redN(int x) : this(x, 0, 0);
  Color.greenN(int x) : this(0, x, 0);
  Color.blueN(int x) : this(0, 0, x);
  Color.yellowN(int x) : this(x, x, 0);
  Color.purpleN(int x) : this(x, 0, x);
  Color.cyanN(int x) : this(0, x, x);
  const Color.constC(this.r, this.g, this.b);

  static const Color white = Color.constC(255, 255, 255);
  static const Color black = Color.constC(0, 0, 0);
  static const Color red = Color.constC(255, 0, 0);
  static const Color green = Color.constC(0, 255, 0);
  static const Color blue = Color.constC(0, 0, 255);
  static const Color purple = Color.constC(255, 0, 255);
  static const Color yellow = Color.constC(255, 255, 0);
  static const Color cyan = Color.constC(0, 255, 255);

  bool operator ==(Object o) {
    if (o is Color) {
      return r == o.r && g == o.g && b == o.b;
    }
    return false;
  }
}
