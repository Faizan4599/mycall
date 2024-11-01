part of 'call_bloc.dart';

@immutable
sealed class CallEvent {}

class NavigateToCallEvent extends CallEvent {}
