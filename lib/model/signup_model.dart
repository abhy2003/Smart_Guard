class SignUpModel {
  String username;
  String email;
  String password;

  SignUpModel({required this.username, required this.email, required this.password});

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
  );

  String? usernameError;
  String? emailError;
  String? passwordError;

  void validateUserName() {
    usernameError = username.isEmpty ? 'Please enter your UserName' : null;
  }

  void validateEmail() {
    if (email.isEmpty) {
      emailError = 'Please enter an email';
    } else if (!_emailRegex.hasMatch(email)) {
      emailError = 'Please enter a valid email';
    } else {
      emailError = null;
    }
  }

  void validatePassword() {
    if (password.isEmpty) {
      passwordError = 'Please enter a password';
    } else if (!_passwordRegex.hasMatch(password)) {
      passwordError = 'Password must be at least 8 characters, contain one uppercase letter, one special character, and one number';
    } else {
      passwordError = null;
    }
  }

  bool get isValid => usernameError == null && emailError == null && passwordError == null;
}