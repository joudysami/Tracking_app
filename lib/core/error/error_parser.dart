import 'package:dio/dio.dart';
import 'package:tracking_app/core/error/api_exception.dart';
import 'package:tracking_app/core/error/app_error.dart';

AppError errorParser(Exception exception) {
  if (exception is ApiException) return _parseApiException(exception);
  if (exception is! DioException) return IgnoreError();
  if (exception.error is ForceLogin) return ForceLogin();
  return _parseDioException(exception);
}

AppError _parseApiException(ApiException exception) {
  final fieldErrors = fieldErrorsMessage(exception.errors);
  if (fieldErrors != null) return BadResponseError(fieldErrors);
  return BadResponseError(exception.message);
}

AppError _parseDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => TimeOutError(exception),
    DioExceptionType.badCertificate => BadCertificateError(
      exception,
      'Invalid certificate, please try again later.',
    ),
    DioExceptionType.badResponse => _parseBadResponse(exception),
    DioExceptionType.connectionError => _connectionError(exception),
    DioExceptionType.cancel ||
    DioExceptionType.unknown ||
    DioExceptionType.transformTimeout => IgnoreError(),
  };
}

AppError _connectionError(DioException exception) {
  final detail = '${exception.message} ${exception.error}';
  if (detail.contains('Connection refused') ||
      detail.contains('Failed host lookup') ||
      detail.contains('Network is unreachable') ||
      detail.contains('Connection reset')) {
    return BadResponseError(
      'Cannot reach the server. Check your connection and try again.',
    );
  }
  return NoInternetError(exception);
}

AppError _parseBadResponse(DioException exception) {
  final data = exception.response?.data;
  if (data is Map) {
    final message = _bodyMessage(Map<String, dynamic>.from(data));
    if (message != null) return BadResponseError(message);
  }
  if (exception.response?.statusCode == 401) return UnauthorizedError();
  return BadResponseError(statusCodeToMessage(exception.response?.statusCode));
}

String? _bodyMessage(Map<String, dynamic> data) {
  return errorsMessage(data['errors']) ??
      fieldErrorsMessage(_validationFieldErrors(data['data'])) ??
      _text(data['message']) ??
      _text(data['error']);
}

String? errorsMessage(dynamic errors) {
  if (errors is Map) {
    return fieldErrorsMessage(Map<String, dynamic>.from(errors));
  }
  if (errors is! List) return null;
  final messages = errors.map(_errorItem).whereType<String>().toSet();
  if (messages.isEmpty) return null;
  return messages.join('\n');
}

String? _errorItem(dynamic item) {
  if (item is String && item.isNotEmpty) return item;
  if (item is Map && item['message'] != null) return item['message'].toString();
  return null;
}

String? _text(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return text;
}

/// Docker identity validation failures put field errors in `data`
/// (e.g. Email / PhoneNumber), not in `errors`.
Map<String, dynamic>? _validationFieldErrors(dynamic raw) {
  if (raw is! Map) return null;
  if (raw.containsKey('userId') ||
      raw.containsKey('accessToken') ||
      raw.containsKey('refreshToken')) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  if (map.isEmpty) return null;
  final looksLikeFieldErrors = map.values.every(
    (value) => value is List || value is String,
  );
  return looksLikeFieldErrors ? map : null;
}

String? fieldErrorsMessage(Map<String, dynamic>? errors) {
  if (errors == null) return null;
  final messages = <String>[];
  for (final value in errors.values) {
    if (value is List) {
      messages.addAll(value.map((e) => e.toString()));
    } else if (value != null) {
      messages.add(value.toString());
    }
  }
  if (messages.isEmpty) return null;
  return messages.join('\n');
}

const Map<int, String> statusMessages = {
  400: 'Something went wrong, please try again.',
  401: 'Unauthorized, please login again.',
  403: 'You are not allowed to perform this action.',
  404: 'Resource not found.',
  409: 'Conflict occurred.',
  422: 'Validation failed.',
  429: 'Too many requests, please try again later.',
  500: 'Internal server error, please try again later.',
  502: 'Bad gateway.',
  503: 'Service unavailable.',
  504: 'Gateway timeout.',
};

String statusCodeToMessage(int? statusCode) {
  return statusMessages[statusCode] ??
      'Something went wrong, please try again.';
}
