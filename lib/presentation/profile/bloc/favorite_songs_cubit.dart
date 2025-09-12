import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:musicapp/domain/usecases/favorites/get_favorite_songs.dart';
import 'package:musicapp/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:musicapp/service_locator.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsLoading());

  List<SongEntity> favoriteSongs = [];

  Future<void> getFavoriteSongs() async {
    var result = await sl<GetFavoriteSongsUseCase>().call();

    result.fold(
      (l) {
        emit(FavoriteSongsFailure());
      },
      (r) {
        favoriteSongs = r;
        print("Favorite Songs Loaded: $favoriteSongs");
        emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
      },
    );
  }
}
