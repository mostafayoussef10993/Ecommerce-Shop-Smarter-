import 'package:musicapp/domain/entities/song/song.dart';

abstract class FavoriteSongsState {}

class FavoriteSongsLoading extends FavoriteSongsState {}

class FavoriteSongsLoaded extends FavoriteSongsState {
  final List<SongEntity> favoriteSongs;

  FavoriteSongsLoaded({required this.favoriteSongs});
}

class FavoriteSongsFailure extends FavoriteSongsState {
  final String? message;

  FavoriteSongsFailure({this.message = "Failed to load favorite songs."});
}
