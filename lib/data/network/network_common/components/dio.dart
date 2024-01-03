part of "../network_common.dart";

class _Dio {
  static Dio get authenticated {
    final dio = Dio();

    //Set default configs
    dio.options.baseUrl = NetworkUrl.baseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 180000);
    dio.options.receiveTimeout = const Duration(milliseconds: 180000);
    dio.options.headers["Connection"] = "Keep-Alive";

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handle) async {
          // final String currentTimeZone =
          //     await UtilsNativeChannel().getCityTimeZone();
          final auth = di<AuthRepository>().currentAuth;
          final accessToken = auth?.getToken ?? '';
          if (accessToken.isEmpty) {
            return handle.reject(DioException(requestOptions: options));
          }

          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          return handle.next(options);
        },
        onResponse: (response, handle) async {
          response.data = _decodeSuccessResponse(response);
          return handle.next(response);
        },
        onError: (e, handle) async {
          if (e.response?.statusCode == 401) {
            di<AppCubit>().logout();
            return;
          }

          if (CancelToken.isCancel(e)) return handle.next(e);
          // handleDioError(e);
          handle.next(e);
        },
      ),
    );

    return dio;
  }

  static Dio get notAuthenticate {
    final dio = Dio();

    // Set default configs
    dio.options.baseUrl = FlavorConfig.instance.env.notAuthURL;
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          // if (e.response?.statusCode == 502) {
          //   AppWireFrame.errorServer();
          //   _handleDioError(e);
          //   return handler.next(e);
          // }

          if (CancelToken.isCancel(e)) {
            handler.next(e);
          } else {
            _handleDioError(e);
          }
        },
        onResponse: (response, handle) async {
          response.data = _decodeSuccessResponse(response);
          return handle.next(response);
        },
      ),
    );

    return dio;
  }

  // static Dio get system {
  //   final dio = Dio();

  //   // Set default configs
  //   dio.options.baseUrl = NetworkUrl.systemBaseURL;
  //   dio.options.connectTimeout = const Duration(milliseconds: 10000);
  //   dio.options.receiveTimeout = const Duration(milliseconds: 10000);
  //   dio.interceptors.add(
  //     PrettyDioLogger(
  //       requestHeader: true,
  //       requestBody: true,
  //       logPrint: (obj) => logger.d(obj),
  //     ),
  //   );

  //   dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handle) async {
  //         final auth = di<AuthRepository>().currentAuth;
  //         final accessToken = auth?.getToken ?? '';
  //         if (accessToken.isEmpty) {
  //           return handle.next(options);
  //         }

  //         final headers = options.headers
  //           ..update(
  //             'Authorization',
  //             (_) => accessToken,
  //             ifAbsent: () => accessToken,
  //           );
  //         options.headers = headers;
  //         return handle.next(options); //continue
  //       },
  //       onResponse: (response, handle) async {
  //         response.data = _decodeSuccessResponse(response);
  //         return handle.next(response);
  //       },
  //       onError: (e, handle) async {
  //         if (e.response?.statusCode == HttpStatus.badGateway) {
  //           AppWireFrame.errorServer();
  //           _handleDioError(e);
  //           return handle.next(e);
  //         }

  //         if (e.response?.statusCode == HttpStatus.unauthorized) {
  //           AppWireFrame.logout();
  //           // _handleDioError(e);
  //           // return handle.next(e);
  //           return;
  //         }

  //         if (CancelToken.isCancel(e)) return handle.next(e);
  //         handle.next(e);
  //       },
  //     ),
  //   );

  //   return dio;
  // }
}
