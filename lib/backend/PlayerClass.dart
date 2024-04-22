class Player{
  final String name;
  int _rating = 1200;
  Player(this.name);

  void updateRating(int addRating){
    _rating += addRating;
  }

  int get rating => _rating;

}