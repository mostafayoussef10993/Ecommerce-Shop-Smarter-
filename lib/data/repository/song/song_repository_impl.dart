import 'package:dartz/dartz.dart';
import 'package:musicapp/data/sources/song/song_supabase_service.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:musicapp/domain/repository/song/song.dart';
import 'package:musicapp/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    return await sl<SongSupabaseService>().getNewsSongs();
  }

  @override
  Future<Either<String, List<SongEntity>>> getPlayList() async {
    return await sl<SongSupabaseService>().getPlayList();
  }

  @override
  Future<Either<String, bool>> toggleFavoriteSong(
    String userId,
    String songId,
  ) async {
    return await sl<SongSupabaseService>().toggleFavoriteSong(
      userId,
      songId,
    ); // ✅ تعديل هنا
  }

  @override
  Future<bool> isFavoriteSong(String userId, String songId) async {
    return await sl<SongSupabaseService>().isFavoriteSong(userId, songId);
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    return await sl<SongSupabaseService>().getUserFavoriteSongs();
  }
}
