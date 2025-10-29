import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("fire_auth_tests", () {
    late MockFirebaseAuth auth;

    setUp(() {
      final user = MockUser(uid: "123", email: "test@mail.com");
      auth = MockFirebaseAuth(mockUser: user);
    });

    test("sign in", () async {
      final email = "test@mail.com";
      final password = "123456";
      final logged = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(logged.user?.email, email);
      expect(logged.user?.uid, auth.currentUser?.uid);
    });

    test("registation", () async {
      final email = "test@mail.com";
      final password = "123456";
      final newUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(newUser.user?.uid, auth.currentUser?.uid);
    });

    test("reset password", () async {
      final email = "test@mail.com";
      await auth.sendPasswordResetEmail(email: email);

      // Prüfe, dass kein Fehler geworfen wird
      expect(
        () async => await auth.sendPasswordResetEmail(email: email),
        returnsNormally,
      );
    });
  });
}
