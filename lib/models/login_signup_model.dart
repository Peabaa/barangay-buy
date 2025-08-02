class LoginSignupModel {
  final bool isLogin;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? errorMessage;
  final bool isFormValid;

  const LoginSignupModel({
    this.isLogin = true,
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.errorMessage,
    this.isFormValid = false,
  });

  LoginSignupModel copyWith({
    bool? isLogin,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return LoginSignupModel(
      isLogin: isLogin ?? this.isLogin,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLogin': isLogin,
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'isFormValid': isFormValid,
    };
  }

  factory LoginSignupModel.fromMap(Map<String, dynamic> map) {
    return LoginSignupModel(
      isLogin: map['isLogin'] ?? true,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      confirmPassword: map['confirmPassword'] ?? '',
      isLoading: map['isLoading'] ?? false,
      errorMessage: map['errorMessage'],
      isFormValid: map['isFormValid'] ?? false,
    );
  }

  @override
  String toString() {
    return 'LoginSignupModel(isLogin: $isLogin, username: $username, email: $email, password: [HIDDEN], confirmPassword: [HIDDEN], isLoading: $isLoading, errorMessage: $errorMessage, isFormValid: $isFormValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginSignupModel &&
        other.isLogin == isLogin &&
        other.username == username &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isFormValid == isFormValid;
  }

  @override
  int get hashCode {
    return isLogin.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        confirmPassword.hashCode ^
        isLoading.hashCode ^
        errorMessage.hashCode ^
        isFormValid.hashCode;
  }
}
