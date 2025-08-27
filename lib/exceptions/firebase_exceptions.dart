// lib/exceptions/auth_exception_handler.dart
import 'dart:io';

import 'package:chat_app/exceptions/app_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

AuthException handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return AuthException('The email address is not valid.');
    case 'user-disabled':
      return AuthException(
          'This user account has been disabled. Please contact support.');
    case 'user-not-found':
      return AuthException('No user found for that email.');
    case 'wrong-password':
      return AuthException('Wrong password provided. Please try again.');
    case 'email-already-in-use':
      return AuthException('An account already exists with that email.');
    case 'operation-not-allowed':
      return AuthException(
          'Email/password sign-in is not enabled. Please contact support.');
    case 'weak-password':
      return AuthException('The password is too weak.');
    case 'too-many-requests':
      return AuthException('Too many attempts. Please try again later.');
    case 'account-exists-with-different-credential':
      return AuthException(
          'This email is already linked with a different sign-in method.');
    case 'invalid-credential':
      return AuthException('The credential is invalid or has expired.');
    case 'expired-action-code':
    case 'invalid-action-code':
      return AuthException('This action code is invalid or has expired.');
    case 'invalid-verification-id':
    case 'invalid-verification-code':
      return AuthException('The verification code is invalid. Please retry.');
    case 'network-request-failed':
      return AuthException('Network error—please check your connection.');
    default:
      return AuthException('Authentication failed. Please try again.');
  }
}

FirestoreException handleFirestoreException(FirebaseException e) {
  switch (e.code) {
    case 'permission-denied':
      return FirestoreException(
          'You don’t have permission to perform this action.');
    case 'unavailable':
      return FirestoreException(
          'Firestore service is temporarily unavailable. Try again later.');
    case 'not-found':
      return FirestoreException('Requested document was not found.');
    case 'already-exists':
      return FirestoreException('This document already exists.');
    case 'cancelled':
      return FirestoreException('The operation was cancelled.');
    case 'deadline-exceeded':
      return FirestoreException('The operation timed out.');
    case 'resource-exhausted':
      return FirestoreException('Resource limit exceeded.');
    case 'unauthenticated':
      return FirestoreException(
          'You must be signed in to perform this action.');
    default:
      return FirestoreException('Unexpected Firestore error occurred.');
  }
}

StorageException handleStorageException(FirebaseException e) {
  switch (e.code) {
    case 'object-not-found':
      return StorageException('File does not exist.');
    case 'bucket-not-found':
      return StorageException('Storage bucket not found.');
    case 'project-not-found':
      return StorageException('Storage project not found.');
    case 'quota-exceeded':
      return StorageException('Storage quota exceeded. Try later.');
    case 'unauthenticated':
      return StorageException(
          'You must be logged in to upload or download files.');
    case 'unauthorized':
      return StorageException('You don’t have permission to access this file.');
    case 'cancelled':
      return StorageException('Upload or download was cancelled.');
    case 'retry-limit-exceeded':
      return StorageException(
          'Too many retry attempts. Please try again later.');
    default:
      return StorageException('Unexpected storage error occurred.');
  }
}

NetworkException handleNetworkException(Object e) {
  if (e is SocketException) {
    return NetworkException(
        'No Internet connection. Please check your network.');
  } else if (e is HttpException) {
    return NetworkException('Could not complete the request. Server error.');
  } else if (e is FormatException) {
    return NetworkException('Bad response format.');
  }
  return NetworkException('Unexpected network error occurred.');
}
