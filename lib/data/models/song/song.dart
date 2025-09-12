import 'package:musicapp/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  DateTime? releaseDate;
  String? coverUrl;
  bool? isFavorite;
  String? songId;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.coverUrl,
    required this.isFavorite,
    required this.songId,
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'] != null
        ? DateTime.parse(data['releaseDate'])
        : null;
    coverUrl = data['coverUrl'];
    songId = data['id']; // ✅ نقرأ الـ id من الـ DB
    isFavorite = false; // هيتعدل بعد الجلب حسب المستخدم
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title ?? '',
      artist: artist ?? '',
      duration: duration ?? 0,
      releaseDate: releaseDate ?? DateTime.now(),
      coverUrl: coverUrl ?? '',
      isFavorite: isFavorite ?? false,
      songId: songId ?? '',
    );
  }
}
