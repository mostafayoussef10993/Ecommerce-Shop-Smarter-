// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/domain/usecases/song/get_play_list.dart';
import 'package:musicapp/presentation/home/bloc/play_list_state.dart';
import 'package:musicapp/service_locator.dart';

class PlayListCubit extends Cubit<PlayListState> {
  PlayListCubit() : super(PlayListLoading());

  Future<void> getPlayList() async {
    var returnedSongs = await sl<GetPlayListUseCase>().call();

    returnedSongs.fold(
      (l) {
        print('Error loading songs: $l');
        emit(PlayListFailure());
      },
      (data) {
        print('Loaded songs count: ${data.length}');
        for (var song in data) {
          print('Song: ${song.artist} - ${song.title}');
        }
        emit(PlayListLoaded(songs: data));
      },
    );
  }
}
