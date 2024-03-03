import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  static Future<void> authenticate(Map<String, String> metadata, String uri) async {
    if (FirebaseAuth.instance.currentUser != null) {
      metadata['authorization'] = (await FirebaseAuth.instance.currentUser!.getIdToken())!;
    }
  }
}