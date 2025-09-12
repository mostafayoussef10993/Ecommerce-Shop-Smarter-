// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/domain/usecases/song/get_news_songs.dart';
import 'package:musicapp/presentation/home/bloc/news_songs_state.dart';
import 'package:musicapp/service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  NewsSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    var returnedSongs = await sl<GetNewsSongsUseCase>().call();

    returnedSongs.fold(
      (l) {
        print('Error loading songs: $l');
        emit(NewsSongsLoadFailure());
      },
      (data) {
        print('Loaded songs count: ${data.length}');
        for (var song in data) {
          print('Song: ${song.artist} - ${song.title}');
        }
        emit(NewsSongsLoaded(songs: data));
      },
    );
  }
}
