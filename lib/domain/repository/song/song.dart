import 'package:dartz/dartz.dart';
import 'package:musicapp/domain/entities/song/song.dart';

abstract class SongRepository {
  Future<Either<String, List<SongEntity>>> getNewsSongs();
  Future<Either<String, List<SongEntity>>> getPlayList();
  Future<Either<String, bool>> toggleFavoriteSong(String userId, String songId);
  Future<bool> isFavoriteSong(String userId, String songId);
  Future<Either> getUserFavoriteSongs();
}
