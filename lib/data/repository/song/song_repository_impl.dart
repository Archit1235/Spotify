import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/song/song_firebase_service.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either> getNewsSongs() async {
    return await sl<SongFirebaseService>().getNewsSongs();
  }

  @override
  Future<Either> getPlayList() async {
    return await sl<SongFirebaseService>().getPlayList();
  }

  @override
  Future<Either> addOrRemoveFavouriteSong(String songId) async {
    return await sl<SongFirebaseService>().addOrRemoveFavouriteSong(songId);
  }

  @override
  Future<bool> isFavouriteSong(String songId) async {
    return await sl<SongFirebaseService>().isFavouriteSong(songId);
  }

  @override
  Future<Either> getUserFavouriteSongs() async {
    return await sl<SongFirebaseService>().getUserFavouriteSongs();
  }
}
