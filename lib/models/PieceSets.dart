class PieceSet {
  String name;
  late String path;
  late String path2x;
  late String path3x;
  late String path4x;

  PieceSet({required this.name}) {
    path = 'assets/piece_sets/$name/';
    path2x = 'assets/piece_sets/$name/2.0x/';
    path3x = 'assets/piece_sets/$name/3.0x/';
    path4x = 'assets/piece_sets/$name/4.0x/';
  }

  void changePieceSet(String name) {
    this.name = name;
    path = 'assets/piece_sets/$name/';
    path2x = 'assets/piece_sets/$name/2.0x/';
    path3x = 'assets/piece_sets/$name/3.0x/';
    path4x = 'assets/piece_sets/$name/4.0x/';
  }
}

var myPieceSet = PieceSet(name: 'alpha');

List<String> pieceSetNames = [
  'alpha',
  'california',
  'caliente',
  'cardinal',
  'cburnett',
  'celtic',
  'chess7',
  'chessnut',
  'companion',
  'disguised',
  'dubrovny',
  'fantasy',
  'fresca',
  'gioco',
  'governor',
  'icpieces',
  'kosal',
  'leipzig',
  'libra',
  'maestro',
  'merida',
  'mpchess',
  'pirouetti',
  'reillycraig',
  'riohacha',
  'spatial',
  'staunty',
  'tatiana'
];
