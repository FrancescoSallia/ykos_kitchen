import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static var auth = FirebaseAuth.instance;
 

  Future<void> register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // Verwende `rethrow`, damit der ursprüngliche Stacktrace erhalten bleibt
      // und die aufrufende Stelle den FirebaseAuthException weiterverarbeiten kann.
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> resetPasswort(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> reAuth(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await auth.currentUser!.delete();
    } on FirebaseAuthException {
      rethrow;
    }
  }

    Future<void> logOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
