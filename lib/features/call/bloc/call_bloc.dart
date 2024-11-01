import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallInitial()) {
    on<NavigateToCallEvent>(navigateToCallEvent);
  }

  FutureOr<void> navigateToCallEvent(
      NavigateToCallEvent event, Emitter<CallState> emit) {}
}
