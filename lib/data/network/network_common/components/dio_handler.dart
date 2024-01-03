part of "../network_common.dart";

NWResponse _decodeSuccessResponse(Response<dynamic> d) {
  final jsonBody = d.data;
  final statusCode = d.statusCode!;

  if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
    throw NWResponseFailed.invalidRequestError(statusCode: statusCode);
  }

  if (jsonBody is String) {
    return _DioHandler.handleJsonBodyIsString(jsonBody, statusCode);
  } else if (jsonBody is Map) {
    return _DioHandler.parseJsonData(jsonBody, statusCode: statusCode);
  } else if (jsonBody is List) {
    return NWResponseSuccess(
      statusCode: statusCode,
      data: jsonBody,
      message: "message",
      status: 1,
    );
  } else {
    return d.data;
  }
}

NWResponseFailed _handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.badResponse:
      final jsonBody = e.response?.data;
      final statusCode = e.response?.statusCode;

      if (jsonBody is String) {
        if (jsonBody.isEmpty) {
          throw NWResponseFailed.invalidRequestError(
            statusCode: statusCode!,
            message: 'Response error is not found',
          );
        }

        throw NWResponseFailed.formJson(
          statusCode: statusCode ?? -1,
          json: _decoder.convert(jsonBody) as Map<String, dynamic>,
        );
      } else if (jsonBody is Map<String, dynamic>) {
        throw NWResponseFailed.formJson(
          statusCode: statusCode ?? -1,
          json: jsonBody,
        );
      } else {
        throw NWResponseFailed.decodeError(
          statusCode: statusCode!,
          message: 'Cannot decode data',
          error: 'DECODE_ERROR',
        );
      }
    default:
      throw e;
  }
}

class _DioHandler {
  static NWResponse parseJsonData(Map jsonData, {required int statusCode}) {
    if (jsonData is Map<String, dynamic>) {
      return NWResponseSuccess<Map<String, dynamic>>(
        statusCode: statusCode,
        data: jsonData,
        message:
            jsonData["message"] != null ? jsonData["message"] as String : "",
        status: jsonData["status"] != null ? jsonData["status"] as int : -1,
      );
    } else {
      throw NWResponseFailed.decodeError(
        statusCode: statusCode,
        message: 'Cannot decode data',
        error: 'DECODE_ERROR',
      );
    }
  }

  static NWResponse handleJsonBodyIsString(String jsonBody, int statusCode) {
    if (jsonBody.isEmpty && statusCode == 200) {
      return NWResponseSuccess(
        statusCode: statusCode,
        data: {},
        message: "",
        status: 1,
      );
    }

    final dataDecoder = _decoder.convert(jsonBody);
    if (dataDecoder is List) {
      return NWResponseSuccess(
        statusCode: statusCode,
        data: dataDecoder,
        status: 1,
        message: "",
      );
    } else if (dataDecoder is Map) {
      if (dataDecoder['data'] is Map) {
        return parseJsonData(dataDecoder['data'], statusCode: statusCode);
      } else {
        return parseJsonData(dataDecoder, statusCode: statusCode);
      }
    } else {
      throw NWResponseFailed.decodeError(
        statusCode: statusCode,
        message: 'Cannot decode data',
        error: 'DECODE_ERROR',
      );
    }
  }
}
