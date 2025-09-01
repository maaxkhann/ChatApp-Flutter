class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException(super.message);
}

/// Firestore related exceptions
class FirestoreException extends AppException {
  FirestoreException(super.message);
}

class StorageException extends AppException {
  StorageException(super.message);
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Unexpected fallback exception
class UnknownException extends AppException {
  final Object? originalException;
  UnknownException([
    super.message = "Something went wrong",
    this.originalException,
  ]);
}
