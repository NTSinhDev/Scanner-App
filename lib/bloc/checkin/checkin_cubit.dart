import 'package:equatable/equatable.dart';
import 'package:wolcg_qr_code/bloc/base_cubit.dart';
import 'package:wolcg_qr_code/data/middlewares/app_middleware.dart';
import 'package:wolcg_qr_code/data/models/event.dart';
import 'package:wolcg_qr_code/data/network/network_response_state.dart';
import 'package:wolcg_qr_code/data/repositories/auth_repository.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';

part 'checkin_state.dart';

class CheckInCubit extends BaseCubit<CheckInState> {
  CheckInCubit() : super(InitialState());

  final AppMiddleware _appMiddleware = di<AppMiddleware>();
  final AuthRepository _authRepository = di<AuthRepository>();

  Future<List<Event>> getEvents() async {
    final result = await _appMiddleware.getEvents();
    if (result is ResponseSuccessState<List<Event>>) {
      return result.responseData;
    }
    return [];
  }

  Future checkin({required int id, required String username}) async {
    emit(WaitingCheckinState());
    final result = await _appMiddleware.checkin(
      eventId: id,
      username: username,
    );
    if (result is ResponseSuccessState<bool>) {
      emit(CheckinSuccessState(username: username));
    } else if (result is ResponseFailedState) {
      emit(CheckinFailedState(result, username));
    }
  }
}
