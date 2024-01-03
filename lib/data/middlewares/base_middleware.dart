
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:wolcg_qr_code/data/network/network_common/network_common.dart';
import 'package:wolcg_qr_code/data/network/network_response_object.dart';
import 'package:wolcg_qr_code/data/network/network_response_state.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';

abstract class BaseMiddleware {

  final CancelToken cancelToken = CancelToken();
  Dio get dio => di<NetworkCommon>().dio;
  Dio get tokenDio => di<NetworkCommon>().tokenDio;

  void close() {
    cancelToken.cancel();
    log('${toString()} closed');
  }

  ResponseFailedState handleResponseFailedState(DioException e) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        return ResponseFailedState.fromNWResponse(
          NWResponseFailed.formJson(
            statusCode: e.response?.statusCode ?? -1,
            json: e.response?.data ?? {},
          ),
        );
      case DioExceptionType.unknown:
        if (e.error is NWResponseFailed) {
          return ResponseFailedState.fromNWResponse(
            e.error as NWResponseFailed,
          );
        } else {
          return ResponseFailedState.fromDioError(e);
        }
      default:
        return ResponseFailedState.fromDioError(e);
    }
  }
}
