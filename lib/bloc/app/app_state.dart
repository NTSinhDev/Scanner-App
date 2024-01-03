// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitialState extends AppState {}

class LoggedInState extends AppState {}

class LoginFailedState extends AppState {}

class WaitingState extends AppState {}
