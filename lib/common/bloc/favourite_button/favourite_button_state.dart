abstract class FavouriteButtonState {}

class FavouriteButtonInitial extends FavouriteButtonState {}

class FavouriteButtonUpdated extends FavouriteButtonState {
  final bool isFavourite;

  FavouriteButtonUpdated({required this.isFavourite});
}
