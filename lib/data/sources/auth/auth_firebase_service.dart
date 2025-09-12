import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicapp/core/config/constants/app_urls.dart';
import 'package:musicapp/data/models/auth/create_user_req.dart';
import 'package:musicapp/data/models/auth/signin_user_req.dart';
import 'package:musicapp/data/models/auth/user.dart';
import 'package:musicapp/domain/entities/auth/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final supabase = Supabase.instance.client; // Supabase instance

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: createUserReq.email,
            password: createUserReq.password,
          );

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await supabase.from('users').insert({
          'id': firebaseUser.uid,
          'userName': createUserReq.fullName,
          'email': firebaseUser.email?.toLowerCase(),
          'favorites': [],
        });
      }

      return Right('Sign Up was successful');
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = e.message ?? 'FirebaseAuth error';
      }
      return left(message);
    } catch (e) {
      return left('Unexpected error: $e');
    }
  }

  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: signinUserReq.email,
            password: signinUserReq.password,
          );

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final email = firebaseUser.email?.toLowerCase();

        final existingUser = await supabase
            .from('users')
            .select('id')
            .eq('id', firebaseUser.uid)
            .maybeSingle();

        if (existingUser == null) {
          await supabase.from('users').insert({
            'id': firebaseUser.uid,
            'userName': firebaseUser.displayName ?? 'Unknown',
            'email': email,
            'favorites': [],
          });
        }
      }

      return Right('Sign in was successful');
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        message = 'The email or password is incorrect.';
      } else {
        message = e.message ?? 'FirebaseAuth error';
      }
      return left(message);
    } catch (e) {
      return left('Unexpected error: $e');
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final uid = firebaseAuth.currentUser?.uid;

      if (uid == null) {
        return left("User not logged in");
      }

      final response = await supabase
          .from('users')
          .select()
          .eq('id', uid)
          .single();

      UserModel userModel = UserModel.fromJson(response);
      userModel.imageURL =
          firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;

      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return left("Unexpected error: $e");
    }
  }
}
