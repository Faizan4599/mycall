part of 'landing_bloc.dart';

@immutable
sealed class LandingEvent {}

class LandingButtonColorTapEvent extends LandingEvent {
  bool isTap;
  LandingButtonColorTapEvent({required this.isTap});
}

class LandingGetDataEvent extends LandingEvent {
  LandingGetDataEvent();
}
