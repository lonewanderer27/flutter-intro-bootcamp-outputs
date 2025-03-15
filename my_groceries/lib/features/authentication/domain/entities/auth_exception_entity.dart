abstract class AuthException implements Exception {
  final String? message;

  const AuthException([this.message]);
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException([String? message])
      : super(message ?? 'Email address is not valid.');
}

class UserDisabledException extends AuthException {
  const UserDisabledException([String? message])
      : super(message ?? 'This account has been disabled.');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException([String? message])
      : super(message ?? 'No account found with this email.');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException([String? message])
      : super(message ?? 'Incorrect password. Please try again.');
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException([String? message])
      : super(message ?? 'Too many attempts. Please try again later.');
}

class UserTokenExpiredException extends AuthException {
  const UserTokenExpiredException([String? message])
      : super(message ?? 'Your session has expired. Please sign in again.');
}

class NetworkRequestFailedException extends AuthException {
  const NetworkRequestFailedException([String? message])
      : super(
            message ?? 'Network error. Please check your internet connection.');
}

class InvalidLoginCredentialsException extends AuthException {
  const InvalidLoginCredentialsException([String? message])
      : super(message ?? 'Invalid email or password. Please try again.');
}

class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException([String? message])
      : super(message ?? 'This operation is not allowed.');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([String? message])
      : super(message ?? 'An account already exists with this email.');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException([String? message])
      : super(message ??
            'Password is too weak. Please choose a stronger password.');
}

class RequiresRecentLoginException extends AuthException {
  const RequiresRecentLoginException([String? message])
      : super(message ??
            'This operation requires recent authentication. Please sign in again.');
}

class AccountExistsWithDifferentCredentialException extends AuthException {
  const AccountExistsWithDifferentCredentialException([String? message])
      : super(message ??
            'An account already exists with the same email but different sign-in credentials.');
}

class InvalidActionCodeException extends AuthException {
  const InvalidActionCodeException([String? message])
      : super(message ?? 'The action code is invalid or expired.');
}

class CaptchaCheckFailedException extends AuthException {
  const CaptchaCheckFailedException([String? message])
      : super(message ?? 'The reCAPTCHA verification failed.');
}

class UserMismatchException extends AuthException {
  const UserMismatchException([String? message])
      : super(message ?? 'The provided credential does not match the user.');
}

class InvalidPersistenceException extends AuthException {
  const InvalidPersistenceException([String? message])
      : super(message ?? 'The specified persistence type is invalid.');
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException([String? message])
      : super(message ?? 'An unknown authentication error occurred.');
}
