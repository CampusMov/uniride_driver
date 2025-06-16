import 'user_dto.dart';

class AuthVerificationResponseDto {
  final String token;
  final UserDto user;

  AuthVerificationResponseDto({
    required this.token,
    required this.user,
  });

  factory AuthVerificationResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthVerificationResponseDto(
      token: json['token'],
      user: UserDto.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user.toJson(),
      };
}