import 'helper.dart';

class Square implements Comparable<Square> {
  final int rank;
  final int file;
  late bool isWhiteSquare;
  late int idx;
  late bool highlighted;
  late Piece? piece;

  Square(this.rank, this.file,{this.piece}) {
    idx = file + rank * 8;
    highlighted = false;
    isWhiteSquare = (rank + file) % 2 == 0;
  }

  @override
  int compareTo(Square other) {
    return idx.compareTo(other.idx);
  }

  void prettify() {
    print(
        "Position: $idx, File: $file, Rank: $rank, Piece: $piece,");
  }
}
