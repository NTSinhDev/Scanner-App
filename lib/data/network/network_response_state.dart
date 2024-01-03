import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wolcg_qr_code/data/network/network_response_object.dart';

abstract class ResponseState {
  ResponseState({
    required this.statusCode,
    required this.message,
    this.type,
    this.status,
  });
  final int statusCode;
  final int? type;
  final int? status;
  final String message;
}

class ResponseSuccessState<T> extends ResponseState {
  final T responseData;
  ResponseSuccessState({
    required super.statusCode,
    required super.message,
    super.type,
    super.status,
    required this.responseData,
  });

  ResponseSuccessState<T> copyWith({
    required int statusCode,
    required String message,
    required T responseData,
  }) {
    return ResponseSuccessState<T>(
      statusCode: statusCode,
      message: message,
      responseData: responseData ?? this.responseData,
    );
  }
}

class ResponseFailedState<T> extends ResponseState {
  final T error;
  ResponseFailedState({
    required super.statusCode,
    required super.message,
    super.type,
    required this.error,
  });

  factory ResponseFailedState.fromDioError(DioException e) {
    // var dataError = e.error;
    // if (dataError is NWErrorEnum) {
    //   return ResponseFailedState(
    //     statusCode: e.response.statusCode,
    //     errorMessage: dataError.errorMessage,
    //     apiError: dataError,
    //   );
    // } else if (dataError is SocketException) {
    //   var osError = dataError.osError;
    //   if (osError.errorCode == 101 || osError.errorCode == 51) {
    //     return ResponseFailedState(
    //       statusCode: osError.errorCode,
    //       errorMessage: osError.message,
    //     );
    //   }
    // }
    log("$e", name: "ResponseFailedState - fromDioError");
    return ResponseFailedState(
      statusCode: e.response?.statusCode ?? -1,
      message: 'fromDioError - ${e.message}',
      error: e.error as T,
    );
  }

  factory ResponseFailedState.unknownError() {
    return ResponseFailedState(
      statusCode: -1,
      message: 'An error occurred. Please try again.',
      error: "" as T,
    );
  }

  factory ResponseFailedState.fromNWResponse(NWResponseFailed response) {
    return ResponseFailedState(
      statusCode: response.statusCode,
      message: response.message,
      type: response.type,
      error:
          response.error != null ? response.error["details"] : response.message,
    );
  }
}
