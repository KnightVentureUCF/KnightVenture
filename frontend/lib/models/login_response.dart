class LoginResponse {
  final String accessToken;
  final String idToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  // Constructor
  LoginResponse({
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  // Factory method to create a LoginResponse from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['AccessToken'],
      idToken: json['IdToken'],
      refreshToken: json['RefreshToken'],
      expiresIn: json['ExpiresIn'],
      tokenType: json['TokenType'],
    );
  }

  // Convert the class instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'tokenType': tokenType,
    };
  }
}
