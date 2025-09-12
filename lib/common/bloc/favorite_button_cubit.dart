// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/common/bloc/favorite_button_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // فوق مع الاستيرادات

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  Future<void> favoriteButtonUpdated(String songId) async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email?.toLowerCase();
      if (email == null) {
        print("⚠️ No Firebase user logged in.");
        return;
      }

      // هات الـ id من Supabase
      final userRecord = await Supabase.instance.client
          .from('users')
          .select('id, favorites')
          .eq('email', email)
          .maybeSingle();

      if (userRecord == null) {
        print("⚠️ No matching user found in Supabase.");
        return;
      }

      final userId = userRecord['id'];
      final currentFavorites = List<String>.from(userRecord['favorites'] ?? []);

      // Toggle المفضلة
      bool isFavorite;
      if (currentFavorites.contains(songId)) {
        currentFavorites.remove(songId);
        isFavorite = false;
      } else {
        currentFavorites.add(songId);
        isFavorite = true;
      }

      // حفظ التغيير في Supabase
      await Supabase.instance.client
          .from('users')
          .update({'favorites': currentFavorites})
          .eq('id', userId);

      emit(FavoriteButtonUpdated(isFavorite: isFavorite));
      print("✅ Favorite updated: $isFavorite");
    } catch (e) {
      print("❌ Exception in favoriteButtonUpdated: $e");
    }
  }
}
