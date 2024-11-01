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

class LandingNavigateToCallEvent extends LandingEvent {
  LandingDataModel data;
  String number;
  LandingNavigateToCallEvent({required this.data, required this.number});
}

class LandingRadioButtonEvent extends LandingEvent {
 final UserData selectedOption;
   LandingRadioButtonEvent({required this.selectedOption});
}

class LandingRequestPermissionEvent extends LandingEvent{
  
}
