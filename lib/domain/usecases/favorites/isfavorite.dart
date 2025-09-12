import 'package:musicapp/core/usecase/usecase.dart';
import 'package:musicapp/domain/repository/song/song.dart';
import 'package:musicapp/service_locator.dart';

class IsFavoriteSongUseCase implements UseCase<bool, IsFavoriteSongParams> {
  @override
  Future<bool> call({IsFavoriteSongParams? params}) async {
    if (params == null) throw Exception("Params are required");
    return await sl<SongRepository>().isFavoriteSong(
      params.userId,
      params.songId,
    );
  }
}

class IsFavoriteSongParams {
  final String userId;
  final String songId;

  IsFavoriteSongParams({required this.userId, required this.songId});
}
