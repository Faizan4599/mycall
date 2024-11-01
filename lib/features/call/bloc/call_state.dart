part of 'call_bloc.dart';

@immutable
sealed class CallState {}

final class CallInitial extends CallState {}

final class CallLoadingState extends CallState {}

final class CallErrorState extends CallState {}

final class CallNavigateToState extends CallState {}
