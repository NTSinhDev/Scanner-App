import 'package:equatable/equatable.dart';
import 'package:wolcg_qr_code/bloc/base_cubit.dart';
import 'package:wolcg_qr_code/data/middlewares/app_middleware.dart';
import 'package:wolcg_qr_code/data/models/auth.dart';
import 'package:wolcg_qr_code/data/network/network_response_state.dart';
import 'package:wolcg_qr_code/data/repositories/auth_repository.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';

part 'app_state.dart';

class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(AppInitialState());

  final AppMiddleware _appMiddleware = di<AppMiddleware>();
  final AuthRepository _authRepository = di<AuthRepository>();

  Future login({required String username, required String password}) async {
    emit(WaitingState());
    final authResult = await _appMiddleware.login(username, password);
    if (authResult is ResponseSuccessState<Auth>) {
      _authRepository.currentAuth = authResult.responseData;
      emit(LoggedInState());
    } else if (authResult is ResponseFailedState) {
      emit(LoginFailedState());
    }
  }

  logout() {
    emit(LoginFailedState());
  }
}
