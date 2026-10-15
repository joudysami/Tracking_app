import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login/login_response.dart';

import '../../../core/constant/api_endpoints.dart';
import '../data/models/forget_password/forget_password_request_dto.dart';
import '../data/models/forget_password/forget_password_response_dto.dart';
import '../data/models/forget_password/reset_password_request_dto.dart';
import '../data/models/forget_password/verify_otp_request_dto.dart';
import '../data/models/forget_password/verify_otp_response_dto.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;
  
 @POST(ApiEndpoints.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(ApiEndpoints.forgetPassword)
  Future<ForgetPasswordResponseDto> forgetPassword(
    @Body() ForgetPasswordRequestDto body,
  );

  @POST(ApiEndpoints.verifyOtp)
  Future<VerifyOtpResponseDto> verifyOtp(@Body() VerifyOtpRequestDto body);

  @POST(ApiEndpoints.resetPassword)
  Future<ForgetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto body,
  );
}
