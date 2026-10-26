class LogoutRequestDto {
  final String refreshToken;

  const LogoutRequestDto(this.refreshToken);

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}
