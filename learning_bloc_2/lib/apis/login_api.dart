import 'package:flutter/foundation.dart';
import 'package:learning_bloc_2/models.dart';

@immutable
abstract class LoginApiProtocol{
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol{
  @override
  Future<LoginHandle?> login({required String email, required String password})=>
    Future.delayed(
      const Duration(seconds: 2),
      ()=> email == 'foo@bar.com' && password == 'foobar')
          .then((isLoggedIn)=>isLoggedIn?const LoginHandle.foobar():null);
}