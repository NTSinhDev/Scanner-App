import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  @override
  Future<void> close() {
    log('Cubit: ${toString()} closed');
    return super.close();
  }

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    log('Cubit: $change');
  }
}
