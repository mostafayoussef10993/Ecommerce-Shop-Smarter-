import 'package:dartz/dartz.dart';
import 'package:musicapp/data/models/auth/create_user_req.dart';
import 'package:musicapp/data/models/auth/signin_user_req.dart';
import 'package:musicapp/data/sources/auth/auth_firebase_service.dart';
import 'package:musicapp/domain/repository/auth/auth.dart';
import 'package:musicapp/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
    // Implement signin logic here
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }

  @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }
}
