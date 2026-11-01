import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final bool invalidCurrentPassword;

  const ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.invalidCurrentPassword = false,
  });

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    bool? invalidCurrentPassword,
  }) {
    return _copied(
      this,
      currentPassword,
      newPassword,
      confirmPassword,
      isLoading,
      invalidCurrentPassword,
    );
  }

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    isLoading,
    invalidCurrentPassword,
  ];
}

ChangePasswordState _copied(
  ChangePasswordState state,
  String? currentPassword,
  String? newPassword,
  String? confirmPassword,
  bool? isLoading,
  bool? invalidCurrentPassword,
) {
  return ChangePasswordState(
    currentPassword: currentPassword ?? state.currentPassword,
    newPassword: newPassword ?? state.newPassword,
    confirmPassword: confirmPassword ?? state.confirmPassword,
    isLoading: isLoading ?? state.isLoading,
    invalidCurrentPassword:
        invalidCurrentPassword ?? state.invalidCurrentPassword,
  );
}
