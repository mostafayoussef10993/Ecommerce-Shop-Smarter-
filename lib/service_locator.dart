import 'package:get_it/get_it.dart';
import 'package:musicapp/data/repository/auth/auth_repository_impl.dart';
import 'package:musicapp/data/repository/song/song_repository_impl.dart';
import 'package:musicapp/data/sources/auth/auth_firebase_service.dart';
import 'package:musicapp/data/sources/song/song_supabase_service.dart';
import 'package:musicapp/domain/repository/auth/auth.dart';
import 'package:musicapp/domain/repository/song/song.dart';
import 'package:musicapp/domain/usecases/auth/get_user.dart';
import 'package:musicapp/domain/usecases/auth/signin.dart';
import 'package:musicapp/domain/usecases/auth/signup.dart';
import 'package:musicapp/domain/usecases/favorites/get_favorite_songs.dart';
import 'package:musicapp/domain/usecases/favorites/isfavorite.dart';
import 'package:musicapp/domain/usecases/favorites/toggle_favorite_song.dart';
import 'package:musicapp/domain/usecases/song/get_news_songs.dart';
import 'package:musicapp/domain/usecases/song/get_play_list.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  sl.registerSingleton<SongSupabaseService>(SongSupabaseServiceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<SongRepository>(SongRepositoryImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  sl.registerSingleton<GetNewsSongsUseCase>(GetNewsSongsUseCase());

  sl.registerSingleton<GetPlayListUseCase>(GetPlayListUseCase());

  sl.registerSingleton<ToggleFavoriteSongUseCase>(ToggleFavoriteSongUseCase());

  sl.registerSingleton<IsFavoriteSongUseCase>(IsFavoriteSongUseCase());

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  sl.registerSingleton<GetFavoriteSongsUseCase>(GetFavoriteSongsUseCase());
}
