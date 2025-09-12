//import 'package:supabase_flutter/supabase_flutter.dart';

//abstract class FavoritesRemoteDataSource {
  //Future<void> toggleFavoriteSong(String userId, String songId);
//}

//class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  //final SupabaseClient client;

  //FavoritesRemoteDataSourceImpl(this.client);

  //@override
  //Future<void> toggleFavoriteSong(String userId, String songId) async {
    //final response = await client
      //  .from('users')
       // .select('favorites')
        //.eq('id', userId)
        //.single();

    //List<String> favorites = List<String>.from(response['favorites'] ?? []);

    //if (favorites.contains(songId)) {
      //favorites.remove(songId);
    //} else {
     // favorites.add(songId);
    //}

    //await client
      //  .from('users')
        //.update({'favorites': favorites})
        //.eq('id', userId);
 // }
//}
