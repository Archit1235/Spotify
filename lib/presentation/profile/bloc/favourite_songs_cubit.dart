import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/get_favourite_songs.dart';
import 'package:spotify/presentation/profile/bloc/favourite_songs_state.dart';
import 'package:spotify/service_locator.dart';

class FavouriteSongsCubit extends Cubit<FavouriteSongsState> {
  FavouriteSongsCubit() : super(FavouriteSongsLoading());

  List<SongEntity> favouriteSongs = [];

  Future<void> getFavouriteSongs() async {
    var result = await sl<GetFavouriteSongsUseCase>().call();

    result.fold((l) {
      emit(FavouriteSongsFailure());
    }, (r) {
      favouriteSongs = r;
      emit(FavouriteSongsLoaded(favouriteSongs: favouriteSongs));
    });
  }

  void removeFavouriteSong(int index) async {
    favouriteSongs.removeAt(index);
    emit(FavouriteSongsLoaded(favouriteSongs: favouriteSongs));
  }
}
