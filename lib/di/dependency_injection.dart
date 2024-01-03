import 'package:get_it/get_it.dart';
import 'package:wolcg_qr_code/bloc/app/app_cubit.dart';
import 'package:wolcg_qr_code/bloc/checkin/checkin_cubit.dart';
import 'package:wolcg_qr_code/data/middlewares/app_middleware.dart';
import 'package:wolcg_qr_code/data/network/network_common/network_common.dart';
import 'package:wolcg_qr_code/data/repositories/auth_repository.dart';

final di = GetIt.I;

void setupDependencyInjection() {
  di
    // Middlewares
    ..registerFactory<AppMiddleware>(AppMiddleware.new)

    // Cubits
     ..registerFactory<CheckInCubit>(CheckInCubit.new)

    // Singletons
    ..registerLazySingleton<AppCubit>(AppCubit.new)
    ..registerLazySingleton<NetworkCommon>(NetworkCommon.new)

    // Repositories
    ..registerLazySingleton<AuthRepository>(AuthRepository.new);
}
