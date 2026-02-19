
import 'package:gathering/services/AuthRepository.dart';
import 'package:gathering/services/local_storage_service.dart';

class AuthService {
  final _repo = AuthRepository();

  Future<Map> login(String email, String password) {
    return _repo.loginWithEmail(email, password);
  }

  Future<Map> signup(String name, String email, String password) {
    return _repo.signUpWithEmail(name, email, password);
  }

  Future<Map> googleLogin() {
    return _repo.loginWithGoogle();
  }

  Future<void> logout() {
    return _repo.logout();
  }

  Future<Map<String, dynamic>?> getLocalUser() {
    return LocalStorageService.getUserData();
  }

  Future<bool> isLoggedIn() {
    return LocalStorageService.isLoggedIn();
  }
}