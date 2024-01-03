// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class NWResponse {
  final int statusCode;
  final int status;
  final String message;
  final int? type;

  NWResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.type,
  });
}

class NWResponseSuccess<T> extends NWResponse {
  NWResponseSuccess({
    required super.statusCode,
    required super.status,
    required super.message,
    required this.data,
  });

  final T data;
}

class NWResponseFailed extends NWResponse implements Exception {
  final dynamic error;
  NWResponseFailed({
    required super.statusCode,
    required super.status,
    required super.message,
    super.type,
    required this.error,
  });

  factory NWResponseFailed.formJson({
    required int statusCode,
    required Map<String, dynamic> json,
  }) {
    return NWResponseFailed(
      statusCode: statusCode,
      status: json["status"]!= null? json["status"] as int: 0,
      message: json["message"] as String,
      type: json['type'] != null ? json['type'] as int : null,
      error: json["error"],
    );
  }

  factory NWResponseFailed.decodeError({
    required int statusCode,
    required String message,
    required dynamic error,
  }) {
    return NWResponseFailed(
      statusCode: statusCode,
      status: 0,
      message: message,
      error: error,
    );
  }

  factory NWResponseFailed.invalidRequestError({
    required int statusCode,
    String message = 'Invalid request',
  }) {
    return NWResponseFailed(
      statusCode: statusCode,
      status: 0,
      message: message,
      error: 'INVALID_REQUEST_ERROR',
    );
  }
}
