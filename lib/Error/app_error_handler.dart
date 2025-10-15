import 'package:firebase_auth/firebase_auth.dart';
import 'package:ykos_kitchen/Error/app_error_type_enum.dart';

class AppErrorHandler {
  // Mappt Exception zu AppErrorType
  static AppErrorType mapExceptionToErrorType(Exception e) {
    if (e is FirebaseAuthException) {
      return AppErrorType.firebaseAuth;
    } else if (e is FirebaseException) {
      return AppErrorType.server;
    } else {
      return AppErrorType.unknown;
    }
  }

  // Gibt die passende Fehlernachricht zurück
  static String getErrorMessage({
    required AppErrorType errorType,
    Exception? exception,
    String? customMessage,
  }) {
    switch (errorType) {
      case AppErrorType.network:
        return "Keine Internetverbindung.";
      case AppErrorType.server:
        return "Serverfehler. Bitte versuche es erneut.";
      case AppErrorType.firebaseAuth:
        if (exception is FirebaseAuthException) {
          // Hier geben wir den Firebase-Message oder einen freundlicheren Text zurück
          switch (exception.code) {
            case 'email-already-in-use':
              return "Dieses Konto existiert bereits.";
            case 'user-not-found':
              return "Benutzer nicht gefunden.";
            case 'wrong-password':
              return "Falsches Passwort.";
            case 'credential-already-in-use':
              return "Die übergebenen Anmeldedaten sind ungültig oder abgelaufen. Bitte erneut versuchen.";
            case 'invalid-email':
              return "Die E-Mail-Adresse ist ungültig.";
            case 'weak-password':
              return "Das Passwort ist zu schwach.";
            default:
              return exception.message ?? "Authentifizierungsfehler.";
          }
        }
        return customMessage ?? "Authentifizierungsfehler.";
      case AppErrorType.unknown:
        return "Ein unbekannter Fehler ist aufgetreten.";
      case AppErrorType.custom:
        return customMessage ?? "Ein Fehler ist aufgetreten.";
      case AppErrorType.firebaseFirestore:
        if (exception is FirebaseException) {
          switch (exception.code) {
            case "INVALID_ARGUMENT":
              return "Client specified an invalid argument.";
            case "UNAUTHENTICATED":
              return "The request does not have valid authentication credentials for the operation.";
            case "UNKNOWN":
              return "Unknown error or an error from a different error domain.";
            case "OUT_OF_RANGE":
              return "Operation was attempted past the valid range.";
            default:
              return "FireExeption Error unknown";
          }
        }
        return "Unknown error.";
    }
  }

  // Hilfsmethode, um direkt aus einer Exception eine Nachricht zu bekommen
  static String getMessageFromException(Exception e, {String? customMessage}) {
    final type = mapExceptionToErrorType(e);
    return getErrorMessage(
      errorType: type,
      exception: e,
      customMessage: customMessage,
    );
  }
}
