// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'checkin_cubit.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class InitialState extends CheckInState {}

class WaitingCheckinState extends CheckInState {}

class CheckinSuccessState extends CheckInState {
  final String username;
  const CheckinSuccessState({required this.username});
}

class CheckinFailedState extends CheckInState {
  const CheckinFailedState(this.error, this.username);

  final ResponseFailedState error;
  final String username;
}
