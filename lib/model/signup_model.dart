class SignUpModel {
  late final String lockId;
  late final String email;
  late final String password;

  SignUpModel({required this.lockId, required this.email, required this.password});

  // Regular expression for email validation
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Regular expression for password validation:
  // At least 8 characters, at least one uppercase letter, one special character, and one number
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

  String? validateEmail() {
    if (email.isEmpty) {
      return 'Please enter an email';
    } else if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword() {
    if (password.isEmpty) {
      return 'Please enter a password';
    } else if (!_passwordRegex.hasMatch(password)) {
      return 'Password must be at least 8 characters, contain one uppercase letter, one special character, and one number';
    }
    return null;
  }

  String? validateLockId() {
    if (lockId.isEmpty) {
      return 'Please enter your lock ID';
    }
    return null;
  }
}
