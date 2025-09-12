class SongEntity {
  final String title;
  final String artist;
  final num duration;
  final DateTime releaseDate;
  final String coverUrl; //
  bool isFavorite;
  final String? songId; // Optional field for song ID

  SongEntity({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.coverUrl,
    required this.isFavorite,
    required this.songId,
  });
}
