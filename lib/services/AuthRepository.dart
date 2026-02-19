import 'package:gathering/services/local_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository{
  final supabase = Supabase.instance.client;

  Future<Map> loginWithEmail(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final userId = res.user!.id;
    return await _getUserAndSave(userId);
  }

  Future<Map> signUpWithEmail(
      String name, String email, String password) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user!;
    DateTime now = DateTime.now();

    await supabase.from('users').insert({
      'id': user.id,
      'name': name,
      'email': user.email,
      'provider': 'email',
      'created_at': now.toString(),

    });

    return await _getUserAndSave(user.id);
  }





  Future<Map> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception("Cancelled");

    final googleAuth = await googleUser.authentication;

    final res = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );

    final user = res.user!;

    final existing = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing == null) {
      await supabase.from('users').insert({
        'id': user.id,
        'email': user.email,
        'name': user.userMetadata?['name'],
        'provider': 'google',
      });
    }

    return await _getUserAndSave(user.id);
  }

  Future<Map> _getUserAndSave(String userId) async {
    final user = await supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    await LocalStorageService.saveUserData(
      userId: user['id'],
      email: user['email'],
      name: user['name'] ?? '',
      photoUrl: user['photo_url'] ?? '',
      interest: user['interest'] ?? '',
      city: user['city'] ?? '',
    );
    return user;
  }
  Future<void> logout() async {
    await supabase.auth.signOut();
    await LocalStorageService.clearUserData();
  }

}
