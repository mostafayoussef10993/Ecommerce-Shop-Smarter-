import 'package:dartz/dartz.dart';
import 'package:musicapp/core/usecase/usecase.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:musicapp/domain/repository/song/song.dart';
import 'package:musicapp/service_locator.dart';

class GetNewsSongsUseCase
    implements UseCase<Either<String, List<SongEntity>>, void> {
  @override
  Future<Either<String, List<SongEntity>>> call({params}) async {
    return await sl<SongRepository>().getNewsSongs();
  }
}
