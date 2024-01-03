import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:wolcg_qr_code/app/app_flavor_config.dart';
import 'package:wolcg_qr_code/bloc/app/app_cubit.dart';
import 'package:wolcg_qr_code/data/network/network_response_object.dart';
import 'package:wolcg_qr_code/data/network/network_url.dart';
import 'package:wolcg_qr_code/data/repositories/auth_repository.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';
import 'package:wolcg_qr_code/utils/pretty_dio_logger.dart';
part 'components/dio.dart';
part 'components/dio_handler.dart';

const _decoder = JsonDecoder();

class NetworkCommon {
  Dio get dio => _Dio.notAuthenticate;
  Dio get tokenDio => _Dio.authenticated;
}
