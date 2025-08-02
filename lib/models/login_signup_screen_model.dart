class LoginSignupScreenModel {
  final bool isLoading;
  final String? errorMessage;
  final bool isSignupSelected;
  final bool isLoginSelected;

  const LoginSignupScreenModel({
    this.isLoading = false,
    this.errorMessage,
    this.isSignupSelected = false,
    this.isLoginSelected = false,
  });

  LoginSignupScreenModel copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSignupSelected,
    bool? isLoginSelected,
  }) {
    return LoginSignupScreenModel(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSignupSelected: isSignupSelected ?? this.isSignupSelected,
      isLoginSelected: isLoginSelected ?? this.isLoginSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'isSignupSelected': isSignupSelected,
      'isLoginSelected': isLoginSelected,
    };
  }

  factory LoginSignupScreenModel.fromMap(Map<String, dynamic> map) {
    return LoginSignupScreenModel(
      isLoading: map['isLoading'] ?? false,
      errorMessage: map['errorMessage'],
      isSignupSelected: map['isSignupSelected'] ?? false,
      isLoginSelected: map['isLoginSelected'] ?? false,
    );
  }

  @override
  String toString() {
    return 'LoginSignupScreenModel(isLoading: $isLoading, errorMessage: $errorMessage, isSignupSelected: $isSignupSelected, isLoginSelected: $isLoginSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginSignupScreenModel &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isSignupSelected == isSignupSelected &&
        other.isLoginSelected == isLoginSelected;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        errorMessage.hashCode ^
        isSignupSelected.hashCode ^
        isLoginSelected.hashCode;
  }
}
