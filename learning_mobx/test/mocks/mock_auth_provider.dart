import 'package:learning_mobx/provider/auth_provider.dart';

import '../utils.dart';

class MockAuthProvider implements AuthProvider {
  @override
  Future<bool> deleteAccountsAndSignOut()=> true.toFuture(oneSecond);
  @override
  Future<bool> login({required String email, required String password}) => true.toFuture(oneSecond);

  @override
  Future<bool> register({required String email, required String password}) => true.toFuture(oneSecond);

  @override
  Future<void> signOut() => Future.delayed(oneSecond);

  @override
  String? get userId => 'foobar';

}