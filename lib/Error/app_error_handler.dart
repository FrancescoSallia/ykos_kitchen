import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ykos_kitchen/Error/app_error_type_enum.dart';

class AppErrorHandler {
  // 1️⃣ Exception zu ErrorType mappen
  static AppErrorType mapExceptionToErrorType(Exception e) {
    if (e is FirebaseAuthException) {
      return AppErrorType.firebaseAuth;
    } else if (e is FirebaseException) {
      return AppErrorType.firebaseFirestore;
    } else if (e is SocketException) {
      return AppErrorType.network;
    } else if (e is TimeoutException) {
      return AppErrorType.network;
    } else {
      return AppErrorType.unknown;
    }
  }

  // 2️⃣ Benutzerfreundliche Fehlermeldung liefern
  static String getErrorMessage({
    required AppErrorType errorType,
    Exception? exception,
    String? customMessage,
  }) {
    switch (errorType) {
      case AppErrorType.network:
        return "Keine Internetverbindung oder Zeitüberschreitung. Bitte überprüfe deine Verbindung.";

      case AppErrorType.server:
        return "Serverfehler. Bitte versuche es in Kürze erneut.";

      case AppErrorType.firebaseAuth:
        if (exception is FirebaseAuthException) {
          switch (exception.code) {
            case 'email-already-in-use':
              return "Diese E-Mail-Adresse wird bereits verwendet.";
            case 'user-not-found':
              return "Kein Benutzer mit dieser E-Mail gefunden.";
            case 'wrong-password':
              return "Das Passwort ist nicht korrekt.";
            case 'invalid-email':
              return "Bitte eine gültige E-Mail-Adresse eingeben.";
            case 'weak-password':
              return "Das Passwort ist zu schwach.";
            case 'too-many-requests':
              return "Zu viele Anmeldeversuche. Bitte später erneut versuchen.";
            default:
              return exception.message ??
                  "Ein Authentifizierungsfehler ist aufgetreten.";
          }
        }
        return "Ein Anmeldefehler ist aufgetreten.";

      case AppErrorType.firebaseFirestore:
        if (exception is FirebaseException) {
          switch (exception.code) {
            case 'permission-denied':
              return "Du hast keine Berechtigung für diese Aktion.";
            case 'not-found':
              return "Das angeforderte Dokument existiert nicht.";
            case 'unavailable':
              return "Der Firestore-Dienst ist momentan nicht erreichbar.";
            case 'aborted':
              return "Die Anfrage wurde abgebrochen. Bitte erneut versuchen.";
            case 'deadline-exceeded':
              return "Der Server hat zu lange gebraucht, um zu antworten.";
            default:
              return "Ein Datenbankfehler ist aufgetreten.";
          }
        }
        return "Ein unbekannter Datenbankfehler ist aufgetreten.";

      case AppErrorType.custom:
        return customMessage ?? "Ein Fehler ist aufgetreten.";

      case AppErrorType.unknown:
        return customMessage ??
            "Ein unerwarteter Fehler ist aufgetreten. Bitte versuche es erneut.";
    }
  }

  // 3️⃣ Kurzform: Direkt Exception → Nachricht
  static String getMessageFromException(Exception e, {String? customMessage}) {
    final type = mapExceptionToErrorType(e);
    return getErrorMessage(
      errorType: type,
      exception: e,
      customMessage: customMessage,
    );
  }
}
