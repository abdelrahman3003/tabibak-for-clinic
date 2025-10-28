import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';

class ErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is AuthException) {
      return _handleSupabaseAuthError(error);
    }

    return ApiErrorModel(message: "An unknown error occurred");
  }

  static ApiErrorModel _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return ApiErrorModel(message: "Failed to connect to the server");
      case DioExceptionType.cancel:
        return ApiErrorModel(message: "Request to server was cancelled");
      case DioExceptionType.connectionTimeout:
        return ApiErrorModel(message: "Connection timed out");
      case DioExceptionType.receiveTimeout:
        return ApiErrorModel(
            message: "Receive timeout in connection with server");
      case DioExceptionType.sendTimeout:
        return ApiErrorModel(message: "Send timeout in connection with server");
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response?.data);
      case DioExceptionType.unknown:
      default:
        return ApiErrorModel(message: "Something went wrong");
    }
  }

  static ApiErrorModel _handleSupabaseAuthError(AuthException error) {
    final message = error.message;

    if (message.startsWith('Email address') && message.contains('is invalid')) {
      return ApiErrorModel(message: "Invalid email address");
    }

    switch (message) {
      case "validation_failed":
        return ApiErrorModel(message: "Validation failed");
      case "missing email or phone":
        return ApiErrorModel(message: "Email or phone is required");
      case "Invalid login credentials":
        return ApiErrorModel(message: "Invalid login credentials");
      case "Signup requires a valid password":
        return ApiErrorModel(message: "Password is not valid");
      case "User already registered":
        return ApiErrorModel(message: "User is already registered");
      case "Anonymous sign-ins are disabled":
        return ApiErrorModel(message: "Anonymous sign-in is disabled");
      case "Unable to validate email address: invalid format":
        return ApiErrorModel(message: "Invalid email format");
      case "otp_expired":
        return ApiErrorModel(message: "OTP has expired");
      default:
        return ApiErrorModel(message: message);
    }
  }

  static ApiErrorModel _handleBadResponse(dynamic data) {
    return ApiErrorModel(
      message: data?['message'] ?? "Unknown error occurred",
      code: data?['code'],
      errors: data?['data'],
    );
  }
}
