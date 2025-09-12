import 'package:dartz/dartz.dart';
import 'package:musicapp/core/usecase/usecase.dart';
import 'package:musicapp/domain/repository/song/song.dart';
import 'package:musicapp/service_locator.dart';

class ToggleFavoriteSongUseCase
    implements UseCase<Either<String, bool>, ToggleFavoriteSongParams> {
  @override
  Future<Either<String, bool>> call({ToggleFavoriteSongParams? params}) async {
    if (params == null) return Left("Params are required");
    return await sl<SongRepository>().toggleFavoriteSong(
      params.userId,
      params.songId,
    );
  }
}

class ToggleFavoriteSongParams {
  final String userId;
  final String songId;

  ToggleFavoriteSongParams({required this.userId, required this.songId});
}
