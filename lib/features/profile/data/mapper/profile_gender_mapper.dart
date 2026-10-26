import 'package:tracking_app/features/auth/domain/entities/gender.dart';

Gender? genderFromApi(String? raw) {
  return switch (raw?.trim().toLowerCase()) {
    'male' || '0' => Gender.male,
    'female' || '1' => Gender.female,
    _ => null,
  };
}

String genderToApi(Gender gender) => gender.apiValue.toString();
