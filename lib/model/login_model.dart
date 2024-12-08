class LoginModel {
  String? email;
  String? password;

  LoginModel({this.email, this.password});

  // Validate email
  String? validateEmail(String? value) {
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters, contain one uppercase letter, one special character, and one number';
    }
    return null;
  }
}
