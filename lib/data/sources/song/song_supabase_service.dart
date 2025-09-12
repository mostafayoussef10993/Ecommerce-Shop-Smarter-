import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicapp/data/models/song/song.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SongSupabaseService {
  Future<Either<String, List<SongEntity>>> getNewsSongs();
  Future<Either<String, List<SongEntity>>> getPlayList();
  Future<Either<String, bool>> toggleFavoriteSong(String userId, String songId);
  Future<bool> isFavoriteSong(String userId, String songId);
  Future<Either> getUserFavoriteSongs();
}

class SongSupabaseServiceImpl implements SongSupabaseService {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    try {
      final response = await supabase
          .from('songs')
          .select()
          .order('releaseDate', ascending: false)
          .limit(3);

      final songs = (response as List)
          .map((item) => SongModel.fromJson(item).toEntity())
          .toList();
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final favRes = await supabase
            .from('users')
            .select('favorites')
            .eq('id', userId)
            .single();

        final favList = List<String>.from(favRes['favorites'] ?? []);

        for (var song in songs) {
          song.isFavorite = favList.contains(song.songId);
        }
      }

      return Right(songs);
    } catch (e) {
      return Left('Error fetching news songs: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getPlayList() async {
    try {
      final response = await supabase
          .from('songs')
          .select()
          .order('releaseDate', ascending: false);

      final songs = (response as List)
          .map((item) => SongModel.fromJson(item).toEntity())
          .toList();
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final favRes = await supabase
            .from('users')
            .select('favorites')
            .eq('id', userId)
            .single();

        final favList = List<String>.from(favRes['favorites'] ?? []);

        for (var song in songs) {
          song.isFavorite = favList.contains(song.songId);
        }
      }

      return Right(songs);
    } catch (e) {
      return Left('Error fetching playlist: $e');
    }
  }

  @override
  Future<Either<String, bool>> toggleFavoriteSong(
    String userId,
    String songId,
  ) async {
    try {
      final response = await supabase
          .from('users')
          .select('favorites')
          .eq('id', userId)
          .single();

      final favorites = List<String>.from(response['favorites'] ?? []);

      bool isNowFavorite;
      if (favorites.contains(songId)) {
        favorites.remove(songId);
        isNowFavorite = false;
      } else {
        favorites.add(songId);
        isNowFavorite = true;
      }

      await supabase
          .from('users')
          .update({'favorites': favorites})
          .eq('id', userId);

      return Right(isNowFavorite);
    } catch (e) {
      return Left('Error toggling favorite: $e');
    }
  }

  @override
  Future<bool> isFavoriteSong(String userId, String songId) async {
    try {
      final response = await supabase
          .from('users')
          .select('favorites')
          .eq('id', userId)
          .single();

      final favorites = List<String>.from(response['favorites'] ?? []);
      return favorites.contains(songId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = firebaseAuth.currentUser;
      if (user == null) {
        return Left('ما لقيناش مستخدم متصل');
      }
      List<SongEntity> favoriteSongs = [];
      String userId = user.uid;
      final response = await supabase
          .from('users')
          .select('favorites')
          .eq('id', userId)
          .single();

      final favorites = List<String>.from(response['favorites'] ?? []);
      if (favorites.isEmpty) {
        return Right(favoriteSongs); // رجّع قائمة فاضية لو مفيش أغاني مفضلة
      }

      for (String songId in favorites) {
        final songResponse = await supabase
            .from('songs')
            .select()
            .eq('id', songId) // استخدم 'id' بدل 'songId' لو اتطابق مع الجدول
            .single();
        favoriteSongs.add(SongModel.fromJson(songResponse).toEntity());
      }
      return Right(favoriteSongs);
    } catch (e) {
      return Left('فشل تحميل الأغاني المفضلة: $e');
    }
  }
}
