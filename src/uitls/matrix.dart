class _MatrixRow<T> {
  Matrix<T> _matrix;
  int _index;

  _MatrixRow(this._matrix, this._index);

  T operator [](int j) {
    return this._matrix.get(_index, j);
  }

  void operator []=(int j, T v) {
    this._matrix.saveSet(_index, j, v);
  }
}

class _MatrixIterator<T> implements Iterator<T> {
  Matrix<T> _matrix;
  int _i = 0;
  int _j = -1;
  _MatrixIterator(this._matrix);

  bool moveNext() {
    _j++;
    if (_j == _matrix.width) {
      _i++;
      _j = 0;
    }
    return _matrix.inBound(_i, _j);
  }

  T get current {
    return _matrix.get(_i, _j);
  }
}

class Matrix<T> extends Iterable<T> {
  List<List<T>> _data;

  Matrix(this._data);
  Matrix.filled(int height, int width, T v)
      : this(List.generate(height, (i) => List.filled(width, v)));
  Matrix.generate(int height, int width, T Function(int, int) f)
      : this(
            List.generate(height, (i) => List.generate(width, (j) => f(i, j))));

  int get height {
    return this._data.length;
  }

  int get width {
    return height > 0 ? this._data[0].length : 0;
  }

  _MatrixRow<T> operator [](int i) {
    return _MatrixRow(this, i);
  }

  bool inBound(int i, int j) {
    return i >= 0 && i < height && j >= 0 && j < width;
  }

  T get(int i, int j) {
    return _data[i][j];
  }

  T? saveGet(i, j) {
    if (!inBound(i, j)) return null;
    return get(i, j);
  }

  void set(int i, int j, T v) {
    _data[i][j] = v;
  }

  void saveSet(int i, int j, T v) {
    if (!inBound(i, j)) return null;
    set(i, j, v);
  }

  List<List<T>> toLists() {
    return List.generate(height, (i) {
      return List.generate(width, (j) {
        return _data[i][j];
      });
    });
  }

  Matrix<T> rotate90(int i) {
    if (i < 0) return rotate90(i + 1024 * 1024);
    i = i % 4;
    if (i == 0) {
      return this.map((v) => v);
    }

    if (i == 1) {
      return Matrix.generate(width, height, (i, j) {
        int ii = height - 1 - j;
        int jj = i;
        return get(ii, jj);
      });
    }

    if (i == 3) {
      return Matrix.generate(width, height, (i, j) {
        int ii = j;
        int jj = width - 1 - i;
        return get(ii, jj);
      });
    }

    return rotate90(1).rotate90(1);
  }

  Matrix<TargetType> map<TargetType>(TargetType Function(T) f) {
    List<List<TargetType>> data =
        _data.map((row) => row.map(f).toList()).toList();
    return Matrix(data);
  }

  @override
  Iterator<T> get iterator {
    return _MatrixIterator(this);
  }
}
