import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/is_favourite_song.dart';
import 'package:spotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavouriteSong(String songId);
  Future<bool> isFavouriteSong(String songId);
  Future<Either> getUserFavouriteSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];

      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(3)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());

        bool isFavourite = await sl<IsFavouriteSongUseCase>()
            .call(params: element.reference.id);
        songModel.isFavourite = isFavourite;
        songModel.songId = element.reference.id;

        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, please try again later.');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];

      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());

        bool isFavourite = await sl<IsFavouriteSongUseCase>()
            .call(params: element.reference.id);
        songModel.isFavourite = isFavourite;
        songModel.songId = element.reference.id;

        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, please try again later.');
    }
  }

  @override
  Future<Either> addOrRemoveFavouriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavourite;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favouriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favourites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favouriteSongs.docs.isNotEmpty) {
        await favouriteSongs.docs.first.reference.delete();

        isFavourite = false;
      } else {
        firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('Favourites')
            .add({
          'songId': songId,
          'addedDate': Timestamp.now(),
        });

        isFavourite = true;
      }

      return Right(isFavourite);
    } catch (e) {
      return const Left('An error occurred, please try again later.');
    }
  }

  @override
  Future<bool> isFavouriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favouriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favourites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favouriteSongs.docs.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavouriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      List<SongEntity> favouriteSongs = [];
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favouriteSnapshot = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favourites')
          .get();

      for (var element in favouriteSnapshot.docs) {
        String songId = element['songId'];

        var song =
            await firebaseFirestore.collection('Songs').doc(songId).get();

        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavourite = true;
        songModel.songId = songId;
        favouriteSongs.add(songModel.toEntity());
      }

      return Right(favouriteSongs);
    } catch (e) {
      return const Left('An error occurred, please try again later.');
    }
  }
}
