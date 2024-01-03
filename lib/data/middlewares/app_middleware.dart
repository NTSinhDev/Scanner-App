import 'package:dio/dio.dart';
import 'package:wolcg_qr_code/data/middlewares/base_middleware.dart';
import 'package:wolcg_qr_code/data/models/auth.dart';
import 'package:wolcg_qr_code/data/models/event.dart';
import 'package:wolcg_qr_code/data/network/network_response_object.dart';
import 'package:wolcg_qr_code/data/network/network_response_state.dart';
import 'package:wolcg_qr_code/data/network/network_url.dart';

class AppMiddleware extends BaseMiddleware {
  Future<ResponseState> login(String username, String password) async {
    try {
      final response = await dio.post<NWResponse>(
        "",
        data: {
          "username": username.isEmpty ? "it_helpdesk1" : username,
          "password": password.isEmpty ? "123456a@" : password,
          "ip": "171.239.156.210",
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          status: resultData.status,
          message: resultData.message,
          responseData: Auth.fromMap(resultData.data["data"]),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> getEvents() async {
    try {
      final response = await tokenDio.get<NWResponse>(
        NetworkUrl.events,
        queryParameters: {
          "offset": 0,
          "limit": 20,
        },
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        final listData = resultData.data["listData"] as List<dynamic>;
        return ResponseSuccessState<List<Event>>(
          statusCode: response.statusCode ?? -1,
          status: resultData.status,
          message: resultData.message,
          responseData: listData.map((e) => Event.fromMap(e)).toList(),
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }

  Future<ResponseState> checkin({
    required int eventId,
    required String username,
  }) async {
    try {
      final response = await tokenDio.post<NWResponse>(
        NetworkUrl.checkin,
        data: {"eventId": eventId, "username": username},
        cancelToken: cancelToken,
      );

      final resultData = response.data;
      if (resultData is NWResponseSuccess<Map<String, dynamic>>) {
        return ResponseSuccessState(
          statusCode: response.statusCode ?? -1,
          status: resultData.status,
          message: resultData.message,
          responseData: resultData.status == 1,
        );
      }

      if (resultData is NWResponseFailed) {
        return ResponseFailedState.fromNWResponse(resultData);
      }

      return ResponseFailedState.unknownError();
    } on DioException catch (e) {
      return handleResponseFailedState(e);
    }
  }
}
